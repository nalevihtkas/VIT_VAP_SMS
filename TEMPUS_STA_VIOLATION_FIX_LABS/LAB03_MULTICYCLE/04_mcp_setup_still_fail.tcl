source ../common/scripts/common.tcl
load_demo mcp_top mcp.v
create_clock -name CLK -period 3.0 [get_ports clk]
set_multicycle_path 2 -setup -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D]
set_multicycle_path 1 -hold  -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D]
report_timing -late -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D] -max_paths 1
