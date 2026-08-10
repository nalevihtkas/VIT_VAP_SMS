
proc slurp {p} {
    if {![file exists $p]} { return "" }
    set f [open $p r]
    set d [read $f]
    close $f
    return $d
}
proc nre {txt re} {
    return [regexp -all -nocase -- $re $txt]
}
proc check_file {label p} {
    if {[file exists $p]} {
        puts [format "PASS  %-32s %s" $label $p]
        return 1
    } else {
        puts [format "FAIL  %-32s %s" $label $p]
        return 0
    }
}
proc absent {label txt re} {
    if {![regexp -nocase -- $re $txt]} {
        puts "PASS  $label : pattern '$re' absent"
    } else {
        puts "INFO  $label : pattern '$re' still present; inspect structure"
    }
}

set ROOT [file normalize [file join [file dirname [info script]] ..]]

puts "==== LOW-POWER VALIDATION ===="
foreach tag {base low_power vt_timing vt_leakage} {
    set nets [glob -nocomplain $ROOT/outputs/$tag/*_netlist.v]
    if {[llength $nets] == 0} {
        puts "FAIL  $tag mapped netlist missing"
        continue
    }
    set n [slurp [lindex $nets 0]]
    puts ""
    puts "-- $tag --"
    puts "INFO  LVT cells  : [nre $n {LVT}]"
    puts "INFO  RVT cells  : [nre $n {RVT}]"
    puts "INFO  HVT cells  : [nre $n {HVT}]"
    puts "INFO  DFFR cells : [nre $n {DFFR}]"
    puts "INFO  ICG names  : [nre $n {ICG|CLKGATE|CLOCK_GATE}]"
    set status $ROOT/reports/$tag/activity_status.txt
    if {[file exists $status]} {
        puts "INFO  Activity    : [string trim [slurp $status]]"
    }
}
puts ""
puts "Expected policy:"
puts "  base/low_power : mainly RVT"
puts "  vt_timing      : LVT/RVT, HVT discouraged"
puts "  vt_leakage     : RVT/HVT, LVT discouraged"
puts "Check report_power.rpt and report_clock_gating.rpt for final evidence."
