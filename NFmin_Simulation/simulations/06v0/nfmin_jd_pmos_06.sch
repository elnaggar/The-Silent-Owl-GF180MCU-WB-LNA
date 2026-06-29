v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
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
C {vsource.sym} 320 -350 0 0 {name=VDS value=\{VDDP\} savecurrent=false}
C {ind.sym} 740 -80 2 0 {name=LDD
m=1
value=1u
footprint=1206
device=inductor}
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
C {port_diff.sym} 140 -360 0 0 {name=V1 portnum=1 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=""}
C {port_diff.sym} 140 -210 0 0 {name=V2 portnum=2 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=""}
C {ind.sym} 600 -210 1 0 {name=LDD1
m=1
value=10u
footprint=1206
device=inductor}
C {code_shown.sym} 640 25 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice

.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice moscap_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice diode_typical

.include /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice
"}
C {code.sym} 1510 30 0 0 {name=s2 only_toplevel=false value="

.option savecurrents

.param fnoicor=0
.param sw_stat_mismatch=0

* ============================================================
* Common-source pfet_06v0 characterization defaults
*
* In this PMOS testbench:
*   Source/body = vddp
*   Drain is RF-choked to GND through LDD
*   Gate DC voltage = VDDP - VSG_BIAS
*
* Therefore approximately:
*   VSD = VDDP
*   VSG = VSG_BIAS
*
* Main chip-realistic / IO-compatible point: VDDP = 5.0 V
* 5.5 V checks upper IO supply margin.
* 6.0 V is device-only characterization, not default pad-ring bias.
* ============================================================

.param VDDP=5.0
.param VSG_BIAS=0.9
.param VG_BIAS=\{VDDP-VSG_BIAS\}

* pfet_06v0 geometry defaults
.param W=0.30e-6
.param L=0.55e-6

.control
  set noaskquit
  save all

  echo VSD_V W_m L_m VSG_V ID_A JD_mA_per_um > pmos06_geom_jd_dense.txt
  echo VSD_V W_m L_m VSG_V NFmin_dB NF_dB Rn_Ohm SOpt_real SOpt_imag > pmos06_geom_nf_dense.txt

  * VDDP / VSD sweep:
  * 3.3 V  : low-voltage comparison
  * 5.0 V  : recommended nominal chip / IO-compatible point
  * 5.5 V  : upper IO operating check
  * 6.0 V  : 6 V device-only characterization point
  foreach vddpval 3.3 5.0 5.5 6.0

    * Width sweep in meters
    foreach wval 0.30e-6 1e-6 5e-6 10e-6 20e-6 50e-6

      * Length sweep in meters
      foreach lval 0.55e-6 0.70e-6 1.00e-6

        * VSG sweep:
        * 0.50 V to 2.50 V in 5 mV steps
        let vsg = 0.50

        while vsg le 2.5001

          alterparam VDDP = $vddpval
          alterparam W = $wval
          alterparam L = $lval
          alterparam VSG_BIAS = $&vsg
          reset

          op

          let idp_op = abs(i(vds))
          let jd_p_op = 1e-3*idp_op/$wval

          echo $vddpval $wval $lval $&vsg $&idp_op $&jd_p_op >> pmos06_geom_jd_dense.txt

          sp lin 1 2.4e9 2.4e9 1

          let nfmin_val = real(NFmin)
          let nf_val = real(NF)
          let rn_val = real(Rn)
          let sopt_re = real(SOpt)
          let sopt_im = imag(SOpt)

          echo $vddpval $wval $lval $&vsg $&nfmin_val $&nf_val $&rn_val $&sopt_re $&sopt_im >> pmos06_geom_nf_dense.txt

          let vsg = vsg + 0.005

        end

      end

    end

  end

.endc


"}
C {symbols/pfet_06v0.sym} 720 -210 0 0 {name=M1
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
model=pfet_06v0
spiceprefix=X
}
