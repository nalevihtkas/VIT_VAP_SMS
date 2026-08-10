
set ROOT [file normalize [file join [file dirname [info script]] ..]]
file mkdir $ROOT/reports/optimized
file mkdir $ROOT/outputs/optimized

set_db init_lib_search_path $ROOT/LIB/
set_db init_hdl_search_path $ROOT/RTL/
read_libs demo_cmos.lib

read_hdl $ROOT/RTL/smart_sensor_processor.v
elaborate smart_sensor_datapath_opt
read_sdc $ROOT/constraints/optimized.sdc

set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium

if {[catch {set_db design:smart_sensor_datapath_opt .retime true} M]} {puts "WARNING: $M"}

syn_generic
write_hdl -generic > $ROOT/outputs/optimized/smart_sensor_datapath_opt_generic.v
report_area > $ROOT/reports/optimized/report_area_generic.rpt
catch {report_gates > $ROOT/reports/optimized/report_gates_generic.rpt}

syn_map
syn_opt



report_timing > $ROOT/reports/optimized/report_timing.rpt
report_power  > $ROOT/reports/optimized/report_power.rpt
report_area   > $ROOT/reports/optimized/report_area.rpt
report_qor    > $ROOT/reports/optimized/report_qor.rpt
report_gates  > $ROOT/reports/optimized/report_gates.rpt

write_hdl > $ROOT/outputs/optimized/smart_sensor_datapath_opt_netlist.v
write_sdc > $ROOT/outputs/optimized/smart_sensor_datapath_opt_sdc.sdc
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split \
    > $ROOT/outputs/optimized/smart_sensor_datapath_opt_delays.sdf

puts "COMPLETED optimized"
