set HERE [file dirname [file normalize [info script]]]
source [file join $HERE .. common scripts common.tcl]
load_demo_local half_physical [file join $HERE half_fail.v]
create_clock -name CLK -period 8.0 -waveform {0 4} [get_ports clk]
puts "\n=== HALF-CYCLE FAIL: 8 x BUF_X1, SAME 8 ns clock ==="
report_timing -late -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D] -max_paths 1
exit
