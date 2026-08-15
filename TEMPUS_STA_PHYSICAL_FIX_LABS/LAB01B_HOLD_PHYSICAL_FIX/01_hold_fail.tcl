set HERE [file dirname [file normalize [info script]]]
source [file join $HERE .. common scripts common.tcl]
load_demo_local hold_physical [file join $HERE hold_fail.v]
create_clock -name CLK -period 10.0 [get_ports clk]
set_min_delay 2.5 -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D]
puts "\n=== HOLD FAIL: short path, min-delay requirement stays 2.5 ns ==="
report_timing -early -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D] -max_paths 1
exit
