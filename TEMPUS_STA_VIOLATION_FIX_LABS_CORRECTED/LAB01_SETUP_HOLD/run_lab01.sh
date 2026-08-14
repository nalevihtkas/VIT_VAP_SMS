#!/bin/bash
set -e
cd "$(dirname "$0")"
echo "Running LAB01 setup FAIL..."
tempus -files 01_setup_fail.tcl
echo "Running LAB01 setup FIXED..."
tempus -files 02_setup_fixed.tcl
echo "Running LAB01 hold FAIL..."
tempus -files 03_hold_fail.tcl
echo "Running LAB01 hold FIXED..."
tempus -files 04_hold_fixed.tcl
