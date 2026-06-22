v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 300 -360 300 -330 {
lab=GND}
N 720 -250 740 -250 {
lab=GND}
N 300 -330 300 -230 {
lab=GND}
N 300 -450 300 -420 {
lab=vdcbias}
N 300 -310 350 -310 {
lab=GND}
N 120 -430 160 -430 {
lab=in}
N 120 -370 160 -370 {
lab=GND}
N 120 -280 160 -280 {
lab=out}
N 120 -220 160 -220 {
lab=GND}
N 720 -360 720 -280 {
lab=d}
N 720 -450 720 -420 {
lab=vdcbias}
N 410 -310 440 -310 {
lab=g}
N 620 -200 640 -200 {
lab=s}
N 530 -200 560 -200 {
lab=in}
N 720 -320 760 -320 {
lab=d}
N 820 -320 860 -320 {
lab=out}
N 720 -220 720 -210 {
lab=s}
N 720 -210 720 -180 {
lab=s}
N 660 -250 680 -250 {
lab=g}
N 720 -120 720 -90 {
lab=GND}
N 640 -200 720 -200 {
lab=s}
C {vsource.sym} 380 -310 1 0 {name=VGG value=\{VBIAS\} savecurrent=false}
C {gnd.sym} 720 -90 0 0 {name=l1 lab=GND}
C {vsource.sym} 300 -390 0 0 {name=VDD value=\{VDS\} savecurrent=false}
C {ind.sym} 720 -390 2 0 {name=LDD
m=1
value=1u
footprint=1206
device=inductor}
C {capa.sym} 790 -320 3 0 {name=COUT
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 720 -310 0 0 {name=p3 sig_type=std_logic lab=d}
C {lab_pin.sym} 160 -430 2 0 {name=p5 sig_type=std_logic lab=in}
C {lab_pin.sym} 160 -370 2 0 {name=p6 sig_type=std_logic lab=GND

}
C {lab_pin.sym} 160 -280 2 0 {name=p7 sig_type=std_logic lab=out}
C {lab_pin.sym} 160 -220 2 0 {name=p8 sig_type=std_logic lab=GND}
C {capa.sym} 590 -200 3 0 {name=CIN
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 300 -230 0 0 {name=l3 lab=GND}
C {lab_pin.sym} 300 -450 0 0 {name=p10 sig_type=std_logic lab=vdcbias
}
C {lab_pin.sym} 660 -250 0 0 {name=p4 sig_type=std_logic lab=g}
C {lab_pin.sym} 440 -310 2 0 {name=p9 sig_type=std_logic lab=g}
C {lab_pin.sym} 720 -450 0 0 {name=p11 sig_type=std_logic lab=vdcbias
}
C {lab_pin.sym} 530 -200 0 0 {name=p13 sig_type=std_logic lab=in}
C {lab_pin.sym} 860 -320 2 0 {name=p14 sig_type=std_logic lab=out}
C {port_diff.sym} 120 -400 0 0 {name=V1 portnum=1 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=""}
C {port_diff.sym} 120 -250 0 0 {name=V2 portnum=2 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=""}
C {lab_pin.sym} 720 -190 2 0 {name=p1 sig_type=std_logic lab=s}
C {lab_pin.sym} 740 -250 2 0 {name=p2 sig_type=std_logic lab=GND}
C {ind.sym} 720 -150 2 0 {name=LSRC
m=1
value=10u
footprint=1206
device=inductor}
C {code_shown.sym} 20 45 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice

.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice moscap_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice diode_typical

.include /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice
"}
C {code.sym} 890 50 0 0 {name=s2 only_toplevel=false value="

.option savecurrents

.param fnoicor=0
.param sw_stat_mismatch=0

.param VBIAS=0.9
.param VDS=5.0

.param W=0.30e-6
.param L=0.70e-6

.control
  set noaskquit

  echo VDS_set_V W_m L_m VBIAS_set_V VGS_actual_V VDS_actual_V VBS_actual_V ID_A JD_mA_per_um Pdc_mW gm_S gds_S gm_ID_1_per_V ro_Ohm gmro Rin_CG_est_Ohm NFmin_dB NF_dB Rn_Ohm SOpt_real SOpt_imag SOpt_mag > nmos05_cg_full_nom5v.txt

  foreach vdsval 5.0

    foreach wval 0.30e-6 1e-6 5e-6 10e-6 20e-6 50e-6

      foreach lval 0.60e-6 0.70e-6 1.00e-6

        setplot const
        let k = 0

        while k <= 400

          setplot const
          let vbias = 0.50 + 0.005*k

          alterparam VDS = $vdsval
          alterparam W = $wval
          alterparam L = $lval
          alterparam VBIAS = $&vbias
          reset

          op

          let idn_tmp = abs(i(vdd))
          let jd_tmp = 1e-3*idn_tmp/$wval
          let pdc_tmp = 1e3*idn_tmp*$vdsval

          let vgs_tmp = v(g)-v(s)
          let vds_tmp = v(d)-v(s)
          let vbs_tmp = -v(s)

          let gm_tmp = @m.xm1.m0[gm]
          let gds_tmp = @m.xm1.m0[gds]

          let gm_id_tmp = gm_tmp/idn_tmp
          let ro_tmp = 1/gds_tmp
          let gmro_tmp = gm_tmp/gds_tmp
          let rin_cg_tmp = 1/gm_tmp

          set idn_op = $&idn_tmp
          set jd_op = $&jd_tmp
          set pdc_op = $&pdc_tmp
          set vgs_op = $&vgs_tmp
          set vds_op = $&vds_tmp
          set vbs_op = $&vbs_tmp
          set gm_op = $&gm_tmp
          set gds_op = $&gds_tmp
          set gm_id_op = $&gm_id_tmp
          set ro_op = $&ro_tmp
          set gmro_op = $&gmro_tmp
          set rin_cg_op = $&rin_cg_tmp

          destroy $curplot

          sp lin 1 2.4e9 2.4e9 1

          let nfmin_val = real(NFmin)
          let nf_val = real(NF)
          let rn_val = real(Rn)
          let sopt_re = real(SOpt)
          let sopt_im = imag(SOpt)
          let sopt_mag = sqrt(sopt_re*sopt_re + sopt_im*sopt_im)

          echo $vdsval $wval $lval $&vbias $vgs_op $vds_op $vbs_op $idn_op $jd_op $pdc_op $gm_op $gds_op $gm_id_op $ro_op $gmro_op $rin_cg_op $&nfmin_val $&nf_val $&rn_val $&sopt_re $&sopt_im $&sopt_mag >> nmos05_cg_full_nom5v.txt

          destroy $curplot

          setplot const
          let k = k + 1

        end

      end

    end

  end

.endc
"
}
C {symbols/nfet_05v0.sym} 700 -250 0 0 {name=M1
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
model=nfet_05v0
spiceprefix=X
}
