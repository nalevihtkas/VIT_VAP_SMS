# Smart Sensor Processor — Self-Contained Genus Template Flow

This project follows the **template style** of the supplied Genus Tcl while
remaining self-contained. It does not require `slow_vdd1v0_basicCells.lib`.
The included educational libraries are used directly:

```tcl
set_db init_lib_search_path ../LIB/
set_db init_hdl_search_path ../RTL/
read_libs demo_cmos.lib

read_hdl smart_sensor_processor.v
elaborate $TOP
read_sdc ../constraints/<file>.sdc

set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium

syn_generic
syn_map
syn_opt
```

Each category also generates timing, power, area, QoR, gate reports, mapped
Verilog, output SDC, and SDF in separate run subfolders.

## Simulation

```bash
cd 00_simulation
xrun -f scripts/xrun.f
cp activity.vcd ../04_low_power_synthesis/POWER/activity.vcd
```

## Run categories separately

```bash
cd 01_technology_independent
genus -files scripts/run.tcl
```

```bash
cd ../02_technology_dependent
genus -files scripts/run.tcl
```

```bash
cd ../03_datapath_synthesis
genus -files scripts/run.tcl
```

```bash
cd ../04_low_power_synthesis
genus -files scripts/run.tcl
```

## Run all categories

```bash
cd ../05_run_all_together
genus -files scripts/run_all.tcl
```

The libraries are educational. Real clock-gating, MBFF, level-shifter,
isolation, retention and power-switch mapping requires corresponding cells in
actual characterized libraries.
