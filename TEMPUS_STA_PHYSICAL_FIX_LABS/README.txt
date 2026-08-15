TEMPUS STA PHYSICAL VIOLATION-FIX LABS

Purpose
-------
These labs separate REAL NETLIST/PATH OPTIMIZATION from TIMING EXCEPTIONS.

Physical optimization demonstrations:
  LAB01A_SETUP_PHYSICAL_FIX
  LAB01B_HOLD_PHYSICAL_FIX
  LAB02_CLOCK_MARGIN_PHYSICAL_FIX
  LAB04_HALF_CYCLE_PHYSICAL_FIX
  LAB06_CLOCK_GATING_PHYSICAL_FIX

Correct timing-exception demonstration:
  LAB05_FALSE_PATH_CORRECT_EXCEPTION

Important:
- FAIL and FIX scripts in the physical labs keep the relevant timing constraint unchanged.
- The FIX changes the netlist/cell implementation.
- BUF_X1 = 0.50 ns, BUF_X2 = 0.25 ns, DLY_X1 = 1.00 ns in the teaching Liberty.
- Run from each lab directory:
      tempus -files 01_....tcl
      tempus -files 02_....tcl
  or:
      ./run_all.sh

This is a teaching package; exact printed slack should be taken from your Tempus report.
