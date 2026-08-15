#!/bin/bash
set -e
cd "$(dirname "$0")"
for f in [0-9][0-9]_*.tcl; do echo "===== $f ====="; tempus -files "$f"; done
