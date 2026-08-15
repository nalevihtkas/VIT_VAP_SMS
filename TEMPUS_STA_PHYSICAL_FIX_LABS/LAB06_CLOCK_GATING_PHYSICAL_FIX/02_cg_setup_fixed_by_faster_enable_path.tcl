set HERE [file dirname [file normalize [info script]]]
source [file join $HERE .. common scripts common.tcl]
load_demo_local cg_physical [file join $HERE cg_fixed.v]
create_clock -name CLK -period 2.4 [get_ports clk]
puts "\n=== CLOCK-GATING SETUP FIX: faster EN path, SAME 2.4 ns clock ==="
report_timing -late -from [get_pins U_EN_SRC/Q] -to [get_pins U_ICG/EN] -max_paths 1
exit
