source ../common/scripts/common.tcl
load_demo setup_hold_top setup_hold.v
create_clock -name CLK -period 10.0 [get_ports clk]
set_min_delay 3.5 -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D]
set_clock_uncertainty -hold 0.0 [get_clocks CLK]
report_timing -early -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D] -max_paths 1
