create_clock -name CLK -period 4.0 [get_ports clk]
set_clock_uncertainty 0.10 [get_clocks CLK]
set_clock_transition 0.05 [get_clocks CLK]
set_input_delay 0.50 -clock CLK [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay 0.50 -clock CLK [all_outputs]

# Force electrical optimization.
set_load 0.30 [all_outputs]
set_max_transition 0.12 [current_design]
set_max_fanout 4 [current_design]
set_false_path -from [get_ports rst_n]
