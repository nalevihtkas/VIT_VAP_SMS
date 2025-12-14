#!/usr/bin/tclsh
namespace import ::tcl::mathfunc::*
label .l1 -text "Input"
entry .e1 -width 25 -relief sunken -bd 5 -textvariable x
focus .e1
proc COS {widget} {
   	set text COS
 	global x		
    if {$text == "COS"} {
        set text [ cos $x ]
    } else {
        set text "COS"
    }
 set answer [tk_messageBox -message "The COSINE value is $text" \
        -icon question -type ok \
        -detail "Select \"Ok\" to make the application exit"]

    $widget configure -text "COS"
}

proc SIN {widget} {
   	set text SIN
 	global x		
    if {$text == "SIN"} {
        set text [ sin $x ]
    } else {
        set text "SIN"
    }
 set answer [tk_messageBox -message "The SINE value is $text" \
        -icon question -type ok \
        -detail "Select \"Ok\" to make the application exit"]

    $widget configure -text "SIN"
}

proc TAN {widget} {
   	set text TAN 
 	global x		
    if {$text == "TAN"} {
        set text [ tan $x ]
    } else {
        set text "TAN"
    }

 set answer [tk_messageBox -message "The TANGENT value is $text" \
        -icon question -type ok \
        -detail "Select \"Ok\" to make the application exit"]

    $widget configure -text "TAN"
}

proc SQRT {widget} {
   	set text SQRT 
 	global x
	global y		
    if {$text == "SQRT"} {
        set text [ sqrt $x ]
    } else {
        set text "SQRT"
    }
 set answer [tk_messageBox -message "The SQUARE ROOT value is $text" \
        -icon question -type ok \
        -detail "Select \"Ok\" to make the application exit"]
    $widget configure -text "SQRT"
}


button .b1 -text "COS" \
        -command "COS .b1"
button .b2 -text "SIN" \
    -command "SIN .b2 "
button .b3 -text "TAN" \
    -command "TAN .b3"
button .b4 -text "SQRT" \
    -command "SQRT .b4"


# Put them in the window in row order
grid .l1 -row 0 -column 0
grid .e1 -row 0 -column 1
grid .b1 -row 1 -column 0
grid .b2 -row 1 -column 1
grid .b3 -row 2 -column 0
grid .b4 -row 2 -column 1
