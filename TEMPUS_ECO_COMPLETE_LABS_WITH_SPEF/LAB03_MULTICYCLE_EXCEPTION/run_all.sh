#!/bin/bash
set -e
cd "$(dirname "$0")"
echo "===== 01_before_mcp.tcl ====="
tempus -files "01_before_mcp.tcl"
echo "===== 02_apply_valid_mcp.tcl ====="
tempus -files "02_apply_valid_mcp.tcl"
