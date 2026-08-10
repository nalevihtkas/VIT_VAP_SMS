
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

set BG $ROOT/outputs/base/smart_sensor_base_generic.v
set OG $ROOT/outputs/optimized/smart_sensor_datapath_opt_generic.v
set BN $ROOT/outputs/base/smart_sensor_base_netlist.v
set ON $ROOT/outputs/optimized/smart_sensor_datapath_opt_netlist.v
set RTL $ROOT/RTL/smart_sensor_processor.v
set bg [slurp $BG]; set og [slurp $OG]; set bn [slurp $BN]; set on [slurp $ON]; set rtl [slurp $RTL]
emit "DATAPATH SYNTHESIS — DETAILED VERIFICATION"
exists_check "Base generic netlist" $BG
exists_check "Optimized generic netlist" $OG

# 6.1
title "6.1" "Operator Inference"
set mobs [count_re $og {\*|mul|mult}]; set adds [count_re $og {\+|add}]
status INFO "Optimized generic multiply-like evidence=$mobs, add-like evidence=$adds"
if {$mobs > 0 && $adds > 0} { status PASS "Generic netlist contains arithmetic inference evidence." } else { status INFO "Operators may have been lowered/renamed; inspect generic gate report." }
expected "Behavioral '*' and '+' become multiplier/adder generic structures before cell mapping."
justification "Operator inference lets synthesis construct arithmetic hardware from RTL expressions."

# 6.2
title "6.2" "Bit-Width Optimization"
evidence {Optimized RTL declares pair01[8:0], sensor_sum[9:0], product_sum[16:0].}
set widths 0
foreach pat {{\[8:0\]} {\[9:0\]} {\[16:0\]}} { if {[contains $og $pat]} { incr widths } }
if {$widths > 0} { status PASS "$widths expected optimized width pattern(s) remain visible in generic netlist." } else { status INFO "Genus rewrote widths/names; inspect RTL plus area report." }
show_matches "Base area" $ROOT/reports/base/report_area.rpt {area|cell}
show_matches "Optimized area" $ROOT/reports/optimized/report_area.rpt {area|cell}
expected "Signals use only the bits required by arithmetic range."
justification "Unneeded width increases adder/register/routing capacitance and therefore area and dynamic power."

# 6.3
title "6.3" "Resource Sharing"
set mb [count_re $bg {\*|mul|mult}]; set mo [count_re $og {\*|mul|mult}]
status INFO "Multiply-like generic evidence: base=$mb optimized=$mo"
if {$mo < $mb} { status PASS "Optimized datapath shows fewer multiply-like structures." } else { status "NOT PROVEN" "This datapath-optimized variant keeps parallel multipliers; explicit resource sharing is demonstrated more strongly in the TI optimized variant." }
expected "When sharing is applied, arithmetic-unit count decreases while MUX/control/latency may increase."
justification "Resource sharing time-multiplexes an expensive operator across mutually exclusive operations."

# 6.4
title "6.4" "Adder-Tree Balancing"
evidence "Baseline RTL uses a serial sum chain; optimized RTL forms product_sum and sensor_sum in parallel before final addition."
show_matches "Base timing path" $ROOT/reports/base/report_timing.rpt {slack|arrival|required}
show_matches "Optimized timing path" $ROOT/reports/optimized/report_timing.rpt {slack|arrival|required}
status INFO "Inspect full timing paths to count serial adder levels; netlist naming is tool-dependent."
expected "Fewer serial addition levels per stage in the optimized architecture."
justification "Balancing associative additions reduces combinational logic depth and can shorten the critical path."

# 6.5
title "6.5" "Pipelining"
set db [count_re $bn {DFFR}]; set do [count_re $on {DFFR}]
status INFO "Mapped async-reset DFF count: base=$db optimized=$do"
if {$do > $db} { status PASS "Optimized design has more registers, consistent with added pipeline stages." } else { status INFO "DFF count did not increase; inspect mapped register structure." }
show_matches "Base timing" $ROOT/reports/base/report_timing.rpt {slack|arrival|required}
show_matches "Optimized timing" $ROOT/reports/optimized/report_timing.rpt {slack|arrival|required}
expected "Shorter combinational path per cycle, improved slack/Fmax, but more registers and latency."
justification "Pipeline registers partition a long arithmetic path into shorter clock-to-clock stages."

# 6.6
title "6.6" "Retiming"
set rs $ROOT/reports/optimized/retiming_status.txt
if {[file exists $rs]} {
    set st [string trim [slurp $rs]]
    status INFO "Retiming command status: $st"
    if {$st eq "COMMAND_ACCEPTED"} { status INFO "Command acceptance alone is not proof that registers moved." }
} else { status "NOT PROVEN" "No retiming_status.txt recorded. Structural/timing comparison is still available." }
expected "Automatic retiming, if supported and beneficial, moves register boundaries without changing cycle-level functionality."
justification "Retiming balances combinational delay between registers; it must be proven by register movement/timing improvement, not only by command acceptance."

# 6.7
title "6.7" "Constant Multiplication"
if {[contains $rtl {pair01_x5\s*=.*<<\s*2}] || [contains $og {<<}]} { status PASS "Shift-add form for multiply-by-5 is present in RTL/generic representation." } else { status INFO "Shift may have been lowered to wiring; inspect weighted arithmetic cone." }
expected "5*x is implemented as (x<<2)+x, avoiding a separate general variable multiplier."
justification "Constant multiplication can often be decomposed into shifts and adds with lower hardware cost."

# 6.8
title "6.8" "Register and Multiplexer Optimization"
set mux [count_re $og {MUX|mux|\?}]
status INFO "MUX/select-like evidence in optimized generic netlist=$mux"
if {[contains $rtl {if\s*\(start\)}]} { status PASS "Optimized RTL uses explicit register-enable style if(start)." }
expected "Enable/select logic may be absorbed or restructured around register inputs (or become a clock-gating candidate in LP flow)."
justification "Synthesis can optimize MUX/enable placement for timing, area, and power while preserving register behavior."

finish
