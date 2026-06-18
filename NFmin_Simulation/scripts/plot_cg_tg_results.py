from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt


SCRIPT_DIR = Path(__file__).resolve().parent
NFMIN_ROOT = SCRIPT_DIR.parent

SIM_DIR = NFMIN_ROOT / "simulations"
SIM_RUN_DIR = SIM_DIR / "simulation"
RESULTS_DIR = NFMIN_ROOT / "results"
PLOTS_DIR = RESULTS_DIR / "plots"

PLOTS_DIR.mkdir(parents=True, exist_ok=True)


def find_file(filename: str) -> Path:
    """
    Search common ngspice output locations.
    """
    candidates = [
        SIM_RUN_DIR / filename,
        SIM_DIR / filename,
        RESULTS_DIR / filename,
    ]

    for path in candidates:
        if path.exists():
            return path

    raise FileNotFoundError(
        f"Could not find {filename}. Checked:\n"
        + "\n".join(str(p) for p in candidates)
    )


def read_table(filename: str) -> pd.DataFrame:
    path = find_file(filename)
    print(f"Reading {path}")
    return pd.read_csv(path, sep=r"\s+")


def save_plot(name: str):
    out = PLOTS_DIR / name
    plt.savefig(out, dpi=300, bbox_inches="tight")
    print(f"Saved {out}")
    plt.close()


def plot_mos_cg(device_name: str, jd_file: str, nf_file: str, bias_col: str):
    """
    Plot NMOS/PMOS common-gate NFmin vs JD.
    """
    jd = read_table(jd_file)
    nf = read_table(nf_file)

    merge_cols = ["W_m", "L_m", bias_col]
    data = pd.merge(jd, nf, on=merge_cols)

    data["W_um"] = data["W_m"] * 1e6
    data["L_um"] = data["L_m"] * 1e6

    data = data.sort_values(["L_um", "W_um", "JD_mA_per_um"])

    best = data.loc[data["NFmin_dB"].idxmin()]
    print(f"\nBest {device_name} CG point:")
    print(best)

    best_each_geom = (
        data.loc[data.groupby(["W_um", "L_um"])["NFmin_dB"].idxmin()]
        .sort_values("NFmin_dB")
    )

    best_csv = RESULTS_DIR / f"{device_name.lower()}_cg_best_each_geometry.csv"
    best_each_geom.to_csv(best_csv, index=False)
    print(f"Saved {best_csv}")

    # Plot all L=minimum length curves
    min_l = data["L_um"].min()
    plot_data = data[data["L_um"].round(4) == round(min_l, 4)]

    plt.figure()
    for w, group in plot_data.groupby("W_um"):
        group = group[group["JD_mA_per_um"] > 0].sort_values("JD_mA_per_um")
        plt.semilogx(
            group["JD_mA_per_um"],
            group["NFmin_dB"],
            marker="o",
            label=f"W={w:g} µm, L={min_l:g} µm",
        )

    plt.xlabel("JD [mA/µm]")
    plt.ylabel("NFmin [dB]")
    plt.title(f"{device_name} Common-Gate NFmin vs JD")
    plt.grid(True, which="both")
    plt.legend()
    save_plot(f"{device_name.lower()}_cg_nfmin_vs_jd.png")

    # NF_50ohm vs JD
    plt.figure()
    for w, group in plot_data.groupby("W_um"):
        group = group[group["JD_mA_per_um"] > 0].sort_values("JD_mA_per_um")
        plt.semilogx(
            group["JD_mA_per_um"],
            group["NF_dB"],
            marker="o",
            label=f"W={w:g} µm, L={min_l:g} µm",
        )

    plt.xlabel("JD [mA/µm]")
    plt.ylabel("NF at 50 Ω [dB]")
    plt.title(f"{device_name} Common-Gate 50 Ω NF vs JD")
    plt.grid(True, which="both")
    plt.legend()
    save_plot(f"{device_name.lower()}_cg_nf50_vs_jd.png")

    # Rn vs JD
    plt.figure()
    for w, group in plot_data.groupby("W_um"):
        group = group[group["JD_mA_per_um"] > 0].sort_values("JD_mA_per_um")
        plt.semilogx(
            group["JD_mA_per_um"],
            group["Rn"],
            marker="o",
            label=f"W={w:g} µm, L={min_l:g} µm",
        )

    plt.xlabel("JD [mA/µm]")
    plt.ylabel("Rn [Ω]")
    plt.title(f"{device_name} Common-Gate Rn vs JD")
    plt.grid(True, which="both")
    plt.legend()
    save_plot(f"{device_name.lower()}_cg_rn_vs_jd.png")


def plot_cmos_tg_cg():
    """
    Plot CMOS transmission-gate-like common-gate results.

    This uses VON as the main x-axis because the TG-CG structure may have
    very small or ambiguous DC current when VINCM = VOUTCM.
    """
    nf = read_table("cmos_tg_cg_nf_dense.txt")

    nf["N_W_um"] = nf["N_W_m"] * 1e6
    nf["N_L_um"] = nf["N_L_m"] * 1e6
    nf["P_W_um"] = nf["P_W_m"] * 1e6
    nf["P_L_um"] = nf["P_L_m"] * 1e6
    nf["Wp_over_Wn"] = nf["P_W_m"] / nf["N_W_m"]

    best = nf.loc[nf["NFmin_dB"].idxmin()]
    print("\nBest CMOS TG-CG point:")
    print(best)

    best_each_geom = (
        nf.loc[nf.groupby(["N_W_um", "N_L_um", "P_W_um", "P_L_um"])["NFmin_dB"].idxmin()]
        .sort_values("NFmin_dB")
    )

    best_csv = RESULTS_DIR / "cmos_tg_cg_best_each_geometry.csv"
    best_each_geom.to_csv(best_csv, index=False)
    print(f"Saved {best_csv}")

    # Plot top 6 geometries by minimum NFmin
    top_geoms = best_each_geom.head(6)

    plt.figure()
    for _, row in top_geoms.iterrows():
        group = nf[
            (nf["N_W_um"] == row["N_W_um"])
            & (nf["N_L_um"] == row["N_L_um"])
            & (nf["P_W_um"] == row["P_W_um"])
            & (nf["P_L_um"] == row["P_L_um"])
        ].sort_values("VON")

        label = (
            f"Wn={row['N_W_um']:g}µm/Ln={row['N_L_um']:g}µm, "
            f"Wp={row['P_W_um']:g}µm/Lp={row['P_L_um']:g}µm"
        )

        plt.plot(group["VON"], group["NFmin_dB"], marker="o", label=label)

    plt.xlabel("VON [V]")
    plt.ylabel("NFmin [dB]")
    plt.title("CMOS TG-CG NFmin vs Gate Overdrive")
    plt.grid(True)
    plt.legend()
    save_plot("cmos_tg_cg_nfmin_vs_von_top_geometries.png")

    # Plot NF_50Ω for top geometries
    plt.figure()
    for _, row in top_geoms.iterrows():
        group = nf[
            (nf["N_W_um"] == row["N_W_um"])
            & (nf["N_L_um"] == row["N_L_um"])
            & (nf["P_W_um"] == row["P_W_um"])
            & (nf["P_L_um"] == row["P_L_um"])
        ].sort_values("VON")

        label = (
            f"Wn={row['N_W_um']:g}µm/Ln={row['N_L_um']:g}µm, "
            f"Wp={row['P_W_um']:g}µm/Lp={row['P_L_um']:g}µm"
        )

        plt.plot(group["VON"], group["NF_dB"], marker="o", label=label)

    plt.xlabel("VON [V]")
    plt.ylabel("NF at 50 Ω [dB]")
    plt.title("CMOS TG-CG 50 Ω NF vs Gate Overdrive")
    plt.grid(True)
    plt.legend()
    save_plot("cmos_tg_cg_nf50_vs_von_top_geometries.png")

    # Optional: if JD file has JD_EQ column, plot NFmin vs JD_EQ
    try:
        jd = read_table("cmos_tg_cg_jd_dense.txt")

        if "JD_EQ_mA_per_um" in jd.columns:
            merge_cols = [
                "N_W_m",
                "N_L_m",
                "P_W_m",
                "P_L_m",
                "VCM",
                "VON",
                "VGN",
                "VGP",
            ]

            data = pd.merge(jd, nf, on=merge_cols)
            data = data[data["JD_EQ_mA_per_um"] > 0]

            plt.figure()
            for _, row in top_geoms.iterrows():
                group = data[
                    (data["N_W_um"] == row["N_W_um"])
                    & (data["N_L_um"] == row["N_L_um"])
                    & (data["P_W_um"] == row["P_W_um"])
                    & (data["P_L_um"] == row["P_L_um"])
                ].sort_values("JD_EQ_mA_per_um")

                label = (
                    f"Wn={row['N_W_um']:g}µm, "
                    f"Wp={row['P_W_um']:g}µm"
                )

                plt.semilogx(
                    group["JD_EQ_mA_per_um"],
                    group["NFmin_dB"],
                    marker="o",
                    label=label,
                )

            plt.xlabel("Equivalent JD [mA/µm]")
            plt.ylabel("NFmin [dB]")
            plt.title("CMOS TG-CG NFmin vs Equivalent JD")
            plt.grid(True, which="both")
            plt.legend()
            save_plot("cmos_tg_cg_nfmin_vs_jd_eq.png")

    except FileNotFoundError:
        print("No CMOS TG-CG JD file found. Skipping JD_EQ plot.")


def main():
    # NMOS common-gate
    try:
        plot_mos_cg(
            device_name="NMOS",
            jd_file="nmos_cg_geom_jd_dense.txt",
            nf_file="nmos_cg_geom_nf_dense.txt",
            bias_col="VGS",
        )
    except FileNotFoundError as e:
        print(f"Skipping NMOS CG: {e}")

    # PMOS common-gate
    try:
        plot_mos_cg(
            device_name="PMOS",
            jd_file="pmos_cg_geom_jd_dense.txt",
            nf_file="pmos_cg_geom_nf_dense.txt",
            bias_col="VSG",
        )
    except FileNotFoundError as e:
        print(f"Skipping PMOS CG: {e}")

    # CMOS transmission-gate-like common-gate
    try:
        plot_cmos_tg_cg()
    except FileNotFoundError as e:
        print(f"Skipping CMOS TG-CG: {e}")


if __name__ == "__main__":
    main()