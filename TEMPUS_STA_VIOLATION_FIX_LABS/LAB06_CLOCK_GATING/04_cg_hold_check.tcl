source ../common/scripts/common.tcl
load_demo clock_gating_top clock_gating.v
create_clock -name CLK -period 10.0 [get_ports clk]
set_input_delay -min 0.5 -clock CLK [get_ports en]
report_timing -early -to [get_pins U_ICG/EN] -max_paths 3
