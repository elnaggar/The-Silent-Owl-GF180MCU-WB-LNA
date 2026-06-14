import pandas as pd
import matplotlib.pyplot as plt

jd = pd.read_csv("inv_geom_jd.txt", sep=r"\s+")
nf = pd.read_csv("inv_geom_nf.txt", sep=r"\s+")

data = pd.merge(
    jd,
    nf,
    on=["N_W_m", "N_L_m", "P_W_m", "P_L_m", "VCM"]
)

data["N_W_um"] = data["N_W_m"] * 1e6
data["N_L_um"] = data["N_L_m"] * 1e6
data["P_W_um"] = data["P_W_m"] * 1e6
data["P_L_um"] = data["P_L_m"] * 1e6
data["Wp_over_Wn"] = data["P_W_m"] / data["N_W_m"]

print(data)

# Absolute best NFmin point
best = data.loc[data["NFmin_dB"].idxmin()]

print("\nAbsolute best NFmin point:")
print(best[[
    "N_W_um", "N_L_um", "P_W_um", "P_L_um", "Wp_over_Wn",
    "VCM", "VOUT_DC", "ID_A",
    "JD_N_mA_per_um", "JD_P_mA_per_um",
    "NFmin_dB", "NF_dB", "Rn", "SOpt_real", "SOpt_imag"
]])

practical = data[
    (data["VOUT_DC"] > 0.1) &
    (data["VOUT_DC"] < 1.7) &
    (data["ID_A"] > 1e-8)
]

best_practical = practical.loc[practical["NFmin_dB"].idxmin()]

print("\nBest practical NFmin point:")
print(best_practical[[
    "N_W_um", "N_L_um", "P_W_um", "P_L_um", "Wp_over_Wn",
    "VCM", "VOUT_DC", "ID_A",
    "JD_N_mA_per_um", "JD_P_mA_per_um",
    "NFmin_dB", "NF_dB", "Rn", "SOpt_real", "SOpt_imag"
]])

# Best point per geometry
best_each_geom = practical.loc[
    practical.groupby(["N_W_um", "N_L_um", "P_W_um", "P_L_um"])["NFmin_dB"].idxmin()
]

best_each_geom = best_each_geom.sort_values("NFmin_dB")

print("\nBest practical point per geometry:")
print(best_each_geom[[
    "N_W_um", "N_L_um", "P_W_um", "P_L_um", "Wp_over_Wn",
    "VCM", "VOUT_DC", "ID_A",
    "JD_N_mA_per_um", "JD_P_mA_per_um",
    "NFmin_dB", "NF_dB", "Rn"
]].head(20))