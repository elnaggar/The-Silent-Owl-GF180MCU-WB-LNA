v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 290 -380 290 -350 {
lab=GND}
N 290 -350 290 -250 {
lab=GND}
N 290 -470 290 -440 {
lab=vddp}
N 290 -330 340 -330 {
lab=GND}
N 110 -450 150 -450 {
lab=in}
N 110 -390 150 -390 {
lab=GND}
N 110 -300 150 -300 {
lab=out}
N 110 -240 150 -240 {
lab=GND}
N 710 -380 710 -300 {
lab=vddp}
N 710 -410 710 -380 {
lab=vddp}
N 400 -330 430 -330 {
lab=vgdc}
N 640 -270 670 -270 {
lab=g}
N 510 -270 540 -270 {
lab=vgdc}
N 600 -270 640 -270 {
lab=g}
N 600 -350 620 -350 {
lab=g}
N 620 -350 620 -270 {
lab=g}
N 510 -350 540 -350 {
lab=in}
N 810 -190 850 -190 {
lab=out}
N 710 -270 740 -270 {
lab=vddp}
N 740 -310 740 -270 {
lab=vddp}
N 710 -310 740 -310 {
lab=vddp}
N 710 -240 710 -220 {
lab=d}
N 710 -110 710 -80 {
lab=GND}
N 710 -220 710 -170 {
lab=d}
N 710 -190 750 -190 {
lab=d}
C {vsource.sym} 370 -330 1 0 {name=VGS value=\{VG_BIAS\} savecurrent=false}
C {gnd.sym} 710 -80 0 0 {name=l1 lab=GND}
C {vsource.sym} 290 -410 0 0 {name=VDS value=\{VDDP\} savecurrent=false}
C {ind.sym} 710 -140 2 0 {name=LDD
m=1
value=1u
footprint=1206
device=inductor}
C {capa.sym} 780 -190 3 0 {name=COUT
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 710 -210 0 0 {name=p3 sig_type=std_logic lab=d}
C {lab_pin.sym} 150 -450 2 0 {name=p5 sig_type=std_logic lab=in}
C {lab_pin.sym} 150 -390 2 0 {name=p6 sig_type=std_logic lab=GND

}
C {lab_pin.sym} 150 -300 2 0 {name=p7 sig_type=std_logic lab=out}
C {lab_pin.sym} 150 -240 2 0 {name=p8 sig_type=std_logic lab=GND}
C {capa.sym} 570 -350 3 0 {name=CIN
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 290 -250 0 0 {name=l3 lab=GND}
C {lab_pin.sym} 290 -470 0 0 {name=p10 sig_type=std_logic lab=vddp

}
C {lab_pin.sym} 640 -270 0 0 {name=p4 sig_type=std_logic lab=g}
C {lab_pin.sym} 430 -330 2 0 {name=p9 sig_type=std_logic lab=vgdc}
C {lab_pin.sym} 710 -410 0 0 {name=p11 sig_type=std_logic lab=vddp
}
C {lab_pin.sym} 510 -270 0 0 {name=p12 sig_type=std_logic lab=vgdc}
C {lab_pin.sym} 510 -350 0 0 {name=p13 sig_type=std_logic lab=in}
C {lab_pin.sym} 850 -190 2 0 {name=p14 sig_type=std_logic lab=out}
C {symbols/pfet_03v3.sym} 690 -270 0 0 {name=M2
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
C {port_diff.sym} 110 -420 0 0 {name=V1 portnum=1 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=""}
C {port_diff.sym} 110 -270 0 0 {name=V2 portnum=2 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=""}
C {ind.sym} 570 -270 1 0 {name=LDD1
m=1
value=10u
footprint=1206
device=inductor}
C {code_shown.sym} 70 65 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice

.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice moscap_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice diode_typical

.include /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice
"}
C {code.sym} 940 70 0 0 {name=s2 only_toplevel=false value="
.option savecurrents

.param fnoicor=0
.param sw_stat_mismatch=0

* Default values
.param VDDP=1.8
.param VSG_BIAS=0.7
.param VG_BIAS=\{VDDP-VSG_BIAS\}

.param W=0.22e-6
.param L=0.28e-6

.control
  set noaskquit
  save all

  echo W_m L_m VSG ID_A JD_mA_per_um > pmos_geom_jd.txt
  echo W_m L_m VSG NFmin_dB NF_dB Rn SOpt_real SOpt_imag > pmos_geom_nf.txt

  * Width sweep in meters:
  foreach wval 0.22e-6 1e-6 5e-6 10e-6

    * Length sweep in meters:
    foreach lval 0.28e-6 0.36e-6 0.50e-6

      * VSG sweep:
      * 0.35 V to 1.20 V in 5 mV steps
      let k = 0
      while k <= 170

        let vsg = 0.35 + 0.005*k

        alterparam W = $wval
        alterparam L = $lval
        alterparam VSG_BIAS = $&vsg
        reset

        op

        let idp_op = abs(i(vds))
        let jd_p_op = 1e-3*idp_op/$wval

        echo $wval $lval $&vsg $&idp_op $&jd_p_op >> pmos_geom_jd.txt

        sp lin 1 2.4e9 2.4e9 1

        let nfmin_val = real(NFmin)
        let nf_val = real(NF)
        let rn_val = real(Rn)
        let sopt_re = real(SOpt)
        let sopt_im = imag(SOpt)

        echo $wval $lval $&vsg $&nfmin_val $&nf_val $&rn_val $&sopt_re $&sopt_im >> pmos_geom_nf.txt

        let k = k + 1

      end

    end

  end

.endc

"}
