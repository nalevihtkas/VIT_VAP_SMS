set HERE [file dirname [file normalize [info script]]]
source [file join $HERE .. common scripts common_eco.tcl]
load_teaching_design cg_eco_top [file join $HERE .. common netlist cg_eco.v]
create_clock -name CLK -period 2.4 [get_ports clk]
report_timing -late -from [get_pins U_EN_SRC/Q] -to [get_pins U_ICG/EN] -max_paths 1
exit
