set HERE [file dirname [file normalize [info script]]]
source [file join $HERE .. common scripts common_eco.tcl]
load_teaching_design cg_eco_top [file join $HERE .. common netlist cg_eco.v]
create_clock -name CLK -period 2.4 [get_ports clk]
puts "=== BEFORE ECO ==="
report_timing -late -from [get_pins U_EN_SRC/Q] -to [get_pins U_ICG/EN] -max_paths 1
require_tempus_eco
run_setup_eco
puts "=== AFTER ECO: SAME CLOCK / SAME ICG LIBRARY CHECK ==="
report_timing -late -from [get_pins U_EN_SRC/Q] -to [get_pins U_ICG/EN] -max_paths 1
try_write_post_eco_netlist [file join $HERE post_eco_clock_gating.v]
exit
