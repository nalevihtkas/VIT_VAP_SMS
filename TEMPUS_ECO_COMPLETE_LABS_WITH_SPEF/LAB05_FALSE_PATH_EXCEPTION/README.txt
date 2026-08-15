Architectural false-path exception
==================================

Necessary inputs are supplied centrally:
  ../common/lib/teaching_eco.lib
  ../common/netlist/*.v
  ../common/spef/*.spef

Main condition kept unchanged:
  justified set_false_path

For automatic ECO runs, START TEMPUS WITH -eco:
  tempus -eco -files 02_apply_false_path.tcl

The supplied SPEF is a compact teaching parasitic model. For production signoff,
replace it with SPEF generated from your real placed/routed Innovus design.
