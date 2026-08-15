set HERE [file dirname [file normalize [info script]]]
source [file join $HERE .. common scripts common.tcl]
load_demo_local setup_physical [file join $HERE setup_fail.v]
create_clock -name CLK -period 4.0 [get_ports clk]
puts "\n=== SETUP FAIL: 8 x BUF_X1, clock remains 4.0 ns ==="
report_timing -late -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D] -max_paths 1
exit
