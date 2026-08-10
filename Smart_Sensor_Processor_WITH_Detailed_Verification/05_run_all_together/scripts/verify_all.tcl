
set ROOT [file normalize [file join [file dirname [info script]] ../..]]
foreach flow {
    01_technology_independent
    02_technology_dependent
    03_datapath_synthesis
    04_low_power_synthesis
} {
    puts "\n######################################################################"
    puts "VERIFYING $flow"
    puts "######################################################################"
    set script [file join $ROOT $flow scripts verify_results.tcl]
    if {[catch {exec tclsh $script 2>@1} msg]} {
        puts "VERIFICATION SCRIPT ERROR: $msg"
    } else {
        puts $msg
    }
}
puts "\nALL VERIFICATION SCRIPTS COMPLETED"
