
set ROOT [file normalize [file join [file dirname [info script]] ..]]
file mkdir $ROOT/reports/relaxed
file mkdir $ROOT/outputs/relaxed

set_db init_lib_search_path $ROOT/LIB/
set_db init_hdl_search_path $ROOT/RTL/
read_libs demo_cmos.lib

read_hdl $ROOT/RTL/smart_sensor_processor.v
elaborate smart_sensor_datapath_opt
read_sdc $ROOT/constraints/base.sdc

set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium



syn_generic
write_hdl -generic > $ROOT/outputs/relaxed/smart_sensor_datapath_opt_generic.v
report_area > $ROOT/reports/relaxed/report_area_generic.rpt
catch {report_gates > $ROOT/reports/relaxed/report_gates_generic.rpt}

syn_map
syn_opt



report_timing > $ROOT/reports/relaxed/report_timing.rpt
report_power  > $ROOT/reports/relaxed/report_power.rpt
report_area   > $ROOT/reports/relaxed/report_area.rpt
report_qor    > $ROOT/reports/relaxed/report_qor.rpt
report_gates  > $ROOT/reports/relaxed/report_gates.rpt

write_hdl > $ROOT/outputs/relaxed/smart_sensor_datapath_opt_netlist.v
write_sdc > $ROOT/outputs/relaxed/smart_sensor_datapath_opt_sdc.sdc
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split \
    > $ROOT/outputs/relaxed/smart_sensor_datapath_opt_delays.sdf

puts "COMPLETED relaxed"
