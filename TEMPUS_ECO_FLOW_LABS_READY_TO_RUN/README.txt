TEMPUS ECO FLOW LABS - ONE STARTING NETLIST
==========================================

First run from package root:
  tempus -files 00_CHECK_TEMPUS_ECO.tcl

Physical timing cases:
  LAB01_SETUP_ECO       : opt_signoff -setup
  LAB01_HOLD_ECO        : opt_signoff -hold
  LAB02_CLOCK_MARGIN_ECO: opt_signoff -setup, uncertainty retained
  LAB04_HALF_CYCLE_ECO  : opt_signoff -setup, half-cycle unchanged
  LAB06_CLOCK_GATING_ECO: opt_signoff -setup on enable path

Architectural exception cases:
  LAB03_MULTICYCLE_EXCEPTION
  LAB05_FALSE_PATH_EXCEPTION

There are NO manually prepared fixed Verilog netlists.

IMPORTANT
---------
Tempus ECO is the signoff ECO/optimization engine. Production physically-aware ECO closure is integrated
with Innovus, which implements, legalizes and routes the changes using real LEF/DEF/parasitic data.
These are compact teaching labs built from Liberty + gate netlist so that the Tempus ECO command flow is
visible. If your installed Tempus does not expose opt_signoff, the ECO license/feature is not available.

The helper attempts a post-ECO logical netlist export only if a compatible writer is exposed by the installed
release. Otherwise use Innovus after ECO implementation to write the final post-ECO netlist.
