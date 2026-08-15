set HERE [file dirname [file normalize [info script]]]
source [file join $HERE .. common scripts common_eco.tcl]
load_teaching_design hold_eco_top [file join $HERE .. common netlist hold_eco.v]
create_clock -name CLK -period 10.0 [get_ports clk]
set_min_delay 1.6 -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D]
puts "=== BEFORE ECO ==="
hold_report [get_pins U_LAUNCH/Q] [get_pins U_CAPTURE/D]
require_tempus_eco
run_hold_eco
puts "=== AFTER ECO: SAME 1.6 ns MIN DELAY ==="
hold_report [get_pins U_LAUNCH/Q] [get_pins U_CAPTURE/D]
try_write_post_eco_netlist [file join $HERE post_eco_hold.v]
exit
