source ../common/scripts/common.tcl
load_demo clock_gating_top clock_gating.v
create_clock -name CLK -period 10.0 [get_ports clk]
# Fix: EN is generated/arrives earlier.
set_input_delay 8.5 -clock CLK [get_ports en]
report_timing -late -to [get_pins U_ICG/EN] -max_paths 3
