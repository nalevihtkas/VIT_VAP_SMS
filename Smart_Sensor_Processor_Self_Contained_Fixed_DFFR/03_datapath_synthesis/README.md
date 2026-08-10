# Corrected run procedure

From `03_datapath_synthesis`:

```bash
genus -files scripts/verify_library.tcl
genus -files scripts/run.tcl
```

The first command verifies that `DFFR_X1` is recognized before synthesis.

# 03_datapath_synthesis

1. Copy demo_cmos.lib into LIB/.
2. Run from this folder:

```bash
genus -files scripts/run.tcl
```

Outputs are in reports/<run>/ and outputs/<run>/.
