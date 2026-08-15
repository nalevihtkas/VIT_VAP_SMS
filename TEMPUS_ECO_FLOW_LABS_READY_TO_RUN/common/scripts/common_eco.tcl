
set COMMON_DIR [file dirname [file normalize [info script]]]
set ROOT_DIR   [file normalize [file join $COMMON_DIR .. ..]]
set ECO_LIB    [file join $ROOT_DIR common lib teaching_eco.lib]

proc load_teaching_design {top netlist} {
    global ECO_LIB
    puts "INFO: Liberty = $ECO_LIB"
    puts "INFO: Netlist = $netlist"
    read_lib $ECO_LIB
    read_verilog $netlist
    set_top_module $top
}
proc require_tempus_eco {} {
    if {![llength [info commands opt_signoff]]} {
        puts "ERROR: opt_signoff is unavailable in this Tempus session."
        puts "Run: help opt_signoff"
        error "Tempus ECO capability/license not available"
    }
}
proc setup_report {a b} { report_timing -late  -from $a -to $b -max_paths 1 }
proc hold_report  {a b} { report_timing -early -from $a -to $b -max_paths 1 }

proc try_write_post_eco_netlist {outfile} {
    if {[llength [info commands write_verilog]]} {
        if {![catch {write_verilog $outfile}]} { puts "WROTE: $outfile"; return }
    }
    if {[llength [info commands write_netlist]]} {
        if {![catch {write_netlist $outfile}]} { puts "WROTE: $outfile"; return }
    }
    puts "INFO: Direct post-ECO netlist writer was not automatically resolved for this release."
    puts "INFO: For production physical ECO, implement in Innovus and write the post-ECO netlist there."
}
