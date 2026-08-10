
# Pure Tcl verification helpers. Run with:
#   tclsh scripts/verify_results.tcl
# No Genus license is required for result checking.

set ROOT [file normalize [file join [file dirname [info script]] ..]]
set VERIFY_DIR $ROOT/verification
file mkdir $VERIFY_DIR
set REPORT_FILE $VERIFY_DIR/verification_report.txt
set RF [open $REPORT_FILE w]

proc emit {s} {
    global RF
    puts $s
    puts $RF $s
}
proc finish {} {
    global RF REPORT_FILE
    close $RF
    puts "\nVerification report written to: $REPORT_FILE"
}
proc title {n name} {
    emit ""
    emit "======================================================================"
    emit "$n  $name"
    emit "======================================================================"
}
proc status {kind msg} { emit [format "%-12s %s" $kind $msg] }
proc slurp {p} {
    if {![file exists $p]} { return "" }
    set f [open $p r]; set d [read $f]; close $f; return $d
}
proc count_re {txt pat} { return [regexp -all -nocase -- $pat $txt] }
proc exists_check {label p} {
    if {[file exists $p]} { status PASS "$label exists: $p"; return 1 }
    status FAIL "$label missing: $p"; return 0
}
proc contains {txt pat} { return [regexp -nocase -- $pat $txt] }
proc compare_count {label a b pat} {
    set ca [count_re $a $pat]; set cb [count_re $b $pat]
    status INFO "$label: base/relaxed=$ca optimized/constrained=$cb"
    return [list $ca $cb]
}
proc show_matches {label path pat {limit 6}} {
    if {![file exists $path]} { status INFO "$label: report missing ($path)"; return }
    set txt [slurp $path]
    set lines [split $txt "\n"]
    set found 0
    foreach line $lines {
        if {[regexp -nocase -- $pat $line]} {
            if {$found < $limit} { emit "    $line" }
            incr found
        }
    }
    status INFO "$label: $found matching report line(s)"
}
proc justification {s} { emit "JUSTIFICATION $s" }
proc evidence {s} { emit "EVIDENCE      $s" }
proc expected {s} { emit "EXPECTED      $s" }

set R $ROOT/outputs/relaxed/smart_sensor_datapath_opt_netlist.v
set C $ROOT/outputs/constrained/smart_sensor_datapath_opt_netlist.v
set SDC $ROOT/constraints/optimized.sdc
set r [slurp $R]; set c [slurp $C]; set sdc [slurp $SDC]
emit "TECHNOLOGY-DEPENDENT SYNTHESIS — DETAILED VERIFICATION"
exists_check "Relaxed mapped netlist" $R
exists_check "Constrained mapped netlist" $C

# 5.1
title "5.1" "Technology Mapping"
set mapped [count_re $c {INV|AND|OR|NAND|NOR|AOI|OAI|BUF|DFFR}]
if {$mapped > 0} { status PASS "Mapped netlist contains $mapped recognizable demo-library cell-name occurrence(s)." } else { status FAIL "No recognizable demo-library cell names found." }
expected "Generic operators are represented by cells from demo_cmos.lib."
justification "syn_map converts technology-independent logic into target-library implementations."

# 5.2
title "5.2" "AOI/OAI Mapping"
set aoi [count_re $c {AOI}]; set oai [count_re $c {OAI}]
status INFO "Constrained mapped counts: AOI=$aoi OAI=$oai"
if {$aoi+$oai > 0} { status PASS "At least one complex AOI/OAI cell is present." } else { status "NOT PROVEN" "No AOI/OAI cell selected; equivalent simple-cell mapping may still be legal." }
expected "Functions such as ~((A&B)|(C&D)) can map to AOI22; OAI form can map to OAI22."
justification "A complex gate can replace several simple gates, reducing cell count/interconnect and often logic depth."

# 5.3
title "5.3" "NAND/NOR Mapping"
set nd [count_re $c {NAND}]; set nr [count_re $c {NOR}]
status INFO "Constrained mapped counts: NAND=$nd NOR=$nr"
if {$nd+$nr > 0} { status PASS "NAND/NOR technology cells are present." } else { status "NOT PROVEN" "No NAND/NOR names selected; inspect equivalent mapped logic." }
expected "Library-specific NAND/NOR cells may replace equivalent Boolean networks."
justification "Mapping is cost-driven; exact RTL gate spelling need not be preserved."

# 5.4
title "5.4" "Cell Sizing"
set x4r [count_re $r {_X4}]; set x4c [count_re $c {_X4}]
set x1r [count_re $r {_X1}]; set x1c [count_re $c {_X1}]
status INFO "Drive suffix counts: relaxed X1=$x1r X4=$x4r ; constrained X1=$x1c X4=$x4c"
if {$x4c > $x4r} { status PASS "Constrained run uses more X4 cells: sizing evidence." } else { status INFO "No increase in X4 count; constraints may be met without additional upsizing." }
if {[contains $sdc {set_load\s+0\.30}] && [contains $sdc {set_max_transition\s+0\.12}]} { status PASS "Optimized SDC contains the intended heavy-load/tight-transition constraints." }
expected "Heavier load/tighter slew encourages stronger cells."
justification "Stronger cells lower effective output resistance and improve loaded delay/slew, usually with area/power cost."

# 5.5
title "5.5" "Buffer Insertion"
set br [count_re $r {BUF}]; set bc [count_re $c {BUF}]
status INFO "BUF count: relaxed=$br constrained=$bc"
if {$bc > $br} { status PASS "More buffers are present in the constrained run." } else { status INFO "No buffer-count increase; tool may use resizing or replication instead." }
expected "High-load/high-fanout nets may be split by buffer stages."
justification "Buffers partition capacitive/fanout load so no single driver must directly drive every sink."

# 5.6
title "5.6" "Fanout Repair"
if {[contains $sdc {set_max_fanout\s+4}]} { status PASS "Constrained SDC requests max_fanout 4." } else { status FAIL "Expected max_fanout constraint not found." }
if {$bc > $br || $x4c > $x4r} { status PASS "Structural repair evidence exists (buffering and/or stronger cells)." } else { status INFO "No obvious structural delta; inspect QoR/constraint violations." }
show_matches "Constrained QoR fanout lines" $ROOT/reports/constrained/report_qor.rpt {fanout|violation}
expected "Fanout violations are repaired by buffering, replication, resizing, or a combination."
justification "Fanout repair is the objective; buffer insertion is only one possible repair mechanism."

# 5.7
title "5.7" "Transition Repair"
if {[contains $sdc {set_max_transition\s+0\.12}]} { status PASS "Constrained SDC requests max_transition 0.12." }
show_matches "Constrained timing transition/slew lines" $ROOT/reports/constrained/report_timing.rpt {transition|slew|slack|violation}
show_matches "Constrained QoR transition/slew lines" $ROOT/reports/constrained/report_qor.rpt {transition|slew|violation}
if {$bc > $br || $x4c > $x4r} { status PASS "Buffer/upsizing evidence is consistent with transition repair." } else { status INFO "No obvious cell-change evidence; report may show constraints were already satisfied." }
expected "Slow edges are repaired by stronger drivers and/or inserted buffers."
justification "Output transition depends on driver strength and capacitive load; repair improves electrical slew quality."

# 5.8
title "5.8" "Drive-Strength Optimization"
status INFO "Relaxed X1=$x1r X4=$x4r ; constrained X1=$x1c X4=$x4c"
if {$x4c > $x4r} { status PASS "Stronger X4 usage increased under constrained conditions." } else { status INFO "No X4 increase; inspect exact cell replacements in diff." }
expected "Selected X1 cells may be replaced with X4 equivalents on critical/heavily loaded paths."
justification "Drive-strength optimization trades area/input capacitance/power for better loaded timing and transition."

finish
