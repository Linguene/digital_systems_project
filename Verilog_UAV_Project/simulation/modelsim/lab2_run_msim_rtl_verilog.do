transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/eryko/Desktop/SYCYF/SYCYF_PROJEKT/ETAP5/ProjektEtap5 {C:/Users/eryko/Desktop/SYCYF/SYCYF_PROJEKT/ETAP5/ProjektEtap5/gcd_asmd.v}

