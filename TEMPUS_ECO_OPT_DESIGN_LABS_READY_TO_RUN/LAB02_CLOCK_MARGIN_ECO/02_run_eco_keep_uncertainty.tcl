set HERE [file dirname [file normalize [info script]]]
source [file join $HERE .. common scripts common_eco.tcl]
load_teaching_design setup_eco_top [file join $HERE .. common netlist setup_eco.v]
create_clock -name CLK -period 4.4 [get_ports clk]
set_clock_uncertainty -setup 0.4 [get_clocks CLK]
puts "=== BEFORE ECO ==="
setup_report [get_pins U_LAUNCH/Q] [get_pins U_CAPTURE/D]
require_tempus_eco
run_setup_eco
puts "=== AFTER ECO: SAME CLOCK + SAME 0.4 ns UNCERTAINTY ==="
setup_report [get_pins U_LAUNCH/Q] [get_pins U_CAPTURE/D]
try_write_post_eco_netlist [file join $HERE post_eco_clock_margin.v]
exit
