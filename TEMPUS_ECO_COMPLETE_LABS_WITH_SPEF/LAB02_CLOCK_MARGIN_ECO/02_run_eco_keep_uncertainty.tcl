set HERE [file dirname [file normalize [info script]]]
source [file join $HERE .. common scripts common_eco.tcl]
load_design_with_spef setup_eco_top [file join $HERE .. common netlist setup_eco.v] [file join $HERE .. common spef setup_eco.spef]
create_clock -name CLK -period 4.4 [get_ports clk]
set_clock_uncertainty -setup 0.4 [get_clocks CLK]
puts "\n================ BEFORE ================="
setup_report [get_pins U_LAUNCH/Q] [get_pins U_CAPTURE/D]
puts "\n================ ECO ===================="
run_setup_eco
puts "\n================ AFTER =================="
setup_report [get_pins U_LAUNCH/Q] [get_pins U_CAPTURE/D]
dump_eco_info [file join $HERE eco_output]
exit
