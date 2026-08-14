set THIS_DIR [file dirname [file normalize [info script]]]
source [file join $THIS_DIR .. common scripts common.tcl]
load_demo setup_hold_top setup_hold.v
create_clock -name CLK -period 10.0 [get_ports clk]
set_min_delay 4.5 -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D]
set_clock_uncertainty -hold 0.5 [get_clocks CLK]
report_timing -early -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D] -max_paths 1
