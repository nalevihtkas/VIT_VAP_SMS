# Common Tempus loader (corrected, path-robust version)
# This file locates the package from its own path, so the labs can be launched
# from the lab directory OR from another current working directory.
set COMMON_SCRIPT_DIR [file dirname [file normalize [info script]]]
set ROOT              [file normalize [file join $COMMON_SCRIPT_DIR .. ..]]
set LIB               [file join $ROOT common lib teaching_sta.lib]

proc load_demo {top netlist} {
    global ROOT LIB

    set netlist_file [file join $ROOT common netlist $netlist]

    if {![file exists $LIB]} {
        error "Teaching Liberty file not found: $LIB"
    }
    if {![file exists $netlist_file]} {
        error "Teaching netlist not found: $netlist_file"
    }

    # Load the self-contained teaching library/netlist.
    read_lib $LIB
    read_verilog $netlist_file
    set_top_module $top
}
