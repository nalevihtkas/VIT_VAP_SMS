set THIS_DIR [file dirname [file normalize [info script]]]
source [file join $THIS_DIR .. common scripts common.tcl]
load_demo mcp_top mcp.v
create_clock -name CLK -period 4.0 [get_ports clk]
report_timing -late -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D] -max_paths 1
