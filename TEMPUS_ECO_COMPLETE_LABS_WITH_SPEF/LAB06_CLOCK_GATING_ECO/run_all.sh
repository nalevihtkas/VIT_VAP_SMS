#!/bin/bash
set -e
cd "$(dirname "$0")"
echo "===== 01_pre_eco_cg_fail.tcl ====="
tempus -files "01_pre_eco_cg_fail.tcl"
echo "===== 02_run_cg_setup_eco.tcl ====="
tempus -eco -files "02_run_cg_setup_eco.tcl"
