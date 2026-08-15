Setup ECO with clock uncertainty retained
=========================================

Necessary inputs are supplied centrally:
  ../common/lib/teaching_eco.lib
  ../common/netlist/*.v
  ../common/spef/*.spef

Main condition kept unchanged:
  same 4.4 ns clock and 0.4 ns setup uncertainty

For automatic ECO runs, START TEMPUS WITH -eco:
  tempus -eco -files 02_run_eco_keep_uncertainty.tcl

The supplied SPEF is a compact teaching parasitic model. For production signoff,
replace it with SPEF generated from your real placed/routed Innovus design.
