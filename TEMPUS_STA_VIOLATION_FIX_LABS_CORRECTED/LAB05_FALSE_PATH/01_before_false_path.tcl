set THIS_DIR [file dirname [file normalize [info script]]]
source [file join $THIS_DIR .. common scripts common.tcl]
load_demo false_path_top false_path.v
create_clock -name CLK -period 5.0 [get_ports clk]
report_timing -late -from [get_pins U_CFG_L/Q] -to [get_pins U_CFG_C/D] -max_paths 1
