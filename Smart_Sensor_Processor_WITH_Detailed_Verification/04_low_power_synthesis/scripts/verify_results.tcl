
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
set rtl [slurp $RTL]
emit "LOW-POWER SYNTHESIS — DETAILED VERIFICATION"

proc lp_net {tag} {
    global ROOT
    set f [glob -nocomplain $ROOT/outputs/$tag/*_netlist.v]
    if {[llength $f]} { return [lindex $f 0] }
    return ""
}
set BP [lp_net base]; set LPF [lp_net low_power]; set VT [lp_net vt_timing]; set VL [lp_net vt_leakage]
set b [slurp $BP]; set l [slurp $LPF]; set vt [slurp $VT]; set vl [slurp $VL]

# 7.1
title "7.1" "Clock Gating"
evidence "Low-power RTL updates major register banks only under if(active); run.tcl attempts lp_insert_clock_gating."
set icg [count_re $l {ICG|CLKGATE|CLOCK_GATE}]
if {$icg > 0} { status PASS "$icg clock-gating-cell name occurrence(s) found in mapped netlist." } else { status "NOT PROVEN" "No ICG/clock-gate cell found. With the demo library this is expected unless a real ICG cell is supplied." }
if {[file exists $ROOT/reports/low_power/report_clock_gating.rpt]} { status INFO "Clock-gating report exists; inspect it for inserted/eligible register groups." }
expected "A real ICG cell drives grouped register clocks when enable is inactive."
justification "Clock gating lowers clock activity alpha and therefore dynamic clock/register power; RTL enable alone is only a candidate, not proof of ICG insertion."

# 7.2
title "7.2" "Operand Isolation"
if {[contains $rtl {iso_s0\s*=\s*active\s*\?}]} { status PASS "RTL contains operand isolation clamps iso_s0..iso_s3." } else { status FAIL "Operand-isolation RTL pattern not found." }
set isoVisible [count_re [slurp $ROOT/outputs/low_power/smart_sensor_low_power_generic.v] {iso_s|active|MUX|mux}]
status INFO "Isolation/select-like generic-netlist evidence=$isoVisible"
expected "When active=0, multiplier inputs are clamped to zero so internal multiplier toggling is suppressed."
justification "Stopping irrelevant operand transitions reduces internal switching activity and dynamic power."

# 7.3
title "7.3" "Data Gating"
if {[contains $rtl {if\s*\(active\)}]} { status PASS "RTL contains if(active) updates for datapath registers." } else { status FAIL "Data-gating enable pattern not found." }
show_matches "Base power" $ROOT/reports/base/report_power.rpt {power|switch|internal|leak}
show_matches "Low-power power" $ROOT/reports/low_power/report_power.rpt {power|switch|internal|leak}
expected "Inactive data does not propagate into storage/datapath updates; switching power should reduce under representative activity."
justification "Data gating suppresses unnecessary data activity, but a fair power comparison requires comparable activity annotation."

# 7.4
title "7.4" "Multi-Bit Flip-Flop Candidate"
set mb [count_re $l {DFF2|DFF4|DFF8|MBFF}]
if {$mb > 0} { status PASS "$mb MBFF-like mapped-cell occurrence(s) found." } else { status "NOT PROVEN" "No MBFF cell found. Demo libraries do not provide real multi-bit flop cells." }
if {[contains $rtl {reg\s+\[16:0\]\s+product_sum_reg}]} { status PASS "Grouped vector registers exist as MBFF candidates." }
expected "With an MBFF-capable library, several bit flops can map to a shared-clock multi-bit cell."
justification "MBFFs reduce duplicated clock-buffering/internal clock capacitance; declaring a vector alone does not prove physical MBFF mapping."

# 7.5
title "7.5" "Multi-Vt Mapping"
foreach pair [list [list vt_timing $vt] [list vt_leakage $vl]] {
    set tag [lindex $pair 0]; set n [lindex $pair 1]
    status INFO "$tag counts: LVT=[count_re $n {LVT}] RVT=[count_re $n {RVT}] HVT=[count_re $n {HVT}]"
}
if {[count_re $vt {HVT}] == 0} { status PASS "Timing policy shows no HVT occurrence (HVT discouraged)." } else { status INFO "HVT appears despite timing policy; inspect .avoid behavior/tool mapping." }
if {[count_re $vl {LVT}] == 0} { status PASS "Leakage policy shows no LVT occurrence (LVT discouraged)." } else { status INFO "LVT appears despite leakage policy; inspect .avoid behavior/tool mapping." }
show_matches "VT timing timing report" $ROOT/reports/vt_timing/report_timing.rpt {slack|arrival|required}
show_matches "VT leakage power report" $ROOT/reports/vt_leakage/report_power.rpt {power|leak}
expected "Timing policy favors LVT/RVT; leakage policy favors RVT/HVT."
justification "Lower-Vt cells are typically faster but leakier; higher-Vt cells trade speed for lower leakage."

# 7.6
title "7.6" "Multi-Voltage Operation"
set upf $ROOT/POWER/multi_voltage.upf
if {[file exists $upf]} { status PASS "Multi-voltage UPF template is present." } else { status FAIL "multi_voltage.upf template missing." }
set ls [count_re $l {LEVEL|LEVEL_SHIFTER|LS_}]
if {$ls > 0} { status PASS "$ls level-shifter-like cell occurrence(s) found." } else { status "NOT PROVEN" "No physical level-shifter cell found in mapped netlist." }
expected "A real multi-voltage implementation contains domains/supplies and level shifters on required crossings."
justification "Behavioral connectivity or an UPF template alone is not proof; physical proof requires actual level-shifter cells and power-aware libraries."

# 7.7
title "7.7" "Power Gating"
set pg $ROOT/POWER/power_gating.upf
if {[file exists $pg]} { status PASS "Power-gating UPF template is present." } else { status FAIL "power_gating.upf template missing." }
set ps [count_re $l {POWER_SWITCH|PSW|SWITCH}]
if {$ps > 0} { status PASS "$ps power-switch-like mapped occurrence(s) found." } else { status "NOT PROVEN" "No physical power-switch cell found." }
expected "A real switchable domain has power-switch cells and a virtual supply net."
justification "RTL power_on is behavioral control, not a physical supply switch; physical proof requires special cells and UPF implementation."

# 7.8
title "7.8" "Isolation"
if {[contains $rtl {if\s*\(isolate\s*\|\|\s*!power_on\)}]} { status PASS "Behavioral isolation clamp is present in RTL." }
set iso [count_re $l {ISO|ISOLATION}]
if {$iso > 0} { status PASS "$iso isolation-cell-like occurrence(s) found." } else { status "NOT PROVEN" "Behavioral clamp exists, but no physical isolation cell is mapped." }
expected "Outputs are clamped to a safe value when the switchable domain is off."
justification "Functional clamp logic proves behavior; a true isolation implementation requires a characterized isolation cell and power intent."

# 7.9
title "7.9" "Retention"
if {[contains $rtl {retained_result}]} { status PASS "Behavioral retained_result storage is present in RTL." }
set ret [count_re $l {RET|RETENTION}]
if {$ret > 0} { status PASS "$ret retention-cell-like occurrence(s) found." } else { status "NOT PROVEN" "No physical retention flop is mapped; use simulation for behavioral preservation." }
expected "During simulated power-off/isolation, output is clamped; after restore the retained state can reappear."
justification "A normal DFF/behavioral register is not a retention cell; physical retention needs special cells, retention supply, and UPF mapping."

# 7.10
title "7.10" "Activity-Driven Power Optimization"
set st $ROOT/reports/low_power/activity_status.txt
if {[file exists $st]} {
    set v [string trim [slurp $st]]
    status INFO "Activity annotation status=$v"
    if {$v eq "VCD_ANNOTATED"} { status PASS "VCD activity was successfully read before power reporting." } else { status "NOT PROVEN" "Power is vectorless or VCD annotation failed." }
} else { status FAIL "activity_status.txt missing." }
expected "Power report uses simulation-derived switching activity when VCD annotation succeeds."
justification "Dynamic power depends on switching activity alpha; VCD-derived activity is more workload-representative than vectorless assumptions."

finish
