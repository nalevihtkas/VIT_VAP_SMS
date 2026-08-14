set THIS_DIR [file dirname [file normalize [info script]]]
source [file join $THIS_DIR .. common scripts common.tcl]
load_demo false_path_top false_path.v
create_clock -name CLK -period 5.0 [get_ports clk]
# This exception is valid only under the stated lab assumption:
# configuration/status path is not functionally timed in NORMAL mode.
set_false_path -from [get_pins U_CFG_L/Q] -to [get_pins U_CFG_C/D]
report_timing -late -max_paths 5
