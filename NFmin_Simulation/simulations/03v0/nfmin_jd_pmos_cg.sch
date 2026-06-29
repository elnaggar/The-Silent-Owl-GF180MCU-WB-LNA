v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 350 -450 350 -420 {
lab=GND}
N 350 -420 350 -320 {
lab=GND}
N 350 -540 350 -510 {
lab=vddp}
N 350 -400 400 -400 {
lab=GND}
N 170 -520 210 -520 {
lab=in}
N 170 -460 210 -460 {
lab=GND}
N 170 -370 210 -370 {
lab=out}
N 170 -310 210 -310 {
lab=GND}
N 770 -450 770 -370 {
lab=s}
N 460 -400 490 -400 {
lab=g}
N 700 -340 730 -340 {
lab=g}
N 700 -410 720 -410 {
lab=s}
N 610 -410 640 -410 {
lab=in}
N 870 -260 910 -260 {
lab=out}
N 770 -340 800 -340 {
lab=vddp}
N 800 -380 800 -340 {
lab=vddp}
N 770 -310 770 -290 {
lab=d}
N 770 -180 770 -150 {
lab=GND}
N 770 -290 770 -240 {
lab=d}
N 770 -260 810 -260 {
lab=d}
N 770 -570 770 -510 {
lab=vddp}
N 800 -530 800 -380 {
lab=vddp}
N 770 -530 800 -530 {
lab=vddp}
N 720 -410 770 -410 {
lab=s}
C {vsource.sym} 430 -400 1 0 {name=VGG value=\{VG_BIAS\} savecurrent=false}
C {gnd.sym} 770 -150 0 0 {name=l1 lab=GND}
C {vsource.sym} 350 -480 0 0 {name=VDDP_SRC value=\{VDDP\} savecurrent=false}
C {ind.sym} 770 -210 2 0 {name=LDD
m=1
value=1u
footprint=1206
device=inductor}
C {capa.sym} 840 -260 3 0 {name=COUT
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 770 -280 0 0 {name=p3 sig_type=std_logic lab=d}
C {lab_pin.sym} 210 -520 2 0 {name=p5 sig_type=std_logic lab=in}
C {lab_pin.sym} 210 -460 2 0 {name=p6 sig_type=std_logic lab=GND

}
C {lab_pin.sym} 210 -370 2 0 {name=p7 sig_type=std_logic lab=out}
C {lab_pin.sym} 210 -310 2 0 {name=p8 sig_type=std_logic lab=GND}
C {capa.sym} 670 -410 3 0 {name=CIN
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 350 -320 0 0 {name=l3 lab=GND}
C {lab_pin.sym} 350 -540 0 0 {name=p10 sig_type=std_logic lab=vddp

}
C {lab_pin.sym} 700 -340 0 0 {name=p4 sig_type=std_logic lab=g}
C {lab_pin.sym} 490 -400 2 0 {name=p9 sig_type=std_logic lab=g}
C {lab_pin.sym} 770 -570 0 0 {name=p11 sig_type=std_logic lab=vddp
}
C {lab_pin.sym} 610 -410 0 0 {name=p13 sig_type=std_logic lab=in}
C {lab_pin.sym} 910 -260 2 0 {name=p14 sig_type=std_logic lab=out}
C {symbols/pfet_03v3.sym} 750 -340 0 0 {name=M2
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
C {port_diff.sym} 170 -490 0 0 {name=V1 portnum=1 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=""}
C {port_diff.sym} 170 -340 0 0 {name=V2 portnum=2 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=""}
C {ind.sym} 770 -480 2 0 {name=LSRC
m=1
value=10u
footprint=1206
device=inductor}
C {lab_pin.sym} 770 -430 0 0 {name=p1 sig_type=std_logic lab=s}
C {code_shown.sym} 50 75 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice

.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice moscap_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice diode_typical

.include /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice
"}
C {code.sym} 920 80 0 0 {name=s2 only_toplevel=false value="
.option savecurrents

.param fnoicor=0
.param sw_stat_mismatch=0

.param VDDP=1.8
.param VSG_BIAS=0.7
.param VG_BIAS=\{VDDP-VSG_BIAS\}

.param W=0.22e-6
.param L=0.28e-6

.control
  set noaskquit
  save all

  echo W_m L_m VSG ID_A JD_mA_per_um > pmos_cg_geom_jd_dense.txt
  echo W_m L_m VSG NFmin_dB NF_dB Rn SOpt_real SOpt_imag > pmos_cg_geom_nf_dense.txt

  foreach wval 0.22e-6 1e-6 5e-6 10e-6
    foreach lval 0.28e-6 0.36e-6 0.50e-6

      let vsg = 0.35

      while vsg le 1.2001

        alterparam W = $wval
        alterparam L = $lval
        alterparam VSG_BIAS = $&vsg
        reset

        op

        let idp_op = abs(i(vddp_src))
        let jd_p_op = 1e-3*idp_op/$wval

        echo $wval $lval $&vsg $&idp_op $&jd_p_op >> pmos_cg_geom_jd_dense.txt

        sp lin 1 2.4e9 2.4e9 1

        let nfmin_val = real(NFmin)
        let nf_val = real(NF)
        let rn_val = real(Rn)
        let sopt_re = real(SOpt)
        let sopt_im = imag(SOpt)

        echo $wval $lval $&vsg $&nfmin_val $&nf_val $&rn_val $&sopt_re $&sopt_im >> pmos_cg_geom_nf_dense.txt

        let vsg = vsg + 0.005

      end
    end
  end

.endc

"}
