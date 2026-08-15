set HERE [file dirname [file normalize [info script]]]
source [file join $HERE .. common scripts common_eco.tcl]
load_design_with_spef mcp_eco_top [file join $HERE .. common netlist mcp_eco.v] [file join $HERE .. common spef mcp_eco.spef]
create_clock -name CLK -period 4.0 [get_ports clk]
set_multicycle_path 2 -setup -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D]
set_multicycle_path 1 -hold  -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D]
puts "\n================ BEFORE ================="
setup_report [get_pins U_LAUNCH/Q] [get_pins U_CAPTURE/D]
hold_report [get_pins U_LAUNCH/Q] [get_pins U_CAPTURE/D]
exit
