set HERE [file dirname [file normalize [info script]]]
source [file join $HERE .. common scripts common_eco.tcl]
load_teaching_design setup_eco_top [file join $HERE .. common netlist setup_eco.v]
create_clock -name CLK -period 4.0 [get_ports clk]
puts "=== BEFORE ECO ==="
setup_report [get_pins U_LAUNCH/Q] [get_pins U_CAPTURE/D]
require_tempus_eco
run_setup_eco
puts "=== AFTER ECO: SAME 4.0 ns CLOCK ==="
setup_report [get_pins U_LAUNCH/Q] [get_pins U_CAPTURE/D]
try_write_post_eco_netlist [file join $HERE post_eco_setup.v]
exit
