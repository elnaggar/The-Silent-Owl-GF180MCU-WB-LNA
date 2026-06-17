v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 1055 -360 1665 -80 {flags=graph
y1=0.99260067
y2=1.0006007
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=1
x2=11.47
divx=5
subdivx=8
xlabmag=1.0
ylabmag=1.0
dataset=-1
unitx=1
logx=1
logy=0
rawfile=$netlist_dir/sp_analog_pad.raw
sim_type=sp
autoload=1
color="4 7"
node="s_1_1
s_2_2"}
B 2 1055 -640 1665 -360 {flags=graph
y1=-180
y2=-3e-07
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=1
x2=11.47
divx=5
subdivx=8
xlabmag=1.0
ylabmag=1.0
dataset=-1
unitx=1
logx=1
logy=0
rawfile=$netlist_dir/sp_analog_pad.raw
sim_type=sp
autoload=1
color="4 7"
node="ph(s_1_1)
ph(s_2_2)"}
N 780 -630 780 -570 {lab=Vin}
N 780 -510 780 -470 {lab=0}
N 500 -560 500 -510 {lab=0}
N 460 -560 460 -510 {lab=0}
N 460 -750 460 -700 {lab=DVDD}
N 500 -750 500 -700 {lab=VDD}
N 260 -660 260 -610 {lab=VDD}
N 180 -660 180 -610 {lab=DVDD}
N 260 -550 260 -500 {lab=0}
N 180 -550 180 -500 {lab=0}
N 620 -630 780 -630 {lab=Vin}
N 830 -270 830 -210 {lab=P_ASIG5V}
N 830 -140 830 -120 {lab=0}
N 830 -150 830 -140 {lab=0}
N 830 -120 830 -110 {lab=0}
N 300 -430 510 -430 {lab=#net1
}
N 300 -430 300 -300 {lab=#net1
}
N 300 -240 300 -110 {lab=0
}
N 300 -110 510 -110 {lab=0
}
N 510 -430 510 -380 {lab=#net1
}
N 510 -320 510 -220 {lab=P_ASIG5V
}
N 510 -160 510 -110 {lab=0
}
N 150 -430 150 -300 {lab=#net1
}
N 150 -430 300 -430 {lab=#net1
}
N 150 -240 150 -110 {lab=0
}
N 150 -110 300 -110 {lab=0
}
N 510 -270 830 -270 {lab=P_ASIG5V
}
N 510 -430 610 -430 {lab=#net1
}
N 670 -430 770 -430 {lab=P_DVDD
}
N 970 -430 970 -380 {lab=P_DVDD}
N 970 -320 970 -270 {lab=0}
N 770 -430 970 -430 {lab=P_DVDD}
N 510 -110 830 -110 {lab=0}
C {/foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_io/xschem/gf180mcu_fd_io__asig_5p0.sym} 470 -630 0 0 {name=x1
}
C {vsource.sym} 260 -580 0 0 {name=V_VDD value=-5 savecurrent=false}
C {vsource.sym} 180 -580 0 0 {name=V_DVDD value=-5 savecurrent=false}
C {lab_wire.sym} 500 -750 0 1 {name=p1 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 460 -750 0 0 {name=p2 sig_type=std_logic lab=DVDD}
C {lab_wire.sym} 180 -660 0 0 {name=p5 sig_type=std_logic lab=DVDD}
C {lab_wire.sym} 260 -660 0 0 {name=p6 sig_type=std_logic lab=VDD}
C {code_shown.sym} 1440 -810 0 0 {name=NGSPICE
only_toplevel=true
value="
.control
save all
sp dec 100 1e1 300e9 0
write sp_analog_pad.raw
.endc
" }
C {launcher.sym} 240 -795 0 0 {name=h1
descr="load waves" 
tclcommand="xschem raw_read $netlist_dir/sp_analog_pad.raw sp"}
C {code_shown.sym} 640 -815 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice moscap_typical
.lib $::180MCU_MODELS/sm141064.ngspice diode_typical
.include /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice
*.include /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_io/spice/gf180mcu_ef_io.spice
"}
C {lab_wire.sym} 780 -630 0 1 {name=p4 sig_type=std_logic lab=Vin}
C {title.sym} 180 -40 0 0 {name=l4 author="Ahmed Elnaggar/A38-SilentOwl"}
C {gnd.sym} 780 -470 0 0 {name=l1 lab=0}
C {gnd.sym} 500 -510 0 0 {name=l2 lab=0}
C {gnd.sym} 260 -500 0 0 {name=l3 lab=0}
C {gnd.sym} 460 -510 0 0 {name=l5 lab=0}
C {gnd.sym} 180 -500 0 0 {name=l6 lab=0}
C {gnd.sym} 830 -110 0 1 {name=l7 lab=0}
C {port_diff.sym} 830 -180 0 1 {name=V1 portnum=2 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=}
C {port_diff.sym} 780 -540 0 1 {name=V2 portnum=1 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=}
C {symbols/diode_nd2ps_06v0.sym} 300 -270 2 0 {name=D0
model=diode_nd2ps_06v0
r_w=40u
r_l=1u
m=4
}
C {symbols/diode_nd2ps_06v0.sym} 510 -190 2 0 {name=D2
model=diode_nd2ps_06v0
r_w=50u
r_l=3u
m=4
}
C {symbols/diode_pd2nw_06v0.sym} 510 -350 2 0 {name=D3
model=diode_pd2nw_06v0
r_w=50u
r_l=3u
m=4
}
C {symbols/cap_nmos_06v0.sym} 150 -270 0 1 {name=C1
W=15e-6
L=15e-6
model=cap_nmos_06v0
spiceprefix=X
m=36
}
C {lab_wire.sym} 970 -430 0 0 {name=p3 sig_type=std_logic lab=P_DVDD
}
C {lab_wire.sym} 510 -270 0 0 {name=p8 sig_type=std_logic lab=P_ASIG5V
}
C {ammeter.sym} 640 -430 1 0 {name=Vmeas savecurrent=true }
C {vsource.sym} 970 -350 0 0 {name=V_DVDD1 value=5 savecurrent=false}
C {gnd.sym} 970 -270 0 0 {name=l9 lab=0}
