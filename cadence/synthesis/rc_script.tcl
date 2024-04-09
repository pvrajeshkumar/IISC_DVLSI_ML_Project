set_attr lib_search_path ../lib/
set_attr hdl_search_path ../rtl/
set_attr library slow_vdd1v0_basicCells.lib
read_hdl neural_nw_inference.v
elaborate
read_sdc ../constraints/constraints_top.sdc
#synthesize -to_mapped -effort medium

set_attribute syn_generic_effort low /

set_attribute information_level 2 /
set_attribute optimize_constant_0_flops false /
set_attribute optimize_constant_1_flops false /
set_attribute optimize_constant_feedback_seqs false /

syn_generic
set_attribute syn_map_effort low /
syn_map
set_attribute syn_opt_effort low /
syn_opt

write_hdl > neural_nw_inference_netlist.v
write_sdc > neural_nw_inference_sdc.sdc
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge > delays.sdf
report qor > qor.rpt
report_power > power.rpt

gui_show

#exit
