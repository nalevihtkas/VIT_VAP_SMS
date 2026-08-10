# Smart Sensor Processor — FIXED Base + Optimized Runs

This revision fixes two synthesis issues:

1. MAP-2 async-reset mapping:
   demo libraries contain DFFR_X1 and DFFR_X1_{LVT,RVT,HVT}.

2. Base runs but optimized fails:
   the older Tcl called read_libs a second time after reset_design.
   Genus keeps the library/MMMC context after reset_design, therefore the
   second read_libs was illegal. All category run.tcl files now load libraries
   once per Genus session and reuse them for later cases.

## Recommended usage

From a category folder:

    genus -files scripts/verify_library.tcl
    genus -files scripts/run.tcl
    genus -files scripts/check_outputs.tcl

For debugging, technology-independent, technology-dependent and datapath
folders also include separate single-case Tcl scripts.

## Simulation

    cd 00_simulation
    xrun -f scripts/xrun.f

Copy VCD:

    cp activity.vcd ../04_low_power_synthesis/POWER/activity.vcd

## Output validation

Each category has:

    scripts/check_outputs.tcl

which prints explicit PASS/INFO messages instead of relying on a blank grep
result.

## Detailed verification scripts

Each category now includes `scripts/verify_results.tcl`. After running synthesis, execute:

```bash
tclsh scripts/verify_results.tcl
```

To verify all four categories from the master folder:

```bash
cd 05_run_all_together
tclsh scripts/verify_all.tcl
```
