set HERE [file dirname [file normalize [info script]]]
source [file join $HERE .. common scripts common.tcl]
load_demo_local setup_physical [file join $HERE setup_fixed.v]
create_clock -name CLK -period 4.0 [get_ports clk]
puts "\n=== SETUP FIX: 8 x BUF_X2, SAME 4.0 ns clock ==="
report_timing -late -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D] -max_paths 1
exit
