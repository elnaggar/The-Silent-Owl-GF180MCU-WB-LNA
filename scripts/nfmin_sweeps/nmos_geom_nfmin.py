import pandas as pd
import matplotlib.pyplot as plt

jd = pd.read_csv("nmos_geom_jd.txt", sep=r"\s+")
nf = pd.read_csv("nmos_geom_nf.txt", sep=r"\s+")

data = pd.merge(jd, nf, on=["W_m", "L_m", "VGS"])

data["W_um"] = data["W_m"] * 1e6
data["L_um"] = data["L_m"] * 1e6

# Plot only Lmin curves
plot_data = data[data["L_um"].round(2) == 0.28]

plt.figure()

for w, group in plot_data.groupby("W_um"):
    group = group.sort_values("JD_mA_per_um")
    plt.semilogx(
        group["JD_mA_per_um"],
        group["NFmin_dB"],
        marker="o",
        label=f"W={w:g} µm, L=0.28 µm"
    )

plt.xlabel("Jd [mA/µm]")
plt.ylabel("NFmin [dB]")
plt.title("NMOS NFmin vs Drain Current Density, L=0.28 µm")
plt.grid(True, which="both")
plt.legend()
plt.tight_layout()
plt.show()