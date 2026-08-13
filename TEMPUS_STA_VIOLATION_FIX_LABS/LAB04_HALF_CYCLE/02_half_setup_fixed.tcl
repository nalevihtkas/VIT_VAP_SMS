source ../common/scripts/common.tcl
load_demo half_cycle_top half_cycle.v
create_clock -name CLK -period 10.0 -waveform {0 5} [get_ports clk]
report_timing -late -from [get_pins U_LAUNCH/Q] -to [get_pins U_CAPTURE/D] -max_paths 1
