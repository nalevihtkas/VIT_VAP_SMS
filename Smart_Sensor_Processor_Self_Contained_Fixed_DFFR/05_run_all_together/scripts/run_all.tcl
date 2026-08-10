set ROOT [file normalize [file join [file dirname [info script]] ../..]]
foreach f {01_technology_independent 02_technology_dependent 03_datapath_synthesis 04_low_power_synthesis} {
 set dir [file join $ROOT $f]; set old [pwd]; cd $dir
 if {[catch {exec genus -files scripts/run.tcl > genus_master.log 2>@1} M]} {cd $old; error "$f failed: $M"}
 cd $old
}
puts "ALL FLOWS COMPLETED"
