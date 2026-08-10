# Library preflight: run from category folder with
#   genus -files scripts/verify_library.tcl
set ROOT [file normalize [file join [file dirname [info script]] ..]]
set_db init_lib_search_path $ROOT/LIB/
read_libs demo_cmos.lib
puts "==== Sequential cells recognized by Genus ===="
puts [get_db lib_cells *DFF*]
puts "==== Async-clear DFF check ===="
set ASYNC_DFF [get_db lib_cells *DFFR*]
if {[llength $ASYNC_DFF] == 0} {
    error "DFFR_X1 was not recognized. Check LIB/demo_cmos.lib."
}
puts "PASS: asynchronous-clear DFF found: $ASYNC_DFF"
exit
