#!/bin/bash
set -e
cd "$(dirname "$0")"
echo "===== 01_pre_eco_fail.tcl ====="
tempus -files "01_pre_eco_fail.tcl"
echo "===== 02_run_eco_keep_uncertainty.tcl ====="
tempus -eco -files "02_run_eco_keep_uncertainty.tcl"
