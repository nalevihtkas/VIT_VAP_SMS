
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
set R $ROOT/outputs/relaxed/smart_sensor_datapath_opt_netlist.v
set C $ROOT/outputs/constrained/smart_sensor_datapath_opt_netlist.v

puts "==== TECHNOLOGY-DEPENDENT VALIDATION ===="
check_file "relaxed mapped netlist" $R
check_file "constrained mapped netlist" $C
set r [slurp $R]
set c [slurp $C]

foreach pat {AOI OAI NAND NOR BUF DFFR {_X1} {_X4}} {
    puts [format "INFO  %-8s relaxed=%-4d constrained=%-4d" $pat [nre $r $pat] [nre $c $pat]]
}

puts ""
puts "Interpretation:"
puts "  AOI/OAI/NAND/NOR > 0  => technology mapping evidence."
puts "  More BUF in constrained => buffer/fanout repair evidence."
puts "  More _X4 in constrained => sizing/drive-strength evidence."
puts "  Compare report_timing.rpt/report_qor.rpt for transition/fanout effects."
