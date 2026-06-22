v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 35 -740 645 -460 {flags=graph
y1=0.97
y2=0.98
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=3
x2=9.69897
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
color=4
node=s_1_1}
B 2 675 -740 1285 -460 {flags=graph
y1=-180
y2=-170
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=3
x2=9.69897
divx=5
subdivx=8
xlabmag=1.0
ylabmag=1.0
dataset=-1
unitx=1
logx=1
logy=0
sim_type=sp
autoload=1
color=4
node=ph(s_1_1)}
B 2 1315 -740 1925 -460 {flags=graph
y1=1e-35
y2=0.01
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=3
x2=9.69897
divx=5
subdivx=8
xlabmag=1.0
ylabmag=1.0
dataset=-1
unitx=1
logx=1
logy=0
sim_type=sp
autoload=1
color=4
node=s_2_2}
P 4 4 545 -265 555 -270 555 -260 545 -265 {fill=1}
P 4 3 555 -265 580 -265 580 -210 {}
N 640 -240 640 -200 {lab=0}
N 400 -230 400 -180 {lab=0}
N 360 -230 360 -180 {lab=0}
N 360 -420 360 -370 {lab=DVDD}
N 400 -420 400 -370 {lab=VDD}
N 160 -330 160 -280 {lab=VDD}
N 80 -330 80 -280 {lab=DVDD}
N 160 -220 160 -170 {lab=0}
N 80 -220 80 -170 {lab=0}
N 520 -300 680 -300 {lab=Vin}
N 640 -240 680 -240 {lab=0}
C {/foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_io/xschem/gf180mcu_fd_io__asig_5p0.sym} 370 -300 0 0 {name=x1}
C {vsource.sym} 160 -250 0 0 {name=V_VDD value=5 savecurrent=false}
C {vsource.sym} 80 -250 0 0 {name=V_DVDD value=5 savecurrent=false}
C {lab_wire.sym} 400 -420 0 1 {name=p1 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 360 -420 0 0 {name=p2 sig_type=std_logic lab=DVDD}
C {lab_wire.sym} 80 -330 0 0 {name=p5 sig_type=std_logic lab=DVDD}
C {lab_wire.sym} 160 -330 0 0 {name=p6 sig_type=std_logic lab=VDD}
C {code_shown.sym} 1600 -340 0 0 {name=NGSPICE
only_toplevel=true
value="
.control
save all
sp lin 100 1e3 5e9 0
write sp_analog_pad_diff_port.raw
.endc
" }
C {launcher.sym} 930 -415 0 0 {name=h1
descr="load waves" 
tclcommand="xschem raw_read $netlist_dir/sp_analog_pad_diff_port.raw sp"}
C {code_shown.sym} 820 -275 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice moscap_typical
.lib $::180MCU_MODELS/sm141064.ngspice diode_typical
.include /foss/designs/GF180/sscs_chipathon_26/LNA/analog_pad_sp_paramerters/gf180mcu_fd_io__asig_5p0.spice
*.include /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_io/spice/gf180mcu_ef_io.spice
"}
C {lab_wire.sym} 550 -300 0 1 {name=p4 sig_type=std_logic lab=Vin}
C {title.sym} 180 -40 0 0 {name=l4 author="Ahmed Elnaggar/A38-SilentOwl"}
C {gnd.sym} 640 -200 0 0 {name=l1 lab=0}
C {gnd.sym} 400 -180 0 0 {name=l2 lab=0}
C {gnd.sym} 160 -170 0 0 {name=l3 lab=0}
C {gnd.sym} 360 -180 0 0 {name=l5 lab=0}
C {gnd.sym} 80 -170 0 0 {name=l6 lab=0}
C {analog_pad_sp_paramerters/port_diff.sym} 680 -270 0 1 {name=P3 portnum=1 Z0=50 DCval=0 ACmag=0 ACphase=0 TRANval="PWL(0 0)"}
