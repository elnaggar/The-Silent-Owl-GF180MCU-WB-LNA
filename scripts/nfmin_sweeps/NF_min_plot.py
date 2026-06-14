import pandas as pd
import matplotlib.pyplot as plt

# NMOS
nmos_jd = pd.read_csv("nmos_jd.txt", sep=r"\s+")
nmos_nf = pd.read_csv("nmos_nf.txt", sep=r"\s+")

nmos = pd.merge(nmos_jd, nmos_nf, on="VGS")

print("NMOS data:")
print(nmos)

# PMOS
pmos_jd = pd.read_csv("pmos_jd.txt", sep=r"\s+")
pmos_nf = pd.read_csv("pmos_nf.txt", sep=r"\s+")

pmos = pd.merge(pmos_jd, pmos_nf, on="VSG")

print("\nPMOS data:")
print(pmos)

# Plot both
plt.figure()

plt.semilogx(
    nmos["JD_mA_per_um"],
    nmos["NFmin_dB"],
    marker="o",
    label="NMOS"
)

plt.semilogx(
    pmos["JD_mA_per_um"],
    pmos["NFmin_dB"],
    marker="s",
    label="PMOS"
)

plt.xlabel("Jd [mA/um]")
plt.ylabel("NFmin [dB]")
plt.title("NMOS and PMOS NFmin vs Drain Current Density")
plt.grid(True, which="both")
plt.legend()
plt.show()