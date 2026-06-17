v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 250 -90 250 -40 {
lab=GND}
N -170 -230 -170 -200 {
lab=GND}
N 250 -120 270 -120 {
lab=GND}
N 270 -120 270 -80 {
lab=GND}
N 250 -80 270 -80 {
lab=GND}
N -170 -200 -170 -100 {
lab=GND}
N -170 -320 -170 -290 {
lab=vdcbias}
N -170 -180 -120 -180 {
lab=GND}
N -350 -300 -310 -300 {
lab=in}
N -350 -240 -310 -240 {
lab=GND}
N -350 -150 -310 -150 {
lab=out}
N -350 -90 -310 -90 {
lab=GND}
N 250 -230 250 -150 {
lab=d}
N 250 -320 250 -290 {
lab=vdcbias}
N -60 -180 -30 -180 {
lab=vgdc}
N 180 -120 210 -120 {
lab=g}
N 50 -120 80 -120 {
lab=vgdc}
N 140 -120 180 -120 {
lab=g}
N 140 -200 160 -200 {
lab=g}
N 160 -200 160 -120 {
lab=g}
N 50 -200 80 -200 {
lab=in}
N 250 -190 290 -190 {
lab=d}
N 350 -190 390 -190 {
lab=out}
C {symbols/nfet_03v3.sym} 230 -120 0 0 {name=M1
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
model=nfet_03v3
spiceprefix=X
}
C {vsource.sym} -90 -180 1 0 {name=VGS value=\{VBIAS\} savecurrent=false}
C {gnd.sym} 250 -40 0 0 {name=l1 lab=GND}
C {code_shown.sym} -210 50 0 0 {name=s1 only_toplevel=false value=".include /home/ttuser/xschem_projects/gf180_test/nmos_nfmin.spice"}
C {vsource.sym} -170 -260 0 0 {name=VDD value=\{VDS\} savecurrent=false}
C {ind.sym} 250 -260 2 0 {name=LDD
m=1
value=1u
footprint=1206
device=inductor}
C {res.sym} 110 -120 3 0 {name=RG
value=1G
footprint=1206
device=resistor
m=1}
C {capa.sym} 320 -190 3 0 {name=COUT
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 250 -180 0 0 {name=p3 sig_type=std_logic lab=d}
C {lab_pin.sym} -310 -300 2 0 {name=p5 sig_type=std_logic lab=in}
C {lab_pin.sym} -310 -240 2 0 {name=p6 sig_type=std_logic lab=GND

}
C {lab_pin.sym} -310 -150 2 0 {name=p7 sig_type=std_logic lab=out}
C {lab_pin.sym} -310 -90 2 0 {name=p8 sig_type=std_logic lab=GND}
C {capa.sym} 110 -200 3 0 {name=CIN
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} -170 -100 0 0 {name=l3 lab=GND}
C {lab_pin.sym} -170 -320 0 0 {name=p10 sig_type=std_logic lab=vdcbias
}
C {lab_pin.sym} 180 -120 0 0 {name=p4 sig_type=std_logic lab=g}
C {lab_pin.sym} -30 -180 2 0 {name=p9 sig_type=std_logic lab=vgdc}
C {lab_pin.sym} 250 -320 0 0 {name=p11 sig_type=std_logic lab=vdcbias
}
C {lab_pin.sym} 50 -120 0 0 {name=p12 sig_type=std_logic lab=vgdc}
C {lab_pin.sym} 50 -200 0 0 {name=p13 sig_type=std_logic lab=in}
C {lab_pin.sym} 390 -190 2 0 {name=p14 sig_type=std_logic lab=out}
C {port_diff.sym} -350 -270 0 0 {name=V1 portnum=1 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=""}
C {port_diff.sym} -350 -120 0 0 {name=V2 portnum=2 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=""}
