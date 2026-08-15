puts "Tempus ECO environment diagnostic"
foreach c {eco_opt_design set_eco_opt_mode get_eco_opt_mode ecoAddRepeater ecoChangeCell write_eco write_eco_opt_db read_spef read_parasitics} {
  puts [format "%-22s : %s" $c [info commands $c]]
}
puts "\nStart ECO runs with: tempus -eco -files <script.tcl>"
catch {help eco_opt_design} H
puts "\n--- eco_opt_design help ---\n$H"
exit
