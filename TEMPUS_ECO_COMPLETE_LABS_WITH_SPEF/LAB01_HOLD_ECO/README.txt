Automatic hold ECO
==================

Necessary inputs are supplied centrally:
  ../common/lib/teaching_eco.lib
  ../common/netlist/*.v
  ../common/spef/*.spef

Main condition kept unchanged:
  same 1.6 ns minimum-delay requirement

For automatic ECO runs, START TEMPUS WITH -eco:
  tempus -eco -files 02_run_hold_eco.tcl

The supplied SPEF is a compact teaching parasitic model. For production signoff,
replace it with SPEF generated from your real placed/routed Innovus design.
