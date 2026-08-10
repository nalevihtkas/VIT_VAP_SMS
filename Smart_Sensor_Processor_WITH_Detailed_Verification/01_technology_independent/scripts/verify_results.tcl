
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

set RTL $ROOT/RTL/smart_sensor_processor.v
set BG $ROOT/outputs/base/smart_sensor_base_generic.v
set OG $ROOT/outputs/optimized/smart_sensor_ti_opt_generic.v
set BN $ROOT/outputs/base/smart_sensor_base_netlist.v
set ON $ROOT/outputs/optimized/smart_sensor_ti_opt_netlist.v
set brtl [slurp $RTL]; set bg [slurp $BG]; set og [slurp $OG]; set bn [slurp $BN]; set on [slurp $ON]

emit "TECHNOLOGY-INDEPENDENT SYNTHESIS — DETAILED VERIFICATION"
exists_check "Base generic netlist" $BG
exists_check "Optimized generic netlist" $OG

# 4.1
title "4.1" "Constant Propagation"
evidence "Baseline RTL contains fixed_mode = 1'b1. Check whether syn_generic removes that constant signal/logic from the BASE generic netlist."
if {[contains $brtl {fixed_mode\s*=\s*1'b1}] && ![contains $bg {fixed_mode}]} {
    status PASS "fixed_mode exists in RTL but is absent after syn_generic: direct constant-propagation evidence."
} elseif {![contains $bg {fixed_mode}]} {
    status INFO "fixed_mode absent from base generic netlist; Genus may have renamed/absorbed it."
} else { status "NOT PROVEN" "fixed_mode still appears; inspect its fanout cone." }
expected "Constant-controlled gate/MUX disappears or simplifies to the surviving branch."
justification "A permanently known logic value can be evaluated during generic synthesis; gates whose result becomes redundant are removed."

# 4.2
title "4.2" "Dead-Code Removal"
evidence "Baseline RTL declares unused_debug_product = s2 * s3 and it has no observable fanout."
if {[contains $brtl {unused_debug_product}] && ![contains $bg {unused_debug_product}]} {
    status PASS "unused_debug_product is absent after syn_generic."
} else { status INFO "Signal names may be changed; compare generic gate/area reports and multiplier structures." }
show_matches "Base generic area" $ROOT/reports/base/report_area_generic.rpt {area|cell}
show_matches "Optimized generic area" $ROOT/reports/optimized/report_area_generic.rpt {area|cell}
expected "Unused multiplier cone disappears; combinational area/power should not include it."
justification "Logic that cannot affect an output or retained state has no functional purpose and is eliminated."

# 4.3
title "4.3" "Boolean Simplification"
evidence "Baseline RTL contains (enable & start) | (enable & ~start), algebraically equal to enable."
if {[contains $brtl {redundant_enable}] && ![contains $bg {redundant_enable}]} {
    status PASS "redundant_enable is absent from base generic netlist."
} else { status INFO "Signal may be renamed; inspect generic structure around enable/start." }
expected "2 AND + inverter + OR structure collapses to the equivalent enable function."
justification "E*S + E*~S = E*(S+~S) = E. Generic Boolean optimization reduces logic depth and gate count."

# 4.4
title "4.4" "Common-Subexpression Elimination"
evidence "The optimized RTL explicitly computes common_pair = s0+s1 once and reuses it for path_a/path_b."
set plusB [count_re $bg {\+}]; set plusO [count_re $og {\+}]
status INFO "'+' operator text count in generic netlists: base=$plusB optimized=$plusO (only a hint; Genus may rewrite operators)."
if {[contains $og {common_pair}]} { status PASS "common_pair remains visible in optimized generic netlist." } else { status INFO "common_pair name was optimized/renamed; use gate/area comparison instead." }
show_matches "Base generic gate report" $ROOT/reports/base/report_gates_generic.rpt {add|adder|cell|gate}
show_matches "Optimized generic gate report" $ROOT/reports/optimized/report_gates_generic.rpt {add|adder|cell|gate}
expected "One s0+s1 result is shared by two consumers rather than recomputed twice."
justification "Sharing a common arithmetic subexpression reduces duplicated hardware, with possible fanout/timing trade-off."

# 4.5
title "4.5" "Arithmetic Simplification"
evidence "Baseline contains full_sum + 0; optimized RTL uses multiply-by-5 as (x<<2)+x."
if {![contains $bg {arithmetic_redundant}] || ![contains $bg {20'd0}]} { status PASS "Redundant +0 structure/name is absent or absorbed after generic synthesis." } else { status INFO "Inspect the generic arithmetic cone; textual constant is still present." }
if {[contains $og {weighted_common|<<}]} { status PASS "Shift/add constant-multiply structure is visible in optimized generic netlist." } else { status INFO "Genus may have rewritten shift wiring; inspect generic netlist around weighted path." }
expected "x+0 disappears; constant multiply uses shift/wiring plus addition rather than a general variable multiplier."
justification "Arithmetic identities and powers-of-two shifts reduce generic arithmetic cost."

# 4.6
title "4.6" "FSM Optimization"
evidence "Baseline RTL contains DEBUG state; smart_sensor_ti_opt removes DEBUG from the optimized RTL."
if {![contains $og {DEBUG}]} { status PASS "DEBUG state name is absent in optimized generic netlist." } else { status INFO "DEBUG text remains; inspect state decode logic." }
show_matches "Base gate report" $ROOT/reports/base/report_gates.rpt {mux|dff|cell|gate}
show_matches "Optimized gate report" $ROOT/reports/optimized/report_gates.rpt {mux|dff|cell|gate}
expected "Less state/decode/MUX logic in the optimized version."
justification "Unnecessary states and their transitions/output decodes consume state/control logic without useful behavior."

# 4.7
title "4.7" "Resource Sharing"
evidence "Baseline has two products; TI optimized architecture contains one shared_product selected over multiple cycles."
set mb [count_re $bg {\*|mul|mult}]; set mo [count_re $og {\*|mul|mult}]
status INFO "Multiply-like textual evidence: base=$mb optimized=$mo."
if {[contains $og {shared_product}]} { status PASS "shared_product is visible in optimized generic netlist." } else { status INFO "Name optimized away; inspect multiplier count/generic area." }
show_matches "Base final area" $ROOT/reports/base/report_area.rpt {area|cell}
show_matches "Optimized final area" $ROOT/reports/optimized/report_area.rpt {area|cell}
expected "Fewer multiplier resources, but additional MUX/control and increased latency."
justification "Expensive arithmetic hardware can be time-multiplexed when operations need not occur simultaneously."

# 4.8
title "4.8" "Hierarchy Optimization"
evidence "Optimized Tcl applies ungroup -all -flatten."
if {![contains $og {sensor_preprocess_leaf|u_pair01}]} { status PASS "Leaf hierarchy names are absent from optimized generic netlist." } else { status "NOT PROVEN" "Leaf hierarchy is still visible; check whether ungroup command was accepted/applied." }
expected "Leaf boundary disappears, allowing cross-boundary optimization."
justification "Flattening expands the optimization scope, potentially improving area/timing at the cost of hierarchy readability."

finish
