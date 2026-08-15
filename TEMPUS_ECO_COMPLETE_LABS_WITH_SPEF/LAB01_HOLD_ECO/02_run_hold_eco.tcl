set HERE [file dirname [file normalize [info script]]]
source [file join $HERE .. common scripts common_eco.tcl]
load_design_with_spef hold_eco_top [file join $HERE .. common netlist hold_eco.v] [file join $HERE .. common spef hold_eco.spef]
create_clock -name CLK -period 10.0 [get_ports clk]
set_min_delay 1.6 -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D]
puts "\n================ BEFORE ================="
hold_report [get_pins U_LAUNCH/Q] [get_pins U_CAPTURE/D]
puts "\n================ ECO ===================="
run_hold_eco
puts "\n================ AFTER =================="
hold_report [get_pins U_LAUNCH/Q] [get_pins U_CAPTURE/D]
dump_eco_info [file join $HERE eco_output]
exit
