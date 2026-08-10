# Why only the base case ran

Observed Genus message:

    Cannot modify library search path after reading library(s)
    Cannot use read_libs after read_mmmc

The original flow was:

    read_libs
    synthesize base
    reset_design
    set_db init_lib_search_path ...
    read_libs       <-- illegal second library/MMMC load

`reset_design` removes the current design but does not unload the library/MMMC
environment.

Corrected flow:

    set_db init_lib_search_path ...
    set_db init_hdl_search_path ...
    read_libs ...                   <-- ONCE

    read/elaborate/synthesize base
    reset_design
    read/elaborate/synthesize optimized

No library path or read_libs command is repeated.
