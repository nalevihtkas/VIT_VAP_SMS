# Resolve the category root from this Tcl file.
# This allows: genus -files scripts/run.tcl from the category folder.
set ROOT [file normalize [file join [file dirname [info script]] ..]]

# Run from category folder: genus -files scripts/run.tcl
set TOP smart_sensor_datapath_opt
set TAG base
file mkdir $ROOT/reports/$TAG
file mkdir $ROOT/outputs/$TAG
set_db init_lib_search_path $ROOT/LIB/
set_db init_hdl_search_path $ROOT/RTL/
read_libs demo_cmos.lib
read_hdl smart_sensor_processor.v
elaborate $TOP
read_sdc $ROOT/constraints/base.sdc
set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium

syn_generic
write_hdl -generic > $ROOT/outputs/$TAG/${TOP}_generic.v
syn_map
syn_opt

report_timing > $ROOT/reports/$TAG/report_timing.rpt
report_power  > $ROOT/reports/$TAG/report_power.rpt
report_area   > $ROOT/reports/$TAG/report_area.rpt
report_qor    > $ROOT/reports/$TAG/report_qor.rpt
report_gates  > $ROOT/reports/$TAG/report_gates.rpt
write_hdl > $ROOT/outputs/$TAG/${TOP}_netlist.v
write_sdc > $ROOT/outputs/$TAG/${TOP}_sdc.sdc
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split > $ROOT/outputs/$TAG/${TOP}_delays.sdf
puts "Completed $TOP $TAG"

reset_design
# Run from category folder: genus -files scripts/run.tcl
set TOP smart_sensor_low_power
set TAG low_power
file mkdir $ROOT/reports/$TAG
file mkdir $ROOT/outputs/$TAG
set_db init_lib_search_path $ROOT/LIB/
set_db init_hdl_search_path $ROOT/RTL/
read_libs demo_cmos.lib
read_hdl smart_sensor_processor.v
elaborate $TOP
read_sdc $ROOT/constraints/optimized.sdc
set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium
if {[catch {set_db lp_insert_clock_gating true} M]} {puts "WARNING: $M"}
if {[catch {set_db / .map_to_multibit true} M]} {puts "WARNING: $M"}
syn_generic
write_hdl -generic > $ROOT/outputs/$TAG/${TOP}_generic.v
syn_map
syn_opt
set VCD ../POWER/activity.vcd
if {[file exists $VCD]} {catch {read_vcd $VCD -scope tb_smart_sensor_all_opt/dut}} else {puts "NOTE: vectorless power"}
report_timing > $ROOT/reports/$TAG/report_timing.rpt
report_power  > $ROOT/reports/$TAG/report_power.rpt
report_area   > $ROOT/reports/$TAG/report_area.rpt
report_qor    > $ROOT/reports/$TAG/report_qor.rpt
report_gates  > $ROOT/reports/$TAG/report_gates.rpt
write_hdl > $ROOT/outputs/$TAG/${TOP}_netlist.v
write_sdc > $ROOT/outputs/$TAG/${TOP}_sdc.sdc
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split > $ROOT/outputs/$TAG/${TOP}_delays.sdf
puts "Completed $TOP $TAG"

reset_design
set TOP smart_sensor_low_power
set TAG vt_timing
file mkdir $ROOT/reports/$TAG
file mkdir $ROOT/outputs/$TAG
set_db init_lib_search_path $ROOT/LIB/
set_db init_hdl_search_path $ROOT/RTL/
read_libs {demo_lvt.lib demo_rvt.lib demo_hvt.lib}
read_hdl smart_sensor_processor.v
elaborate $TOP
read_sdc $ROOT/constraints/optimized.sdc
set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium
set lvt [get_db lib_cells *LVT*]
set rvt [get_db lib_cells *RVT*]
set hvt [get_db lib_cells *HVT*]
catch {set_db $hvt .avoid true}
syn_generic
write_hdl -generic > $ROOT/outputs/$TAG/${TOP}_generic.v
syn_map
syn_opt
report_timing > $ROOT/reports/$TAG/report_timing.rpt
report_power > $ROOT/reports/$TAG/report_power.rpt
report_area > $ROOT/reports/$TAG/report_area.rpt
report_qor > $ROOT/reports/$TAG/report_qor.rpt
report_gates > $ROOT/reports/$TAG/report_gates.rpt
write_hdl > $ROOT/outputs/$TAG/${TOP}_netlist.v
write_sdc > $ROOT/outputs/$TAG/${TOP}_sdc.sdc
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split > $ROOT/outputs/$TAG/${TOP}_delays.sdf

reset_design
set TOP smart_sensor_low_power
set TAG vt_leakage
file mkdir $ROOT/reports/$TAG
file mkdir $ROOT/outputs/$TAG
set_db init_lib_search_path $ROOT/LIB/
set_db init_hdl_search_path $ROOT/RTL/
read_libs {demo_lvt.lib demo_rvt.lib demo_hvt.lib}
read_hdl smart_sensor_processor.v
elaborate $TOP
read_sdc $ROOT/constraints/optimized.sdc
set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium
set lvt [get_db lib_cells *LVT*]
set rvt [get_db lib_cells *RVT*]
set hvt [get_db lib_cells *HVT*]
catch {set_db $lvt .avoid true}
syn_generic
write_hdl -generic > $ROOT/outputs/$TAG/${TOP}_generic.v
syn_map
syn_opt
report_timing > $ROOT/reports/$TAG/report_timing.rpt
report_power > $ROOT/reports/$TAG/report_power.rpt
report_area > $ROOT/reports/$TAG/report_area.rpt
report_qor > $ROOT/reports/$TAG/report_qor.rpt
report_gates > $ROOT/reports/$TAG/report_gates.rpt
write_hdl > $ROOT/outputs/$TAG/${TOP}_netlist.v
write_sdc > $ROOT/outputs/$TAG/${TOP}_sdc.sdc
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split > $ROOT/outputs/$TAG/${TOP}_delays.sdf
