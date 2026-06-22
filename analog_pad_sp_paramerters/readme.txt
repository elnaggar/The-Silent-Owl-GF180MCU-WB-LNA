*****************************************
* SSCS-Chipathon 2026                   *
* Team: The Silent Owl - SSCS Chipathon *
*****************************************
*******************
* Ahmed M Elnagar *
* JUN-19-2026     *
*******************
This directory is for simulating the S-Parameters of 5V Analog ESD Pad for GF180mcuD
Tools used: IIC-OSIC-TOOLS Docker Container by Dr.Herald Pretl

NB: 
---
For a simple and smooth simulations when using this main folder, add it in the following path:
/foss/designs/GF180/sscs_chipathon_26/LNA/analog_pad_sp_paramerters/
Otherwise you will have to update all the paths in the testbenches to point to the right files

Files:
------
1) extracted_pad: Contains the GDS file from the pdk file, extraction file, and extracted spice   

2) qucks_tb: Contains the qucs testbench for the pad for both extracted pad and unextracted pad

3) simulation: The default simulation directory

4) xschem: Contains the xschem schematic and testbenches

5) spice_files: Contains the spice netlist for the 5V analog pad with its subcircuit wrapper
