source ../common/scripts/common.tcl
load_demo setup_hold_top setup_hold.v
create_clock -name CLK -period 10.0 [get_ports clk]
# Fix demonstration: corrected minimum-delay requirement for this teaching netlist.
set_min_delay 3.0 -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D]
report_timing -early -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D] -max_paths 1
