v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 340 -430 340 -400 {
lab=GND}
N 340 -400 340 -300 {
lab=GND}
N 340 -520 340 -490 {
lab=vdd}
N 340 -380 390 -380 {
lab=GND}
N 160 -500 200 -500 {
lab=in}
N 160 -440 200 -440 {
lab=GND}
N 160 -350 200 -350 {
lab=out}
N 160 -290 200 -290 {
lab=GND}
N 780 -590 780 -510 {
lab=vdd}
N 780 -620 780 -590 {
lab=vdd}
N 450 -380 480 -380 {
lab=vgdc}
N 570 -350 600 -350 {
lab=vgdc}
N 660 -350 700 -350 {
lab=g}
N 660 -430 680 -430 {
lab=g}
N 680 -430 680 -350 {
lab=g}
N 570 -430 600 -430 {
lab=in}
N 920 -400 960 -400 {
lab=out}
N 780 -480 810 -480 {
lab=vdd}
N 810 -520 810 -480 {
lab=vdd}
N 780 -520 810 -520 {
lab=vdd}
N 820 -400 860 -400 {
lab=d}
N 780 -240 780 -190 {
lab=GND}
N 780 -270 800 -270 {
lab=GND}
N 800 -270 800 -230 {
lab=GND}
N 780 -230 800 -230 {
lab=GND}
N 780 -450 780 -300 {
lab=d}
N 720 -480 740 -480 {
lab=g}
N 720 -480 720 -270 {
lab=g}
N 720 -270 740 -270 {
lab=g}
N 700 -350 720 -350 {
lab=g}
N 780 -400 820 -400 {
lab=d}
C {vsource.sym} 420 -380 1 0 {name=VCM value=\{VCM\} savecurrent=false}
C {code_shown.sym} 220 -70 0 0 {name=s1 only_toplevel=false value=".include /home/ttuser/xschem_projects/gf180_test/inv_nfmin.spice"}
C {vsource.sym} 340 -460 0 0 {name=VVDD value=\{VDD\} savecurrent=false}
C {res.sym} 630 -350 3 0 {name=RG
value=1G
footprint=1206
device=resistor
m=1}
C {capa.sym} 890 -400 3 0 {name=COUT
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 780 -420 0 0 {name=p3 sig_type=std_logic lab=d}
C {lab_pin.sym} 200 -500 2 0 {name=p5 sig_type=std_logic lab=in}
C {lab_pin.sym} 200 -440 2 0 {name=p6 sig_type=std_logic lab=GND

}
C {lab_pin.sym} 200 -350 2 0 {name=p7 sig_type=std_logic lab=out}
C {lab_pin.sym} 200 -290 2 0 {name=p8 sig_type=std_logic lab=GND}
C {capa.sym} 630 -430 3 0 {name=CIN
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 340 -300 0 0 {name=l3 lab=GND}
C {lab_pin.sym} 340 -520 0 0 {name=p10 sig_type=std_logic lab=vdd

}
C {lab_pin.sym} 700 -350 0 0 {name=p4 sig_type=std_logic lab=g}
C {lab_pin.sym} 480 -380 2 0 {name=p9 sig_type=std_logic lab=vgdc}
C {lab_pin.sym} 780 -620 0 0 {name=p11 sig_type=std_logic lab=vdd
}
C {lab_pin.sym} 570 -350 0 0 {name=p12 sig_type=std_logic lab=vgdc}
C {lab_pin.sym} 570 -430 0 0 {name=p13 sig_type=std_logic lab=in}
C {lab_pin.sym} 960 -400 2 0 {name=p14 sig_type=std_logic lab=out}
C {symbols/pfet_03v3.sym} 760 -480 0 0 {name=M2
L=\{P_L\}
W=\{P_W\}
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
C {symbols/nfet_03v3.sym} 760 -270 0 0 {name=M1
L=\{N_L\}
W=\{N_W\}
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
C {gnd.sym} 780 -190 0 0 {name=l2 lab=GND}
C {port_diff.sym} 160 -470 0 0 {name=V1 portnum=1 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=""}
C {port_diff.sym} 160 -320 0 0 {name=V2 portnum=2 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=""}
