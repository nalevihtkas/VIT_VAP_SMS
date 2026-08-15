set HERE [file dirname [file normalize [info script]]]
source [file join $HERE .. common scripts common.tcl]
load_demo_local skew_physical [file join $HERE skew_fixed.v]
create_clock -name CLK -period 4.4 [get_ports clk]
set_clock_uncertainty -setup 0.4 [get_clocks CLK]
puts "\n=== FIX: faster data cells; SAME clock and SAME uncertainty ==="
report_timing -late -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D] -max_paths 1
exit
