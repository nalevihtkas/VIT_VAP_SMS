set HERE [file dirname [file normalize [info script]]]
source [file join $HERE common scripts common_eco.tcl]
puts "opt_signoff command = [info commands opt_signoff]"
if {[llength [info commands opt_signoff]]} { catch {help opt_signoff} H; puts $H }
exit
