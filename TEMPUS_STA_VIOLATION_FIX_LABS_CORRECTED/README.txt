TEMPUS STA VIOLATION & FIXING LABS
==================================

Purpose
-------
Standalone educational STA package for:
1. Setup / Hold
2. Clock skew / uncertainty effects
3. Multicycle setup + companion hold
4. Half-cycle paths
5. False paths
6. Clock-gating setup/hold checks

IMPORTANT
---------
This is an EDUCATIONAL, SELF-CONTAINED Liberty/netlist package.
The .lib uses deliberately simple constant timing numbers so that the reports
are easy to interpret. It is NOT a foundry/signoff library.

Tempus command syntax varies slightly by release. These scripts use the common
Tempus-style read_lib/read_verilog/set_top_module/report_timing flow. If your
site's release requires init_design/MMMC, use the same netlist, library, and
constraints with your site's standard initialization wrapper.

RUN
---
Open a terminal in a lab folder, for example:

  cd TEMPUS_STA_VIOLATION_FIX_LABS/LAB03_MULTICYCLE
  tempus -files 01_normal_setup_fail.tcl
  tempus -files 02_mcp_setup_pass.tcl
  tempus -files 03_mcp_setup_hold_correct.tcl

Or interactively:
  tempus
  source 01_normal_setup_fail.tcl

LAB ORDER
---------
LAB01_SETUP_HOLD
  01_setup_fail.tcl
  02_setup_fixed.tcl
  03_hold_fail.tcl
  04_hold_fixed.tcl

LAB02_CLOCK_SKEW
  01_setup_negative_skew_fail.tcl
  02_setup_skew_fixed.tcl
  03_hold_positive_skew_fail.tcl
  04_hold_skew_fixed.tcl

LAB03_MULTICYCLE
  01_normal_setup_fail.tcl
  02_mcp_setup_pass.tcl
  03_mcp_setup_hold_correct.tcl
  04_mcp_setup_still_fail.tcl
  05_mcp_setup_fixed_by_valid_3cycle.tcl

LAB04_HALF_CYCLE
  01_half_setup_fail.tcl
  02_half_setup_fixed.tcl
  03_half_hold_check.tcl

LAB05_FALSE_PATH
  01_before_false_path.tcl
  02_after_false_path.tcl

LAB06_CLOCK_GATING
  01_cg_setup_pass.tcl
  02_cg_setup_fail.tcl
  03_cg_setup_fixed.tcl
  04_cg_hold_check.tcl

WHAT TO RECORD
--------------
For every report, record:
- Startpoint
- Endpoint
- Launch edge
- Capture/check edge
- Data arrival time
- Required time
- Slack
- PASS / FAIL
- Cause
- Fix
- Slack after fix

CORE EQUATIONS
--------------
Setup:
  Slack = Tclk + Skew - Tsetup - Tpath(max)

Hold:
  Slack = Tpath(min) - Thold - Skew

N-cycle MCP setup:
  Slack = N*Tclk + Skew - Tsetup - Tpath(max)

Common same-clock MCP:
  setup MCP = N
  hold MCP  = N-1

Ideal 50% half-cycle setup:
  Slack = Tclk/2 + Skew - Tsetup - Tpath(max)

False path:
  No normal setup/hold calculation after a justified exception.

Clock-gating setup:
  Slack = Tcheck - Tcg_setup - TEN_arrival

Clock-gating hold:
  Slack = TEN_change - Tcheck - Tcg_hold

FIXING RULE
-----------
Setup FAIL -> data too late -> reduce MAX delay / validly increase time.
Hold  FAIL -> data too early -> increase MIN delay / reduce harmful skew.

NOTE ON "FIX" CASES
-------------------
Some labs demonstrate a real architectural/constraint correction (MCP, false
path). Others use a changed clock/min-delay requirement to make the timing
principle visible in a pure Tempus exercise. In a production ASIC, physical
fixes such as sizing, buffering, placement, routing, and CTS are normally
implemented in Genus/Innovus and re-verified in Tempus.

CORRECTED PACKAGE NOTE
----------------------
This corrected edition fixes LAB01 launch/path issues:
- LAB01's real first script is 01_setup_fail.tcl.
- A compatibility wrapper 01_normal_setup_fail.tcl is included.
- All lab Tcl files now source common.tcl using the Tcl script location rather
  than assuming a particular shell working directory.
- common.tcl also resolves library/netlist paths from its own location.
- LAB01 includes run_lab01.sh and RUN_INSTRUCTIONS.txt.
