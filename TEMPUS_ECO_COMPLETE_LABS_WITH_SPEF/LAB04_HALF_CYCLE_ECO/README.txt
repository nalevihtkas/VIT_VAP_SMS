Automatic half-cycle setup ECO
==============================

Necessary inputs are supplied centrally:
  ../common/lib/teaching_eco.lib
  ../common/netlist/*.v
  ../common/spef/*.spef

Main condition kept unchanged:
  same 8 ns waveform {0 4}

For automatic ECO runs, START TEMPUS WITH -eco:
  tempus -eco -files 02_run_half_cycle_eco.tcl

The supplied SPEF is a compact teaching parasitic model. For production signoff,
replace it with SPEF generated from your real placed/routed Innovus design.
