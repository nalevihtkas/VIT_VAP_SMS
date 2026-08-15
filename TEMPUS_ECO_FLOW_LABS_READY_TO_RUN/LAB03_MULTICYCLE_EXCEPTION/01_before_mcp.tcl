set HERE [file dirname [file normalize [info script]]]
source [file join $HERE .. common scripts common_eco.tcl]
load_teaching_design mcp_eco_top [file join $HERE .. common netlist mcp_eco.v]
create_clock -name CLK -period 4.0 [get_ports clk]
setup_report [get_pins U_LAUNCH/Q] [get_pins U_CAPTURE/D]
exit
