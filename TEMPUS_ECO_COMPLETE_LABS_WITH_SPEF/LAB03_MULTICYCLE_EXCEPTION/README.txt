Architectural MCP exception
===========================

Necessary inputs are supplied centrally:
  ../common/lib/teaching_eco.lib
  ../common/netlist/*.v
  ../common/spef/*.spef

Main condition kept unchanged:
  2-cycle setup, 1-cycle hold

For automatic ECO runs, START TEMPUS WITH -eco:
  tempus -eco -files 02_apply_valid_mcp.tcl

The supplied SPEF is a compact teaching parasitic model. For production signoff,
replace it with SPEF generated from your real placed/routed Innovus design.
