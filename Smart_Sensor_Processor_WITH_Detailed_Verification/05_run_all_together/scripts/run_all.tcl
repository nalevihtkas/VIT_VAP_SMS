
# Runs each category in its own clean Genus process.
# Use this only if your Cadence license setup permits a child Genus process.
set ROOT [file normalize [file join [file dirname [info script]] ../..]]

foreach f {
    01_technology_independent
    02_technology_dependent
    03_datapath_synthesis
    04_low_power_synthesis
} {
    set dir [file join $ROOT $f]
    set old [pwd]
    cd $dir
    puts "RUNNING $f ..."
    if {[catch {exec genus -files scripts/run.tcl > genus_master.log 2>@1} M]} {
        cd $old
        error "$f failed. Inspect [file join $dir genus_master.log]\n$M"
    }
    cd $old
}
puts "ALL FLOWS COMPLETED"
