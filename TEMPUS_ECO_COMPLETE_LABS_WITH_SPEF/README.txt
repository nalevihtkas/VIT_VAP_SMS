TEMPUS ECO COMPLETE LAB PACKAGE WITH RC/SPEF
===========================================

WHY THIS PACKAGE EXISTS
-----------------------
Your Tempus reported:
  eco_opt_design cannot proceed since RC data is missing.

This package therefore adds a SPEF file for every design and loads it BEFORE
eco_opt_design. It also uses the command family visible in your Tempus:
  eco_opt_design -setup
  eco_opt_design -hold

AUTOMATIC ECO LABS
------------------
LAB01_SETUP_ECO
LAB01_HOLD_ECO
LAB02_CLOCK_MARGIN_ECO
LAB04_HALF_CYCLE_ECO
LAB06_CLOCK_GATING_ECO

ARCHITECTURAL EXCEPTION LABS
----------------------------
LAB03_MULTICYCLE_EXCEPTION
LAB05_FALSE_PATH_EXCEPTION

FIRST TEST
----------
Run:
  tempus -files 00_CHECK_ENVIRONMENT.tcl

For an ECO script, always launch:
  tempus -eco -files <eco_script.tcl>

WHAT IS NOW INCLUDED
--------------------
1. Liberty timing library
2. One original gate-level netlist per design
3. SPEF parasitic file per design
4. Tempus scripts that read the SPEF
5. -eco launch scripts
6. setup/hold/uncertainty/MCP/half-cycle/false-path/clock-gating cases
7. ECO database/change dump attempts where supported

IMPORTANT LIMIT
---------------
The included SPEF is an educational RC model, not extracted from a real layout.
It is intended to remove the exact 'RC data is missing' blocker and let you
exercise the Tempus ECO command path in a compact lab.

For a real physically-aware signoff ECO:
  Genus/netlist -> Innovus place/route -> extractRC -> rcOut -spef ->
  Tempus -eco -> eco_opt_design -> Innovus implement/legalize/route ECO ->
  new SPEF/netlist -> Tempus recheck.

If Tempus now reports a different ECO prerequisite after SPEF is loaded,
send that exact message; it will identify the next environment-specific
requirement (for example physical DB/placement information).
