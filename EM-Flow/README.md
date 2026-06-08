# Automatic EM-Sim Flows for GF180MCUD-1P5M -TM11KA-MIMB
The provided scripts are able to use with the automatic flows for [openEMS](https://github.com/VolkerMuehlhaus/openems_ihp_sg13g2)
 and [Palace-AWS](https://github.com/VolkerMuehlhaus/gds2palace_ihp_sg13g2) from [Volker Muehlhaus](https://github.com/VolkerMuehlhaus).  
The flows were originally developed for [IHP-SG13G2 open-source PDK](https://github.com/IHP-GmbH/IHP-Open-PDK).  
You can inspect the stack by using [setupEM](https://github.com/VolkerMuehlhaus/setupEM).  
The Layers 'TPMIM', 'MIM_equiv' and 'VMIM' are only dedicated to simulate MIM caps. Their stack is adjusted to simulate MIM caps with 2.0 fF/µm².
 Other special passive structures in these three layers are not possible to be simulated correctly.  
Special thanks for [Volker Muehlhaus](https://github.com/VolkerMuehlhaus) for his guidance during this contribution.