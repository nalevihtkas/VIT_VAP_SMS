set HERE [file dirname [file normalize [info script]]]
source [file join $HERE .. common scripts common.tcl]
load_demo_local skew_physical [file join $HERE skew_fail.v]
create_clock -name CLK -period 4.4 [get_ports clk]
set_clock_uncertainty -setup 0.4 [get_clocks CLK]
puts "\n=== FAIL: slow data path; clock=4.4 ns and uncertainty=0.4 ns ==="
report_timing -late -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D] -max_paths 1
exit
