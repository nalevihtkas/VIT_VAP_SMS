set HERE [file dirname [file normalize [info script]]]
source [file join $HERE .. common scripts common_eco.tcl]
load_teaching_design half_eco_top [file join $HERE .. common netlist half_eco.v]
create_clock -name CLK -period 8.0 -waveform {0 4} [get_ports clk]
setup_report [get_pins U_LAUNCH/Q] [get_pins U_CAPTURE/D]
exit
