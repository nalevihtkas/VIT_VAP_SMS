source ../common/scripts/common.tcl
load_demo setup_hold_top setup_hold.v
create_clock -name CLK -period 5.0 [get_ports clk]
set_clock_uncertainty -setup 0.0 [get_clocks CLK]
report_timing -late -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D] -max_paths 1
