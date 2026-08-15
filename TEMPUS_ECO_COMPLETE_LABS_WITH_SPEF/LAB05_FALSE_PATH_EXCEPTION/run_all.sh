#!/bin/bash
set -e
cd "$(dirname "$0")"
echo "===== 01_before_false_path.tcl ====="
tempus -files "01_before_false_path.tcl"
echo "===== 02_apply_false_path.tcl ====="
tempus -files "02_apply_false_path.tcl"
