# Common Tempus loader
# Run this script from an individual LABxx directory.
set LAB_DIR [file normalize [pwd]]
set ROOT    [file normalize [file join $LAB_DIR ..]]
set LIB     [file join $ROOT common lib teaching_sta.lib]

proc load_demo {top netlist} {
    global ROOT LIB
    set init_lib_search_path [list [file dirname $LIB]]
    set init_verilog [file join $ROOT common netlist $netlist]
    set init_top_cell $top
    set init_mmmc_file ""
    read_lib $LIB
    read_verilog $init_verilog
    set_top_module $top
}
