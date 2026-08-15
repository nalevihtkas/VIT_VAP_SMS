set HERE [file dirname [file normalize [info script]]]
source [file join $HERE .. common scripts common.tcl]
load_demo_local false_path_top [file join $HERE false_path.v]
create_clock -name CLK -period 5.0 [get_ports clk]
puts "\n=== BEFORE: config path is timed ==="
report_timing -late -from [get_pins U_CFG_L/Q] -to [get_pins U_CFG_C/D] -max_paths 1
exit
