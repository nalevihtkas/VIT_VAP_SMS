# 04_low_power_synthesis

## Corrected second-run behavior

`reset_design` is used between designs, but the library is NOT re-read.
This fixes the error:

    Cannot modify library search path after reading library(s)
    Cannot use read_libs after read_mmmc


Run all four low-power cases:
  genus -files scripts/run.tcl
Check outputs:
  genus -files scripts/check_outputs.tcl

The low-power category loads LVT/RVT/HVT libraries ONCE and changes only the
.avoid policy between cases. This avoids the Genus 'Cannot use read_libs after
read_mmmc' error.


## Output folders

Reports and outputs for each case are retained under separate subfolders.

## Detailed automatic verification

After synthesis:

```bash
tclsh scripts/verify_results.tcl
```

The script prints titled subsection checks with PASS/INFO/NOT PROVEN and writes `verification/verification_report.txt`.
