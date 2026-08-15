set HERE [file dirname [file normalize [info script]]]
source [file join $HERE .. common scripts common_eco.tcl]
load_design_with_spef false_path_top [file join $HERE .. common netlist false_path.v] [file join $HERE .. common spef false_path.spef]
create_clock -name CLK -period 5.0 [get_ports clk]
puts "\n================ BEFORE ================="
report_timing -late -from [get_pins U_CFG_L/Q] -to [get_pins U_CFG_C/D] -max_paths 1
exit
