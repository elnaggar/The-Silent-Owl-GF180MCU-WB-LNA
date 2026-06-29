v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
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
C {vsource.sym} -90 -180 1 0 {name=VGS value=\{VBIAS\} savecurrent=false}
C {gnd.sym} 250 -40 0 0 {name=l1 lab=GND}
C {vsource.sym} -170 -260 0 0 {name=VDD value=\{VDS\} savecurrent=false}
C {ind.sym} 250 -260 2 0 {name=LDD
m=1
value=1u
footprint=1206
device=inductor}
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
C {ind.sym} 110 -120 1 0 {name=LDD1
m=1
value=10u
footprint=1206
device=inductor}
C {code_shown.sym} 140 45 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice

.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice moscap_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice diode_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/smbb000149.ngspice typical

.include /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice
"}
C {code.sym} 1010 60 0 0 {name=s2 only_toplevel=false value="
.option savecurrents

.param fnoicor=0
.param sw_stat_mismatch=0

.param VDS=5.0
.param VBIAS=0.9

.param W=4.00e-6
.param L=0.60e-6

.control
  set noaskquit

  echo VDS_set_V W_m L_m VBIAS_set_V VGS_actual_V VDS_actual_V VBS_actual_V ID_A JD_mA_per_um Pdc_mW gm_S gds_S gm_ID_1_per_V ro_Ohm gmro inv_gm_Ohm NFmin_dB NF_dB Rn_Ohm SOpt_real SOpt_imag SOpt_mag > nmos10_cs_full_nom5v.txt

  foreach vdsval 5.0

    foreach wval 4e-6 5e-6 10e-6 20e-6 50e-6

      foreach lval 0.60e-6 0.70e-6 1.00e-6

        setplot const
        let k = 0

        while k <= 400

          setplot const
          let vgs = 0.50 + 0.005*k

          alterparam VDS = $vdsval
          alterparam W = $wval
          alterparam L = $lval
          alterparam VBIAS = $&vgs
          reset

          op

          let idn_tmp = abs(i(vdd))
          let jd_tmp = 1e-3*idn_tmp/$wval
          let pdc_tmp = 1e3*idn_tmp*$vdsval

          let vgs_tmp = v(g)
          let vds_tmp = v(d)
          let vbs_tmp = 0

          let gm_tmp = @m.xm1.m0[gm]
          let gds_tmp = @m.xm1.m0[gds]

          let gm_id_tmp = gm_tmp/idn_tmp
          let ro_tmp = 1/gds_tmp
          let gmro_tmp = gm_tmp/gds_tmp
          let inv_gm_tmp = 1/gm_tmp

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
          set inv_gm_op = $&inv_gm_tmp

          destroy $curplot

          sp lin 1 2.4e9 2.4e9 1

          let nfmin_val = real(NFmin)
          let nf_val = real(NF)
          let rn_val = real(Rn)
          let sopt_re = real(SOpt)
          let sopt_im = imag(SOpt)
          let sopt_mag = sqrt(sopt_re*sopt_re + sopt_im*sopt_im)

          echo $vdsval $wval $lval $&vgs $vgs_op $vds_op $vbs_op $idn_op $jd_op $pdc_op $gm_op $gds_op $gm_id_op $ro_op $gmro_op $inv_gm_op $&nfmin_val $&nf_val $&rn_val $&sopt_re $&sopt_im $&sopt_mag >> nmos10_cs_full_nom5v.txt

          destroy $curplot

          setplot const
          let k = k + 1

        end

      end

    end

  end

.endc
"}
C {symbols/nfet_10v0_asym.sym} 230 -120 0 0 {name=M1
L=\{L\}
W=\{W\}
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
