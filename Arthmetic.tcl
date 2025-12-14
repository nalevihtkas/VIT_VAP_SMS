set x 10
set y 5

proc sum {widget} {
    global x y
    set result [expr {$x + $y}]
    $widget configure -text $result
}

proc Diff {widget} {
    global x y
    set result [expr {$x - $y}]
    $widget configure -text $result
}

proc Mul {widget} {
    global x y
    set result [expr {$x * $y}]
    $widget configure -text $result
}

proc Div {widget} {
    global x y
    set result [expr {$x / $y}]
    $widget configure -text $result
}

button .b1 -text "Sum"  -command [list sum .b1]
button .b2 -text "Diff" -command [list Diff .b2]
button .b3 -text "Mul"  -command [list Mul .b3]
button .b4 -text "Div"  -command [list Div .b4]

grid .b1 -row 0 -column 0
grid .b2 -row 0 -column 1
grid .b3 -row 1 -column 0
grid .b4 -row 1 -column 1
