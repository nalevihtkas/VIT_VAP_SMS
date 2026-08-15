# Path-robust Tempus loader
set COMMON_SCRIPT_DIR [file dirname [file normalize [info script]]]
set ROOT [file normalize [file join $COMMON_SCRIPT_DIR .. ..]]
set LIB  [file join $ROOT common lib teaching_sta_physical.lib]

proc load_demo_local {top netlist_file} {
    global LIB
    if {![file exists $LIB]} { error "Library not found: $LIB" }
    if {![file exists $netlist_file]} { error "Netlist not found: $netlist_file" }
    read_lib $LIB
    read_verilog $netlist_file
    set_top_module $top
}
