v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 630 -320 630 -300 {
lab=d}
N 510 -150 510 -120 {
lab=0}
N 820 -150 820 -120 {
lab=0}
N 730 -150 730 -120 {
lab=0}
N 630 -240 630 -120 {
lab=0}
N 730 -270 730 -210 {
lab=b}
N 510 -270 510 -210 {
lab=g}
N 510 -270 590 -270 {
lab=g}
N 630 -270 730 -270 {
lab=b}
N 630 -320 820 -320 {
lab=d}
N 820 -320 820 -210 {
lab=d}
N 900 -150 900 -120 {
lab=0}
N 900 -250 900 -210 {
lab=n}
N 820 -120 900 -120 {lab=0}
N 730 -120 820 -120 {lab=0}
N 630 -120 730 -120 {lab=0}
N 510 -120 630 -120 {lab=0}
C {devices/vsource.sym} 510 -180 0 0 {name=vg value="DC 0.9 AC 1" savecurrent=false}
C {devices/vsource.sym} 820 -180 0 0 {name=vd value=0.9 savecurrent=false}
C {devices/vsource.sym} 730 -180 0 1 {name=vb value=0 savecurrent=false}
C {devices/lab_wire.sym} 560 -270 0 0 {name=p1 sig_type=std_logic lab=g}
C {devices/lab_wire.sym} 730 -320 0 0 {name=p2 sig_type=std_logic lab=d}
C {devices/lab_wire.sym} 730 -270 0 0 {name=p3 sig_type=std_logic lab=b}
C {devices/code_shown.sym} 0 -840 0 0 {name=COMMANDS1 only_toplevel=false
value="
.param wx=5u lx=0.6u
.noise v(n) vg lin 1 1 1 1
.control
option numdgt = 3
set wr_singlescale
set wr_vecnames


compose l_vec  values 0.6u 
+ 0.7u 0.8u 0.9u 1u 2u 3u
compose vg_vec start= 0 stop=10.001  step=25m
compose vd_vec start= 0 stop=10.001  step=25m
compose vb_vec start= 0 stop=-0.4 step=-0.2

foreach var1 $&l_vec
  alterparam lx=$var1
  reset
  foreach var2 $&vg_vec
    alter vg $var2
    foreach var3 $&vd_vec
      alter vd $var3
      foreach var4 $&vb_vec
	echo Running: L=$var1 Vg=$var2 Vd=$var3 Vb=$var4
        alter vb $var4
        run
        wrdata techsweep_nfet_10v0.txt noise1.all
        destroy all
        set appendwrite
        unset set wr_vecnames  
      end
    end 
  end
end
unset appendwrite

alterparam lx=0.6u
reset
op
show
write techsweep_nfet_10v0.raw
.endc
"}
C {devices/title.sym} 160 0 0 0 {name=l5 author="Boris Murmann"}
C {devices/ngspice_get_value.sym} 1120 -130 0 0 {name=r1 node=v(@m.xm1.m0[vth])
descr="Vt="}
C {devices/launcher.sym} 940 -370 0 0 {name=h1
descr="load op & annotate" 
tclcommand="xschem raw_read $netlist_dir/techsweep_nfet_03v3.raw; set show_hidden_texts 1; xschem annotate_op"}
C {devices/launcher.sym} 940 -410 0 0 {name=h3
descr="save, netlist & simulate"
tclcommand="xschem save; xschem netlist; xschem simulate"}
C {devices/ngspice_get_value.sym} 1010 -250 0 0 {name=r2 node=@m.xm1.m0[cgg]
descr="cgg="}
C {devices/ngspice_get_expr.sym} 1120 -170 0 0 {name=r4 
node="[format %.4g [expr [ngspice::get_node \{@m.xm1.m0[gm]\}] / [ngspice::get_node \{@m.xm1.m0[gds]\}]]]"
descr="gm/gds="}
C {devices/ngspice_get_value.sym} 1010 -210 0 0 {name=r3 node=@m.xm1.m0[capbd]
descr="capdb="}
C {devices/ngspice_get_value.sym} 1010 -170 0 0 {name=r5 node=@m.xm1.m0[capbs]
descr="capbs="}
C {devices/ngspice_get_expr.sym} 1120 -210 0 0 {name=r6 
node="[format %.4g [expr [ngspice::get_node \{@m.xm1.m0[gm]\}] / [ngspice::get_node \{@m.xm1.m0[cgg]\}] / 6.283]]"
descr="fT_intrinsic="}
C {devices/ngspice_get_expr.sym} 1120 -250 0 0 {name=r7 
node="[format %.4g [expr [ngspice::get_node \{@m.xm1.m0[gm]\}] / [ngspice::get_node \{i(@m.xm1.m0[id])\}]]]"
descr="gm/ID="}
C {devices/code_shown.sym} 600 -870 0 0 {name=COMMANDS2 only_toplevel=false
value="
.save @m.xm1.m0[capbd]
.save @m.xm1.m0[capbs]
.save @m.xm1.m0[cdd]
.save @m.xm1.m0[cgb]
.save @m.xm1.m0[cgd]
.save @m.xm1.m0[cgdo]
.save @m.xm1.m0[cgg]
.save @m.xm1.m0[cgs]
.save @m.xm1.m0[cgso]
.save @m.xm1.m0[css]
.save @m.xm1.m0[gds] 
.save @m.xm1.m0[gm] 
.save @m.xm1.m0[gmbs] 
.save @m.xm1.m0[id]
.save @m.xm1.m0[l]
.save @m.xm1.m0[vth]
.save @vb[dc]
.save @vd[dc]
.save @vg[dc]
.save onoise.m.xm1.m0.id
.save onoise.m.xm1.m0.1overf
.save g d b n
"}
C {devices/ccvs.sym} 900 -180 0 0 {name=Hn vnam=vd value=1}
C {devices/lab_wire.sym} 900 -250 0 0 {name=p4 sig_type=std_logic lab=n}
C {devices/lab_wire.sym} 560 -120 0 0 {name=p5 sig_type=std_logic lab=0}
C {devices/ngspice_get_value.sym} 1010 -130 0 0 {name=r8 node=@m.xm1.m0[cgdo]
descr="cgdo="}
C {devices/ngspice_get_value.sym} 1010 -90 0 0 {name=r9 node=@m.xm1.m0[cgso]
descr="cgso="}
C {symbols/nfet_10v0_asym.sym} 610 -270 0 0 {name=M1
L=\{lx\}
W=\{wx\}
nf=1
m=1
ad="'W * 1.48u'"
pd="'2 * (W + 1.48u)'"
as="'W * 0.48u'"
ps="'2 * (W + 0.48u)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
model=nfet_10v0_asym
spiceprefix=X
}
C {devices/code_shown.sym} 990 -760 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/smbb000149.ngspice typical
"}
