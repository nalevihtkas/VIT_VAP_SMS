set HERE [file dirname [file normalize [info script]]]
source [file join $HERE common scripts common_eco.tcl]

puts "\n============= TEMPUS ECO COMMAND CHECK ============="
puts "eco_opt_design   : [info commands eco_opt_design]"
puts "set_eco_opt_mode : [info commands set_eco_opt_mode]"
puts "get_eco_opt_mode : [info commands get_eco_opt_mode]"
puts "ecoAddRepeater   : [info commands ecoAddRepeater]"
puts "ecoChangeCell    : [info commands ecoChangeCell]"
puts "write_eco        : [info commands write_eco]"
puts "write_eco_opt_db : [info commands write_eco_opt_db]"

puts "\n============= help eco_opt_design ==================="
catch {help eco_opt_design} H1
puts $H1
puts "\n============= help set_eco_opt_mode ================="
catch {help set_eco_opt_mode} H2
puts $H2
exit
