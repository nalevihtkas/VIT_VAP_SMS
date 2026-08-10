
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
set BG $ROOT/outputs/base/smart_sensor_base_generic.v
set OG $ROOT/outputs/optimized/smart_sensor_datapath_opt_generic.v
set BN $ROOT/outputs/base/smart_sensor_base_netlist.v
set ON $ROOT/outputs/optimized/smart_sensor_datapath_opt_netlist.v

puts "==== DATAPATH VALIDATION ===="
check_file "base generic netlist" $BG
check_file "optimized generic netlist" $OG
check_file "base mapped netlist" $BN
check_file "optimized mapped netlist" $ON

set bg [slurp $BG]
set og [slurp $OG]
set bn [slurp $BN]
set on [slurp $ON]

puts [format "INFO  generic '*'/multiply-like evidence base=%d optimized=%d" [nre $bg {\*|mul|mult}] [nre $og {\*|mul|mult}]]
puts [format "INFO  mapped DFFR count              base=%d optimized=%d" [nre $bn {DFFR}] [nre $on {DFFR}]]
puts [format "INFO  generic bytes                  base=%d optimized=%d" [string length $bg] [string length $og]]

puts ""
puts "Inspect:"
puts "  reports/base/report_timing.rpt"
puts "  reports/optimized/report_timing.rpt"
puts "  reports/base/report_area.rpt"
puts "  reports/optimized/report_area.rpt"
puts "Pipelining is indicated by a higher sequential-cell count together with a"
puts "shorter/better critical path. Constant multiplication should not appear as a"
puts "separate variable multiplier."
