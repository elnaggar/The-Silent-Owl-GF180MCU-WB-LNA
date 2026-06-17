v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 320 -320 320 -290 {
lab=GND}
N 320 -290 320 -190 {
lab=GND}
N 320 -410 320 -380 {
lab=vddp}
N 320 -270 370 -270 {
lab=GND}
N 140 -390 180 -390 {
lab=in}
N 140 -330 180 -330 {
lab=GND}
N 140 -240 180 -240 {
lab=out}
N 140 -180 180 -180 {
lab=GND}
N 740 -320 740 -240 {
lab=vddp}
N 740 -350 740 -320 {
lab=vddp}
N 430 -270 460 -270 {
lab=vgdc}
N 670 -210 700 -210 {
lab=g}
N 540 -210 570 -210 {
lab=vgdc}
N 630 -210 670 -210 {
lab=g}
N 630 -290 650 -290 {
lab=g}
N 650 -290 650 -210 {
lab=g}
N 540 -290 570 -290 {
lab=in}
N 840 -130 880 -130 {
lab=out}
N 740 -210 770 -210 {
lab=vddp}
N 770 -250 770 -210 {
lab=vddp}
N 740 -250 770 -250 {
lab=vddp}
N 740 -180 740 -160 {
lab=d}
N 740 -50 740 -20 {
lab=GND}
N 740 -160 740 -110 {
lab=d}
N 740 -130 780 -130 {
lab=d}
C {vsource.sym} 400 -270 1 0 {name=VGS value=\{VG_BIAS\} savecurrent=false}
C {gnd.sym} 740 -20 0 0 {name=l1 lab=GND}
C {code_shown.sym} 200 40 0 0 {name=s1 only_toplevel=false value=".include /home/ttuser/xschem_projects/gf180_test/pmos_nfmin.spice"}
C {vsource.sym} 320 -350 0 0 {name=VDS value=\{VDDP\} savecurrent=false}
C {ind.sym} 740 -80 2 0 {name=LDD
m=1
value=1u
footprint=1206
device=inductor}
C {res.sym} 600 -210 3 0 {name=RG
value=1G
footprint=1206
device=resistor
m=1}
C {capa.sym} 810 -130 3 0 {name=COUT
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 740 -150 0 0 {name=p3 sig_type=std_logic lab=d}
C {lab_pin.sym} 180 -390 2 0 {name=p5 sig_type=std_logic lab=in}
C {lab_pin.sym} 180 -330 2 0 {name=p6 sig_type=std_logic lab=GND

}
C {lab_pin.sym} 180 -240 2 0 {name=p7 sig_type=std_logic lab=out}
C {lab_pin.sym} 180 -180 2 0 {name=p8 sig_type=std_logic lab=GND}
C {capa.sym} 600 -290 3 0 {name=CIN
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 320 -190 0 0 {name=l3 lab=GND}
C {lab_pin.sym} 320 -410 0 0 {name=p10 sig_type=std_logic lab=vddp

}
C {lab_pin.sym} 670 -210 0 0 {name=p4 sig_type=std_logic lab=g}
C {lab_pin.sym} 460 -270 2 0 {name=p9 sig_type=std_logic lab=vgdc}
C {lab_pin.sym} 740 -350 0 0 {name=p11 sig_type=std_logic lab=vddp
}
C {lab_pin.sym} 540 -210 0 0 {name=p12 sig_type=std_logic lab=vgdc}
C {lab_pin.sym} 540 -290 0 0 {name=p13 sig_type=std_logic lab=in}
C {lab_pin.sym} 880 -130 2 0 {name=p14 sig_type=std_logic lab=out}
C {symbols/pfet_03v3.sym} 720 -210 0 0 {name=M2
L=\{L\}
W=\{W\}
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {port_diff.sym} 140 -360 0 0 {name=V1 portnum=1 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=""}
C {port_diff.sym} 140 -210 0 0 {name=V2 portnum=2 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=""}
