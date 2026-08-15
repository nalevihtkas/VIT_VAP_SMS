TEMPUS ECO LABS - UPDATED FOR THE COMMANDS VISIBLE IN YOUR TEMPUS
================================================================

Your Tempus does not expose opt_signoff, but your command listing shows:
  eco_opt_design
  set_eco_opt_mode
  get_eco_opt_mode
  ecoAddRepeater
  ecoChangeCell
  ecoDeleteRepeater
  write_eco
  write_eco_opt_db
  read_eco_opt_db

Therefore this package uses the eco_opt_design command family.

FIRST RUN
---------
  tempus -files 00_CHECK_TEMPUS_ECO.tcl

The script prints the exact built-in help from YOUR installation.

AUTOMATIC ECO LABS
------------------
LAB01_SETUP_ECO
  report_timing -late
  eco_opt_design -setup
  report_timing -late

LAB01_HOLD_ECO
  report_timing -early
  eco_opt_design -hold
  report_timing -early

LAB02_CLOCK_MARGIN_ECO
  keeps the clock and setup uncertainty unchanged;
  eco_opt_design -setup is used on the data path.

LAB04_HALF_CYCLE_ECO
  keeps the 8 ns {0 4} clock unchanged;
  eco_opt_design -setup is used.

LAB06_CLOCK_GATING_ECO
  keeps the clock and ICG library timing check unchanged;
  eco_opt_design -setup is used on the enable path.

ARCHITECTURAL EXCEPTION LABS
----------------------------
LAB03_MULTICYCLE_EXCEPTION
  Correct solution is a justified MCP; this is not a cell ECO.

LAB05_FALSE_PATH_EXCEPTION
  Correct solution is a justified false-path exception; this is not a cell ECO.

IMPORTANT
---------
The scripts have error handling. If your exact Tempus build uses an option spelling
different from -setup or -hold, the script prints 'help eco_opt_design' automatically.
There are NO manually prepared fixed.v netlists.

A production physical ECO remains a Tempus + Innovus flow for placement,
legalization, routing and final post-ECO netlist generation.
