button .b1 -text "And2Module" \
        -command "exec perl and.pl and in1 in2 y "
button .b2 -text "And2Module_tb" \
    -command "exec perl testbench.pl and "
button .b3 -text "Or2Module" \
    -command "exec perl or.pl or in1 in2 y "
button .b4 -text "Or2Module_tb" \
    -command "exec perl testbench.pl or"


# Put them in the window in row order
grid .b1 -row 0 -column 0
grid .b2 -row 0 -column 1
grid .b3 -row 1 -column 0
grid .b4 -row 1 -column 1
