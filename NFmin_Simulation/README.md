# NFmin and Bias Characterization for GF180MCU LNA Design

This folder contains device-level characterization data and analysis scripts used before starting the LNA circuit design. The goal is to compare available GF180MCU NMOS devices for 2.4 GHz LNA use and identify realistic starting bias points for common-source and common-gate topologies.


## Folder Structure

Recommended project structure:

```text
NFmin_Simulation/
├── README.md
├── results/
│   ├── nmos03_cs_full_dense.txt
│   ├── nmos03_cg_full_dense.txt
│   ├── nmos05_cs_full_nom5v.txt
│   ├── nmos05_cg_full_nom5v.txt
│   ├── nmos06_cs_full_nom5v.txt
│   ├── nmos06_cg_full_nom5v.txt
│   ├── nmos10_cs_full_nom5v.txt
│   ├── nmos10_cg_full_nom5v.txt
│   └── lna_sweep_analysis/
├── scripts/
│   └── analyze_lna_sweeps.py
└── simulations/
    └── 03v0/05v0/06v0/10v0 xschem testbenches
```

The `.txt` files in `results/` are generated from ngspice sweeps. The Python analysis script reads these files and creates plots and text summaries in `results/lna_sweep_analysis/`.

## Devices and Topologies Characterized

The following NMOS devices were characterized:

| Device | Supply / Type | Topologies |
|---|---:|---|
| `nfet_03v3` | 3.3 V NMOS | CS, CG |
| `nfet_05v0` | 5 V NMOS | CS, CG |
| `nfet_06v0` | 6 V NMOS | CS, CG |
| `nfet_10v0_asym` | 10 V asymmetric LDNMOS | CS, CG |

Topologies:

| Abbreviation | Meaning |
|---|---|
| `CS` | Common-source |
| `CG` | Common-gate |

## Sweep Conditions

### 3.3 V Device

```text
VDS = 1.8 V and 3.3 V
W   = 0.22, 1, 5, 10, 20 um
L   = 0.28, 0.36, 0.50 um
VGS = 0.35 V to 1.50 V in 5 mV steps
```

### 5 V / 6 V Devices

```text
VDS = 5.0 V
W   = 0.30, 1, 5, 10, 20, 50 um
L   = 0.60, 0.70, 1.00 um
VGS = 0.50 V to 2.50 V in 5 mV steps
```

### 10 V Asymmetric LDNMOS

```text
VDS = 5.0 V
W   = 4, 5, 10, 20, 50 um
L   = 0.60, 0.70, 1.00 um
VGS = 0.50 V to 2.50 V in 5 mV steps
```

For the 10 V asymmetric LDNMOS, drain/source orientation must be kept correct:

```text
drain  = high-voltage drain side
source = RF input / GND-side source
```

## Running the Analysis Script

Place the analysis script here:

```text
NFmin_Simulation/scripts/analyze_lna_sweeps.py
```

Place the sweep `.txt` files here:

```text
NFmin_Simulation/results/
```

Then run:

```bash
cd NFmin_Simulation/scripts
python3 analyze_lna_sweeps.py

The script creates:

```text
results/lna_sweep_analysis/
├── summary_best_overall.txt
├── summary_best_by_device_topology.txt
├── summary_best_by_geometry.txt
├── summary_practical_score.txt
├── summary_design_shortlist.txt
├── summary_filter_report.txt
├── plots_all_data/
└── plots_filtered_usable/
```

### Plot Sets

Two plot sets are generated:

| Folder | Meaning |
|---|---|
| `plots_all_data/` | Raw sweep data before filtering |
| `plots_filtered_usable/` | Only practical LNA operating points after filtering |

This is useful because raw NFmin plots can show misleading near-off device points with extremely low `NFmin_dB`, but those points are not useful for an actual LNA.


## Practical Filtering

The script filters out operating points that are mathematically low-noise but not useful as LNA input devices.

Default filter:

```text
gm >= 1 mS
ID >= 10 uA
Pdc >= 0.01 mW
1/gm or Rin estimate <= 1000 ohm
CG Rin between 20 ohm and 200 ohm
```

Example of a rejected point:

```text
nfet_03v3 CS
W = 1 um
L = 0.50 um
VBIAS = 0.35 V
NFmin ≈ 0.0009 dB
gm ≈ 3.4 nS
1/gm ≈ 2.9e8 ohm
```

The filter can be changed from the command line:

```bash
python3 analyze_lna_sweeps.py --min-gm-s 1e-4 --max-inv-gm-ohm 10000
```


