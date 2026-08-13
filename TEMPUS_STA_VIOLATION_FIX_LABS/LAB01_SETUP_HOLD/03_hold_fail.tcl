source ../common/scripts/common.tcl
load_demo setup_hold_top setup_hold.v
create_clock -name CLK -period 10.0 [get_ports clk]
# Educational constraint: require extra minimum delay so the existing min path fails.
set_min_delay 5.0 -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D]
report_timing -early -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D] -max_paths 1
