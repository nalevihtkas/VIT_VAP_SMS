set HERE [file dirname [file normalize [info script]]]
source [file join $HERE .. common scripts common_eco.tcl]
load_design_with_spef cg_eco_top [file join $HERE .. common netlist cg_eco.v] [file join $HERE .. common spef cg_eco.spef]
create_clock -name CLK -period 2.4 [get_ports clk]
puts "\n================ BEFORE ================="
report_timing -late -from [get_pins U_EN_SRC/Q] -to [get_pins U_ICG/EN] -max_paths 1
puts "\n================ ECO ===================="
run_setup_eco
puts "\n================ AFTER =================="
report_timing -late -from [get_pins U_EN_SRC/Q] -to [get_pins U_ICG/EN] -max_paths 1
dump_eco_info [file join $HERE eco_output]
exit
