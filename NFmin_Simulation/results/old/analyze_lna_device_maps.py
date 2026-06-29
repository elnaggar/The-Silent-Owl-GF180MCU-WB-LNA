#!/usr/bin/env python3
"""
Analyze GF180 LNA device NFmin/JD sweeps.

This script:
  1. Finds *_jd*.txt and *_nf*.txt files.
  2. Pairs JD and NF files.
  3. Merges them by VDS/VSD, W, L, and VGS/VSG.
  4. Computes useful derived columns:
       W_um, L_um, |GammaOpt|, angle(GammaOpt), power estimate.
  5. Makes comparison plots:
       NFmin vs JD
       NF vs JD
       Rn vs JD
       |GammaOpt| vs JD
       angle(GammaOpt) vs JD
  6. Writes ranked candidate CSV files.

Recommended first comparison variable:
  JD_mA_per_um, not VGS/VSG.

Author: use for GF180 LNA device screening.
"""

from __future__ import annotations

import argparse
import math
import re
from pathlib import Path
from typing import Dict, List, Optional, Tuple

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


# -----------------------------
# User-adjustable defaults
# -----------------------------

DEFAULT_JD_MIN = 0.005      # mA/um
DEFAULT_JD_MAX = 0.30       # mA/um
DEFAULT_SOPT_MAG_MAX = 0.999
DEFAULT_TOP_N = 20


# -----------------------------
# Utility functions
# -----------------------------

def read_table(path: Path) -> pd.DataFrame:
    """Read ngspice echo text table with whitespace-separated columns."""
    df = pd.read_csv(path, sep=r"\s+", engine="python", comment="*")
    df.columns = [c.strip() for c in df.columns]
    return df


def normalize_columns(df: pd.DataFrame) -> pd.DataFrame:
    """
    Normalize different file formats to common names:
      SUPPLY_V, W_m, L_m, BIAS_V, ID_A, JD_mA_per_um, etc.
    """
    df = df.copy()

    rename_map = {}

    # Bias column
    for c in df.columns:
        if c in ["VGS", "VGS_V", "VSG", "VSG_V"]:
            rename_map[c] = "BIAS_V"

    # Supply column
    for c in df.columns:
        if c in ["VDS", "VDS_V", "VSD", "VSD_V", "VDDP", "VDDP_V"]:
            rename_map[c] = "SUPPLY_V"

    # Rn column
    for c in df.columns:
        if c in ["Rn", "Rn_Ohm", "RN", "RN_Ohm"]:
            rename_map[c] = "Rn_Ohm"

    df = df.rename(columns=rename_map)

    # Some old files may not include supply voltage column.
    if "SUPPLY_V" not in df.columns:
        df["SUPPLY_V"] = np.nan

    return df


def parse_metadata_from_filename(path: Path) -> Dict[str, str]:
    """
    Infer device/topology from filename.
    Examples:
      nmos06_geom_nf_nom5v.txt        -> device=nmos06, topology=CS
      nmos06_cg_geom_nf_nom5v.txt     -> device=nmos06, topology=CG
      pmos05_cg_geom_nf_nom5v.txt     -> device=pmos05, topology=CG
    """
    name = path.stem.lower()

    # Device family
    device = "unknown"
    if "nmos03" in name or "nfet03" in name or "03v3" in name:
        device = "nmos03"
    elif "nmos05" in name or "nfet05" in name or "05v0" in name:
        device = "nmos05"
    elif "nmos06" in name or "nfet06" in name or "06v0" in name:
        device = "nmos06"
    elif "pmos03" in name or "pfet03" in name:
        device = "pmos03"
    elif "pmos05" in name or "pfet05" in name:
        device = "pmos05"
    elif "pmos06" in name or "pfet06" in name:
        device = "pmos06"
    elif "nmos" in name:
        device = "nmos"
    elif "pmos" in name:
        device = "pmos"

    # Topology
    topology = "CG" if "_cg" in name or "cg_" in name else "CS"

    return {
        "device": device,
        "topology": topology,
    }


def canonical_pair_key(path: Path) -> str:
    """
    Convert jd/nf filenames into a common pair key.
    """
    name = path.stem.lower()

    # Remove common jd/nf identifiers while preserving device/topology tags.
    name = re.sub(r"_geom_(jd|nf)", "_geom", name)
    name = re.sub(r"_(jd|nf)_", "_", name)
    name = re.sub(r"_(jd|nf)$", "", name)

    return name


def find_pairs(data_dir: Path) -> List[Tuple[Path, Path]]:
    """
    Find JD/NF file pairs in directory.
    """
    txt_files = sorted(data_dir.glob("*.txt"))

    buckets: Dict[str, Dict[str, Path]] = {}

    for f in txt_files:
        low = f.name.lower()

        is_jd = ("jd" in low) and ("geom" in low or "dense" in low or "nom" in low)
        is_nf = ("nf" in low) and ("geom" in low or "dense" in low or "nom" in low)

        if not (is_jd or is_nf):
            continue

        key = canonical_pair_key(f)
        buckets.setdefault(key, {})

        if is_jd:
            buckets[key]["jd"] = f
        if is_nf:
            buckets[key]["nf"] = f

    pairs = []
    for key, d in buckets.items():
        if "jd" in d and "nf" in d:
            pairs.append((d["jd"], d["nf"]))
        else:
            print(f"[WARN] Incomplete pair for key={key}: {d}")

    return pairs


def merge_jd_nf(jd_path: Path, nf_path: Path) -> pd.DataFrame:
    jd = normalize_columns(read_table(jd_path))
    nf = normalize_columns(read_table(nf_path))

    meta = parse_metadata_from_filename(nf_path)

    # Required columns
    for col in ["W_m", "L_m", "BIAS_V"]:
        if col not in jd.columns:
            raise ValueError(f"{jd_path} missing required column {col}")
        if col not in nf.columns:
            raise ValueError(f"{nf_path} missing required column {col}")

    # Merge keys. If SUPPLY_V is all NaN in old file, do not use it.
    keys = ["W_m", "L_m", "BIAS_V"]
    if not jd["SUPPLY_V"].isna().all() and not nf["SUPPLY_V"].isna().all():
        keys = ["SUPPLY_V"] + keys

    merged = pd.merge(
        jd,
        nf,
        on=keys,
        how="inner",
        suffixes=("_jd", "_nf"),
    )

    if "SUPPLY_V" not in merged.columns:
        merged["SUPPLY_V"] = np.nan

    merged["source_jd_file"] = jd_path.name
    merged["source_nf_file"] = nf_path.name
    merged["device"] = meta["device"]
    merged["topology"] = meta["topology"]

    # Derived columns
    merged["W_um"] = merged["W_m"] * 1e6
    merged["L_um"] = merged["L_m"] * 1e6

    if "ID_A" in merged.columns:
        merged["Pdc_W"] = merged["ID_A"] * merged["SUPPLY_V"]
        merged["Pdc_mW"] = 1e3 * merged["Pdc_W"]
    else:
        merged["Pdc_W"] = np.nan
        merged["Pdc_mW"] = np.nan

    if "SOpt_real" in merged.columns and "SOpt_imag" in merged.columns:
        gamma = merged["SOpt_real"].to_numpy() + 1j * merged["SOpt_imag"].to_numpy()
        merged["GammaOpt_mag"] = np.abs(gamma)
        merged["GammaOpt_angle_deg"] = np.angle(gamma, deg=True)
    else:
        merged["GammaOpt_mag"] = np.nan
        merged["GammaOpt_angle_deg"] = np.nan

    # Useful combined label
    merged["device_topology"] = merged["device"] + "_" + merged["topology"]

    print(f"\n[PAIR]")
    print(f"  JD file: {jd_path.name}, rows={len(jd)}")
    print(f"  NF file: {nf_path.name}, rows={len(nf)}")
    print(f"  merged rows={len(merged)}")
    if len(jd) != len(nf):
        print("  [WARN] JD/NF row counts differ. Merge used only common bias points.")

    if len(merged) > 0:
        last = merged.iloc[-1]
        print(
            f"  last merged point: "
            f"V={last.get('SUPPLY_V', np.nan)}, "
            f"W={last['W_um']:.3g}um, "
            f"L={last['L_um']:.3g}um, "
            f"bias={last['BIAS_V']:.4g}V"
        )

    return merged


def make_line_plot(
    df: pd.DataFrame,
    x: str,
    y: str,
    out_path: Path,
    title: str,
    ylabel: str,
    xlabel: str = "JD (mA/um)",
    group_cols: Tuple[str, ...] = ("device_topology", "L_um"),
    max_lines: int = 80,
):
    """
    Make line plot grouped by device/topology/L.
    """
    plot_df = df.dropna(subset=[x, y]).copy()
    if plot_df.empty:
        print(f"[WARN] No data for plot {out_path.name}")
        return

    fig = plt.figure(figsize=(9, 6))
    ax = fig.add_subplot(111)

    groups = list(plot_df.groupby(list(group_cols)))
    if len(groups) > max_lines:
        print(f"[WARN] Too many groups for {out_path.name}; plotting first {max_lines}.")
        groups = groups[:max_lines]

    for key, g in groups:
        g = g.sort_values(x)
        label = key if isinstance(key, str) else ", ".join([str(k) for k in key])
        ax.plot(g[x], g[y], marker=".", linewidth=1.0, markersize=2.5, label=label)

    ax.set_xscale("log")
    ax.set_xlabel(xlabel)
    ax.set_ylabel(ylabel)
    ax.set_title(title)
    ax.grid(True, which="both", linestyle=":")
    ax.legend(fontsize=7, ncol=2)
    fig.tight_layout()
    fig.savefig(out_path, dpi=200)
    plt.close(fig)


def make_envelope_plot(
    df: pd.DataFrame,
    y: str,
    out_path: Path,
    title: str,
    ylabel: str,
    jd_col: str = "JD_mA_per_um",
    bins: int = 60,
):
    """
    Compare devices by envelope:
      for each device_topology, bin JD and plot minimum y in each bin.
    This is cleaner than plotting thousands of raw points.
    """
    d = df.dropna(subset=[jd_col, y]).copy()
    d = d[(d[jd_col] > 0) & np.isfinite(d[y])]
    if d.empty:
        print(f"[WARN] No data for envelope plot {out_path.name}")
        return

    jd_min = d[jd_col].min()
    jd_max = d[jd_col].max()
    if jd_min <= 0 or jd_max <= jd_min:
        print(f"[WARN] Bad JD range for envelope plot {out_path.name}")
        return

    edges = np.logspace(np.log10(jd_min), np.log10(jd_max), bins + 1)
    centers = np.sqrt(edges[:-1] * edges[1:])

    fig = plt.figure(figsize=(9, 6))
    ax = fig.add_subplot(111)

    for label, g in d.groupby("device_topology"):
        g = g.copy()
        g["bin"] = pd.cut(g[jd_col], edges, labels=False, include_lowest=True)
        env = g.groupby("bin", observed=True)[y].min()

        xs = []
        ys = []
        for b, val in env.items():
            if pd.notna(b) and 0 <= int(b) < len(centers):
                xs.append(centers[int(b)])
                ys.append(val)

        if xs:
            ax.plot(xs, ys, marker="o", linewidth=1.5, markersize=3, label=label)

    ax.set_xscale("log")
    ax.set_xlabel("JD (mA/um)")
    ax.set_ylabel(ylabel)
    ax.set_title(title)
    ax.grid(True, which="both", linestyle=":")
    ax.legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(out_path, dpi=200)
    plt.close(fig)


def select_candidates(
    df: pd.DataFrame,
    jd_min: float,
    jd_max: float,
    sopt_mag_max: float,
    top_n: int,
) -> pd.DataFrame:
    """
    Select useful candidate bias points.

    Candidate rules:
      - finite NFmin, NF, Rn
      - JD in selected range
      - |GammaOpt| less than limit if available
      - rank by NFmin first
      - also include useful context columns
    """
    d = df.copy()

    needed = ["JD_mA_per_um", "NFmin_dB", "NF_dB", "Rn_Ohm"]
    for c in needed:
        if c not in d.columns:
            d[c] = np.nan

    mask = (
        np.isfinite(d["JD_mA_per_um"])
        & np.isfinite(d["NFmin_dB"])
        & np.isfinite(d["NF_dB"])
        & np.isfinite(d["Rn_Ohm"])
        & (d["JD_mA_per_um"] >= jd_min)
        & (d["JD_mA_per_um"] <= jd_max)
        & (d["Rn_Ohm"] > 0)
    )

    if "GammaOpt_mag" in d.columns:
        mask &= np.isfinite(d["GammaOpt_mag"]) & (d["GammaOpt_mag"] <= sopt_mag_max)

    d = d[mask].copy()

    if d.empty:
        return d

    # Sort key: primarily NFmin, then NF at 50 ohm, then lower power/current.
    sort_cols = ["device_topology", "NFmin_dB", "NF_dB", "Pdc_mW"]
    for c in sort_cols:
        if c not in d.columns:
            d[c] = np.nan

    d = d.sort_values(["device_topology", "NFmin_dB", "NF_dB", "Pdc_mW"])

    selected = []
    for label, g in d.groupby("device_topology"):
        selected.append(g.head(top_n))

    out = pd.concat(selected, ignore_index=True)

    cols = [
        "device",
        "topology",
        "SUPPLY_V",
        "W_um",
        "L_um",
        "BIAS_V",
        "ID_A",
        "JD_mA_per_um",
        "Pdc_mW",
        "NFmin_dB",
        "NF_dB",
        "Rn_Ohm",
        "GammaOpt_mag",
        "GammaOpt_angle_deg",
        "SOpt_real",
        "SOpt_imag",
        "source_jd_file",
        "source_nf_file",
    ]

    cols = [c for c in cols if c in out.columns]
    return out[cols]


def summarize_by_device(df: pd.DataFrame, jd_min: float, jd_max: float) -> pd.DataFrame:
    """
    Make compact summary per device/topology.
    """
    d = df.copy()
    d = d[
        np.isfinite(d["JD_mA_per_um"])
        & (d["JD_mA_per_um"] >= jd_min)
        & (d["JD_mA_per_um"] <= jd_max)
    ]

    rows = []
    for label, g in d.groupby("device_topology"):
        if g.empty:
            continue

        best_nfmin = g.loc[g["NFmin_dB"].idxmin()]
        best_nf50 = g.loc[g["NF_dB"].idxmin()]

        rows.append({
            "device_topology": label,
            "n_points_used": len(g),

            "best_NFmin_dB": best_nfmin["NFmin_dB"],
            "best_NFmin_W_um": best_nfmin["W_um"],
            "best_NFmin_L_um": best_nfmin["L_um"],
            "best_NFmin_bias_V": best_nfmin["BIAS_V"],
            "best_NFmin_JD_mA_per_um": best_nfmin["JD_mA_per_um"],
            "best_NFmin_ID_A": best_nfmin.get("ID_A", np.nan),
            "best_NFmin_Pdc_mW": best_nfmin.get("Pdc_mW", np.nan),
            "best_NFmin_GammaOpt_mag": best_nfmin.get("GammaOpt_mag", np.nan),

            "best_NF50_dB": best_nf50["NF_dB"],
            "best_NF50_W_um": best_nf50["W_um"],
            "best_NF50_L_um": best_nf50["L_um"],
            "best_NF50_bias_V": best_nf50["BIAS_V"],
            "best_NF50_JD_mA_per_um": best_nf50["JD_mA_per_um"],
            "best_NF50_ID_A": best_nf50.get("ID_A", np.nan),
            "best_NF50_Pdc_mW": best_nf50.get("Pdc_mW", np.nan),
            "best_NF50_GammaOpt_mag": best_nf50.get("GammaOpt_mag", np.nan),
        })

    return pd.DataFrame(rows)


def make_per_device_plots(df: pd.DataFrame, out_dir: Path):
    """
    Make detailed plots per device/topology, grouped by W and L.
    """
    for label, g0 in df.groupby("device_topology"):
        g0 = g0.copy()

        # To keep plots readable, one figure per L, lines by W.
        for L_um, g in g0.groupby("L_um"):
            tag = f"{label}_L{L_um:.3g}um".replace(".", "p")

            for y, ylabel in [
                ("NFmin_dB", "NFmin (dB)"),
                ("NF_dB", "NF with 50 ohm source (dB)"),
                ("Rn_Ohm", "Rn (ohm)"),
                ("GammaOpt_mag", "|GammaOpt|"),
            ]:
                if y not in g.columns:
                    continue

                fig = plt.figure(figsize=(8, 5.5))
                ax = fig.add_subplot(111)

                for W_um, gw in g.groupby("W_um"):
                    gw = gw.sort_values("JD_mA_per_um")
                    ax.plot(
                        gw["JD_mA_per_um"],
                        gw[y],
                        marker=".",
                        linewidth=1.0,
                        markersize=2.5,
                        label=f"W={W_um:.3g}um",
                    )

                ax.set_xscale("log")
                ax.set_xlabel("JD (mA/um)")
                ax.set_ylabel(ylabel)
                ax.set_title(f"{label}, L={L_um:.3g}um: {ylabel} vs JD")
                ax.grid(True, which="both", linestyle=":")
                ax.legend(fontsize=8)
                fig.tight_layout()
                fig.savefig(out_dir / f"{tag}_{y}_vs_JD.png", dpi=200)
                plt.close(fig)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--data-dir", type=str, default=".", help="Directory containing txt files")
    parser.add_argument("--out-dir", type=str, default="lna_plots", help="Output directory")
    parser.add_argument("--jd-min", type=float, default=DEFAULT_JD_MIN, help="Min JD for candidate ranking, mA/um")
    parser.add_argument("--jd-max", type=float, default=DEFAULT_JD_MAX, help="Max JD for candidate ranking, mA/um")
    parser.add_argument("--sopt-mag-max", type=float, default=DEFAULT_SOPT_MAG_MAX, help="Max |GammaOpt| for candidate ranking")
    parser.add_argument("--top-n", type=int, default=DEFAULT_TOP_N, help="Top N candidates per device/topology")
    args = parser.parse_args()

    data_dir = Path(args.data_dir).resolve()
    out_dir = Path(args.out_dir).resolve()
    out_dir.mkdir(parents=True, exist_ok=True)

    print(f"[INFO] data_dir = {data_dir}")
    print(f"[INFO] out_dir  = {out_dir}")

    pairs = find_pairs(data_dir)
    if not pairs:
        raise SystemExit("[ERROR] No JD/NF file pairs found.")

    all_data = []
    for jd_path, nf_path in pairs:
        try:
            merged = merge_jd_nf(jd_path, nf_path)
            if len(merged) > 0:
                all_data.append(merged)
        except Exception as e:
            print(f"[ERROR] Could not process pair:\n  {jd_path}\n  {nf_path}\n  {e}")

    if not all_data:
        raise SystemExit("[ERROR] No usable merged data.")

    df = pd.concat(all_data, ignore_index=True)

    # Save full merged data
    merged_csv = out_dir / "all_merged_device_data.csv"
    df.to_csv(merged_csv, index=False)
    print(f"[WRITE] {merged_csv}")

    # Summary
    summary = summarize_by_device(df, args.jd_min, args.jd_max)
    summary_csv = out_dir / "device_summary.csv"
    summary.to_csv(summary_csv, index=False)
    print(f"[WRITE] {summary_csv}")

    # Candidate selection
    candidates = select_candidates(
        df,
        jd_min=args.jd_min,
        jd_max=args.jd_max,
        sopt_mag_max=args.sopt_mag_max,
        top_n=args.top_n,
    )
    candidates_csv = out_dir / "ranked_candidate_bias_points.csv"
    candidates.to_csv(candidates_csv, index=False)
    print(f"[WRITE] {candidates_csv}")

    # Envelope comparison plots
    make_envelope_plot(
        df,
        y="NFmin_dB",
        out_path=out_dir / "COMPARE_envelope_NFmin_vs_JD.png",
        title="Best NFmin envelope vs JD",
        ylabel="minimum NFmin in JD bin (dB)",
    )

    make_envelope_plot(
        df,
        y="NF_dB",
        out_path=out_dir / "COMPARE_envelope_NF50_vs_JD.png",
        title="Best 50-ohm NF envelope vs JD",
        ylabel="minimum NF in JD bin (dB)",
    )

    make_envelope_plot(
        df,
        y="Rn_Ohm",
        out_path=out_dir / "COMPARE_envelope_Rn_vs_JD.png",
        title="Best Rn envelope vs JD",
        ylabel="minimum Rn in JD bin (ohm)",
    )

    # Global line plots
    make_line_plot(
        df,
        x="JD_mA_per_um",
        y="NFmin_dB",
        out_path=out_dir / "ALL_NFmin_vs_JD.png",
        title="NFmin vs JD",
        ylabel="NFmin (dB)",
    )

    make_line_plot(
        df,
        x="JD_mA_per_um",
        y="NF_dB",
        out_path=out_dir / "ALL_NF50_vs_JD.png",
        title="50-ohm NF vs JD",
        ylabel="NF with 50 ohm source (dB)",
    )

    make_line_plot(
        df,
        x="JD_mA_per_um",
        y="Rn_Ohm",
        out_path=out_dir / "ALL_Rn_vs_JD.png",
        title="Rn vs JD",
        ylabel="Rn (ohm)",
    )

    make_line_plot(
        df,
        x="JD_mA_per_um",
        y="GammaOpt_mag",
        out_path=out_dir / "ALL_GammaOpt_mag_vs_JD.png",
        title="|GammaOpt| vs JD",
        ylabel="|GammaOpt|",
    )

    make_line_plot(
        df,
        x="JD_mA_per_um",
        y="GammaOpt_angle_deg",
        out_path=out_dir / "ALL_GammaOpt_angle_vs_JD.png",
        title="Angle(GammaOpt) vs JD",
        ylabel="angle(GammaOpt) (deg)",
    )

    # Detailed per-device plots
    make_per_device_plots(df, out_dir)

    print("\n[DONE]")
    print("Main files to inspect:")
    print(f"  {merged_csv}")
    print(f"  {summary_csv}")
    print(f"  {candidates_csv}")
    print("\nMain plots:")
    print("  COMPARE_envelope_NFmin_vs_JD.png")
    print("  COMPARE_envelope_NF50_vs_JD.png")
    print("  ALL_NFmin_vs_JD.png")
    print("  ALL_NF50_vs_JD.png")
    print("  ALL_Rn_vs_JD.png")
    print("  ALL_GammaOpt_mag_vs_JD.png")


if __name__ == "__main__":
    main()