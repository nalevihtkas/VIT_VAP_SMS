set HERE [file dirname [file normalize [info script]]]
source [file join $HERE .. common scripts common_eco.tcl]
load_teaching_design half_eco_top [file join $HERE .. common netlist half_eco.v]
create_clock -name CLK -period 8.0 -waveform {0 4} [get_ports clk]
puts "=== BEFORE ECO ==="
setup_report [get_pins U_LAUNCH/Q] [get_pins U_CAPTURE/D]
require_tempus_eco
opt_signoff -setup
puts "=== AFTER ECO: SAME 8 ns {0 4} CLOCK ==="
setup_report [get_pins U_LAUNCH/Q] [get_pins U_CAPTURE/D]
try_write_post_eco_netlist [file join $HERE post_eco_half_cycle.v]
exit
