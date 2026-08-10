# Run from category folder: genus -files scripts/run.tcl
set TOP smart_sensor_datapath_opt
set TAG relaxed
file mkdir reports/$TAG
file mkdir outputs/$TAG
set_db init_lib_search_path ../LIB/
set_db init_hdl_search_path ../RTL/
read_libs demo_cmos.lib
read_hdl smart_sensor_processor.v
elaborate $TOP
read_sdc ../constraints/base.sdc
set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium

syn_generic
write_hdl -generic > outputs/$TAG/${TOP}_generic.v
syn_map
syn_opt

report_timing > reports/$TAG/report_timing.rpt
report_power  > reports/$TAG/report_power.rpt
report_area   > reports/$TAG/report_area.rpt
report_qor    > reports/$TAG/report_qor.rpt
report_gates  > reports/$TAG/report_gates.rpt
write_hdl > outputs/$TAG/${TOP}_netlist.v
write_sdc > outputs/$TAG/${TOP}_sdc.sdc
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split > outputs/$TAG/${TOP}_delays.sdf
puts "Completed $TOP $TAG"

reset_design
# Run from category folder: genus -files scripts/run.tcl
set TOP smart_sensor_datapath_opt
set TAG constrained
file mkdir reports/$TAG
file mkdir outputs/$TAG
set_db init_lib_search_path ../LIB/
set_db init_hdl_search_path ../RTL/
read_libs demo_cmos.lib
read_hdl smart_sensor_processor.v
elaborate $TOP
read_sdc ../constraints/optimized.sdc
set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium
# Electrical optimization driven by optimized.sdc
syn_generic
write_hdl -generic > outputs/$TAG/${TOP}_generic.v
syn_map
syn_opt

report_timing > reports/$TAG/report_timing.rpt
report_power  > reports/$TAG/report_power.rpt
report_area   > reports/$TAG/report_area.rpt
report_qor    > reports/$TAG/report_qor.rpt
report_gates  > reports/$TAG/report_gates.rpt
write_hdl > outputs/$TAG/${TOP}_netlist.v
write_sdc > outputs/$TAG/${TOP}_sdc.sdc
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split > outputs/$TAG/${TOP}_delays.sdf
puts "Completed $TOP $TAG"
