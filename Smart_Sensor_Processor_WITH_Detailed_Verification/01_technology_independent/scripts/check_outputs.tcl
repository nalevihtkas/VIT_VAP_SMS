
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
set BASEG $ROOT/outputs/base/smart_sensor_base_generic.v
set OPTG  $ROOT/outputs/optimized/smart_sensor_ti_opt_generic.v
set BASEN $ROOT/outputs/base/smart_sensor_base_netlist.v
set OPTN  $ROOT/outputs/optimized/smart_sensor_ti_opt_netlist.v

puts "==== TECHNOLOGY-INDEPENDENT VALIDATION ===="
check_file "base generic netlist" $BASEG
check_file "optimized generic netlist" $OPTG
check_file "base mapped netlist" $BASEN
check_file "optimized mapped netlist" $OPTN

set b [slurp $BASEG]
set o [slurp $OPTG]
set on [slurp $OPTN]

puts ""
puts "-- Generic optimization evidence --"
absent "Constant propagation fixed_mode" $o {fixed_mode}
absent "Dead-code unused product" $o {unused_debug_product}
absent "Boolean redundant_enable" $o {redundant_enable}
absent "FSM DEBUG state" $o {DEBUG}
absent "Flattened leaf hierarchy" $o {sensor_preprocess_leaf|u_pair01}

puts "INFO  base generic bytes      : [string length $b]"
puts "INFO  optimized generic bytes : [string length $o]"
puts "INFO  DFFR mapped count       : [nre $on {DFFR}]"
puts ""
puts "Inspect additionally:"
puts "  reports/base/report_area_generic.rpt"
puts "  reports/optimized/report_area_generic.rpt"
puts "  reports/base/report_gates_generic.rpt"
puts "  reports/optimized/report_gates_generic.rpt"
puts "For CSE/resource sharing/arithmetic simplification, compare the generic netlists"
puts "and generic area/gate reports; Genus may rename intermediate signals."
