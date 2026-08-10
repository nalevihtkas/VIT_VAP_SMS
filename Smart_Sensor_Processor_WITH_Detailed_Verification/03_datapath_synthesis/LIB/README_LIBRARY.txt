This folder already contains the educational libraries required by the lab:

  demo_cmos.lib
  demo_lvt.lib
  demo_rvt.lib
  demo_hvt.lib

The category Tcl script reads demo_cmos.lib for ordinary synthesis. The low-power
multi-Vt runs read demo_lvt.lib, demo_rvt.lib, and demo_hvt.lib.

For real ASIC PPA analysis, replace these educational libraries and update the
read_libs command with your characterized foundry libraries.
