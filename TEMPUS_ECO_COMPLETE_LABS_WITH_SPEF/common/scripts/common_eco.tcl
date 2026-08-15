
set COMMON_DIR [file dirname [file normalize [info script]]]
set ROOT_DIR   [file normalize [file join $COMMON_DIR .. ..]]
set ECO_LIB    [file join $ROOT_DIR common lib teaching_eco.lib]

proc load_design_with_spef {top netlist spef} {
    global ECO_LIB
    puts "INFO: Liberty = $ECO_LIB"
    puts "INFO: Netlist = $netlist"
    puts "INFO: SPEF    = $spef"
    read_lib $ECO_LIB
    read_verilog $netlist
    set_top_module $top

    if {![file exists $spef]} {
        error "Missing SPEF file: $spef"
    }

    if {[llength [info commands read_spef]]} {
        if {[catch {read_spef $spef} msg]} {
            puts "ERROR: read_spef failed: $msg"
            error "Could not load SPEF"
        }
    } elseif {[llength [info commands read_parasitics]]} {
        if {[catch {read_parasitics $spef} msg]} {
            puts "ERROR: read_parasitics failed: $msg"
            error "Could not load parasitics"
        }
    } else {
        error "No SPEF/parasitic reader command found in this Tempus session."
    }
    puts "INFO: SPEF/RC data loaded."
}

proc require_eco {} {
    if {![llength [info commands eco_opt_design]]} {
        error "eco_opt_design is not available."
    }
}

proc setup_report {a b} {
    report_timing -late -from $a -to $b -max_paths 1
}
proc hold_report {a b} {
    report_timing -early -from $a -to $b -max_paths 1
}

proc run_setup_eco {} {
    require_eco
    puts "\n=== RUNNING eco_opt_design -setup ==="
    eco_opt_design -setup
}

proc run_hold_eco {} {
    require_eco
    puts "\n=== RUNNING eco_opt_design -hold ==="
    eco_opt_design -hold
}

proc dump_eco_info {dir} {
    file mkdir $dir
    if {[llength [info commands write_eco_opt_db]]} {
        catch {write_eco_opt_db [file join $dir eco_opt_db]} M
        puts "write_eco_opt_db: $M"
    }
    if {[llength [info commands write_eco]]} {
        catch {write_eco [file join $dir eco_changes.tcl]} M2
        puts "write_eco: $M2"
    }
}
