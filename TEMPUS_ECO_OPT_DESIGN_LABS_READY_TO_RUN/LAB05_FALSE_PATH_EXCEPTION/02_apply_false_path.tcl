set HERE [file dirname [file normalize [info script]]]
source [file join $HERE .. common scripts common_eco.tcl]
load_teaching_design false_path_top [file join $HERE .. common netlist false_path.v]
create_clock -name CLK -period 5.0 [get_ports clk]
set_false_path -from [get_pins U_CFG_L/Q] -to [get_pins U_CFG_C/D]
report_timing -late -max_paths 5
exit
