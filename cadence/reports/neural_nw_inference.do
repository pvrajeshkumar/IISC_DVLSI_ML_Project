set log file neural_nw_inference_lec.log -replace
read library ./slow_vdd1v0_basicCells.v -verilog -both
read design ../rtl/neural_nw_inference.v -verilog -golden
read design ../synthesis/neural_nw_inference_netlist.v -verilog -revised
//read design ../synthesis/neural_nw_inference_netlist_dft.v -verilog -revised
//add pin constraints 0 SE  -revised
//add ignored inputs scan_in -revised
//add ignored outputs scan_out -revised

set system mode lec
add compare point -all
compare
analyze datapath -effort high
report verification 


