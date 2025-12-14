label .l5 -text "Gate"
set mylist [list and or nor nand xor xnor]
ttk::combobox .s1  -textvariable combovalue -values $mylist -width 40 -justify left -state normal
set combovalue "and"

label .l1 -text "ModuleName"
entry .e1 -width 25 -relief sunken -bd 5 -textvariable a
focus .e1

label .l2 -text "Input 1"
entry .e2 -width 25 -relief sunken -bd 5 -textvariable b
focus .e2

label .l3 -text "Input 2"
entry .e3 -width 25 -relief sunken -bd 5 -textvariable c
focus .e3

label .l4 -text "Output"
entry .e4 -width 25 -relief sunken -bd 5 -textvariable d
focus .e4

button .b1 -text "Create_Module" -command {exec perl $combovalue.pl $a $b $c $d}
button .b2 -text "Exit" -command {exit}

grid .s1 -row 0 -column 1 -sticky w
grid .l5 -row 0 -column 0 -sticky e
grid .l1 -row 1 -column 0 -sticky e
grid .e1 -row 1 -column 1 -sticky w
grid .l2 -row 2 -column 0 -sticky e
grid .e2 -row 2 -column 1 -sticky w
grid .l3 -row 3 -column 0 -sticky e
grid .e3 -row 3 -column 1 -sticky w
grid .l4 -row 4 -column 0 -sticky e
grid .e4 -row 4 -column 1 -sticky w
grid .b1 -row 5 -column 1 -sticky w
grid .b2 -row 5 -column 1 -sticky e
