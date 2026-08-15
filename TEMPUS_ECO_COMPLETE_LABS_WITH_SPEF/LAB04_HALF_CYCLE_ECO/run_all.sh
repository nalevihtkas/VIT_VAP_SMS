#!/bin/bash
set -e
cd "$(dirname "$0")"
echo "===== 01_pre_eco_half_fail.tcl ====="
tempus -files "01_pre_eco_half_fail.tcl"
echo "===== 02_run_half_cycle_eco.tcl ====="
tempus -eco -files "02_run_half_cycle_eco.tcl"
