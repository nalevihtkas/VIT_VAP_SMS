# 03_datapath_synthesis

## Corrected second-run behavior

`reset_design` is used between designs, but the library is NOT re-read.
This fixes the error:

    Cannot modify library search path after reading library(s)
    Cannot use read_libs after read_mmmc


Run both:
  genus -files scripts/run.tcl
Run separately:
  genus -files scripts/run_base.tcl
  genus -files scripts/run_optimized.tcl
Check outputs:
  genus -files scripts/check_outputs.tcl


## Output folders

Reports and outputs for each case are retained under separate subfolders.

## Detailed automatic verification

After synthesis:

```bash
tclsh scripts/verify_results.tcl
```

The script prints titled subsection checks with PASS/INFO/NOT PROVEN and writes `verification/verification_report.txt`.
