# Compatibility wrapper for users who previously ran 01_normal_setup_fail.tcl.
# The actual LAB01 setup-failure experiment is 01_setup_fail.tcl.
set THIS_DIR [file dirname [file normalize [info script]]]
source [file join $THIS_DIR 01_setup_fail.tcl]
