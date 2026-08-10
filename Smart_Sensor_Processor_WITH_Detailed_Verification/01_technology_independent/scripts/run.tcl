
    # ================================================================
    # TECHNOLOGY-INDEPENDENT SYNTHESIS
    #
    # Run from this category folder:
    #     genus -files scripts/run.tcl
    #
    # IMPORTANT FIX:
    #   Library/search paths are initialized ONCE.
    #   The second case uses reset_design but DOES NOT call read_libs again.
    # ================================================================

    set ROOT [file normalize [file join [file dirname [info script]] ..]]

    file mkdir $ROOT/reports
    file mkdir $ROOT/outputs

    # ------------------------------------------------
    # ONE-TIME session setup
    # ------------------------------------------------
    set_db init_lib_search_path $ROOT/LIB/
    set_db init_hdl_search_path $ROOT/RTL/

    read_libs demo_cmos.lib

    set_db syn_generic_effort medium
    set_db syn_map_effort medium
    set_db syn_opt_effort medium



    proc run_case {ROOT TOP TAG SDC_FILE PRE_SCRIPT POST_SCRIPT} {
        puts ""
        puts "=============================================================="
        puts "STARTING CASE: $TAG"
        puts "TOP          : $TOP"
        puts "SDC          : $SDC_FILE"
        puts "=============================================================="

        # reset_design clears the previous design only.
        # The library remains loaded and is intentionally reused.
        catch {reset_design}

        file mkdir $ROOT/reports/$TAG
        file mkdir $ROOT/outputs/$TAG

        # Use full path so no second init_hdl_search_path is needed.
        read_hdl $ROOT/RTL/smart_sensor_processor.v
        elaborate $TOP
        read_sdc $ROOT/constraints/$SDC_FILE

        if {$PRE_SCRIPT ne ""} {
            uplevel #0 $PRE_SCRIPT
        }

        # ---------------- Generic synthesis ----------------
        syn_generic

        write_hdl -generic > $ROOT/outputs/$TAG/${TOP}_generic.v
        report_area > $ROOT/reports/$TAG/report_area_generic.rpt
        catch {report_gates > $ROOT/reports/$TAG/report_gates_generic.rpt}

        # ---------------- Technology mapping ----------------
        syn_map
        syn_opt

        if {$POST_SCRIPT ne ""} {
            uplevel #0 $POST_SCRIPT
        }

        # ---------------- Final reports ----------------
        report_timing > $ROOT/reports/$TAG/report_timing.rpt
        report_power  > $ROOT/reports/$TAG/report_power.rpt
        report_area   > $ROOT/reports/$TAG/report_area.rpt
        report_qor    > $ROOT/reports/$TAG/report_qor.rpt
        report_gates  > $ROOT/reports/$TAG/report_gates.rpt

        # ---------------- Outputs ----------------
        write_hdl > $ROOT/outputs/$TAG/${TOP}_netlist.v
        write_sdc > $ROOT/outputs/$TAG/${TOP}_sdc.sdc
        write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split \
            > $ROOT/outputs/$TAG/${TOP}_delays.sdf

        puts "COMPLETED CASE: $TAG"
        puts "=============================================================="
    }



    run_case $ROOT smart_sensor_base base base.sdc {} {}

run_case $ROOT smart_sensor_ti_opt optimized optimized.sdc {catch \{ungroup -all -flatten\}} {}

    puts ""
    puts "=============================================================="
    puts "ALL CASES IN THIS CATEGORY COMPLETED"
    puts "=============================================================="
