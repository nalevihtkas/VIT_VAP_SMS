set HERE [file dirname [file normalize [info script]]]
source [file join $HERE .. common scripts common_eco.tcl]
load_design_with_spef mcp_eco_top [file join $HERE .. common netlist mcp_eco.v] [file join $HERE .. common spef mcp_eco.spef]
create_clock -name CLK -period 4.0 [get_ports clk]
puts "\n================ BEFORE ================="
setup_report [get_pins U_LAUNCH/Q] [get_pins U_CAPTURE/D]
exit
