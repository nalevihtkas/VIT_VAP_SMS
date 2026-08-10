
# ================================================================
# LOW-POWER SYNTHESIS
#
# Run:
#     genus -files scripts/run.tcl
#
# FIX:
# All LVT/RVT/HVT libraries are loaded ONCE.
# No read_libs occurs after reset_design.
# ================================================================

set ROOT [file normalize [file join [file dirname [info script]] ..]]

file mkdir $ROOT/reports
file mkdir $ROOT/outputs

set_db init_lib_search_path $ROOT/LIB/
set_db init_hdl_search_path $ROOT/RTL/

# Load all Vt libraries ONCE.
# RVT is used as the ordinary baseline technology.
read_libs {demo_lvt.lib demo_rvt.lib demo_hvt.lib}

set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium

set LVT_CELLS [get_db lib_cells *LVT*]
set RVT_CELLS [get_db lib_cells *RVT*]
set HVT_CELLS [get_db lib_cells *HVT*]

proc set_vt_policy {MODE} {
    global LVT_CELLS RVT_CELLS HVT_CELLS

    # Clear old policies first.
    catch {set_db $LVT_CELLS .avoid false}
    catch {set_db $RVT_CELLS .avoid false}
    catch {set_db $HVT_CELLS .avoid false}

    if {$MODE eq "RVT_ONLY"} {
        catch {set_db $LVT_CELLS .avoid true}
        catch {set_db $HVT_CELLS .avoid true}
        puts "VT POLICY: RVT only preferred."
    } elseif {$MODE eq "TIMING"} {
        catch {set_db $HVT_CELLS .avoid true}
        puts "VT POLICY: timing oriented (LVT/RVT allowed, HVT avoided)."
    } elseif {$MODE eq "LEAKAGE"} {
        catch {set_db $LVT_CELLS .avoid true}
        puts "VT POLICY: leakage oriented (RVT/HVT allowed, LVT avoided)."
    }
}

proc run_lp_case {ROOT TOP TAG SDC_FILE VT_MODE ENABLE_LP USE_VCD} {
    puts ""
    puts "=============================================================="
    puts "STARTING LOW-POWER CASE: $TAG"
    puts "TOP    : $TOP"
    puts "VT MODE: $VT_MODE"
    puts "=============================================================="

    catch {reset_design}

    file mkdir $ROOT/reports/$TAG
    file mkdir $ROOT/outputs/$TAG

    set_vt_policy $VT_MODE

    # Clock-gating/MBFF controls are enabled only for LP cases.
    if {$ENABLE_LP} {
        if {[catch {set_db lp_insert_clock_gating true} CGMSG]} {
            puts "WARNING: Clock-gating control not accepted: $CGMSG"
        }
        if {[catch {set_db / .map_to_multibit true} MBMSG]} {
            puts "WARNING: MBFF control not accepted: $MBMSG"
        }
    } else {
        catch {set_db lp_insert_clock_gating false}
        catch {set_db / .map_to_multibit false}
    }

    read_hdl $ROOT/RTL/smart_sensor_processor.v
    elaborate $TOP
    read_sdc $ROOT/constraints/$SDC_FILE

    syn_generic
    write_hdl -generic > $ROOT/outputs/$TAG/${TOP}_generic.v
    report_area > $ROOT/reports/$TAG/report_area_generic.rpt
    catch {report_gates > $ROOT/reports/$TAG/report_gates_generic.rpt}

    syn_map
    syn_opt

    # Optional activity annotation before power report.
    set ACTIVITY_STATUS "VECTORLESS"
    if {$USE_VCD} {
        set VCD_FILE $ROOT/POWER/activity.vcd
        if {[file exists $VCD_FILE]} {
            if {[catch {read_vcd $VCD_FILE -scope tb_smart_sensor_all_opt/dut} VMSG]} {
                puts "WARNING: VCD annotation failed: $VMSG"
                set ACTIVITY_STATUS "VCD_FAILED"
            } else {
                puts "VCD activity annotation completed."
                set ACTIVITY_STATUS "VCD_ANNOTATED"
            }
        } else {
            puts "NOTE: $VCD_FILE not found; using vectorless power."
        }
    }

    set fh [open $ROOT/reports/$TAG/activity_status.txt w]
    puts $fh $ACTIVITY_STATUS
    close $fh

    report_timing > $ROOT/reports/$TAG/report_timing.rpt
    report_power  > $ROOT/reports/$TAG/report_power.rpt
    report_area   > $ROOT/reports/$TAG/report_area.rpt
    report_qor    > $ROOT/reports/$TAG/report_qor.rpt
    report_gates  > $ROOT/reports/$TAG/report_gates.rpt
    catch {report clock_gating > $ROOT/reports/$TAG/report_clock_gating.rpt}

    write_hdl > $ROOT/outputs/$TAG/${TOP}_netlist.v
    write_sdc > $ROOT/outputs/$TAG/${TOP}_sdc.sdc
    write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split \
        > $ROOT/outputs/$TAG/${TOP}_delays.sdf

    puts "COMPLETED LOW-POWER CASE: $TAG"
}

# 1. Ordinary baseline using RVT cells only.
run_lp_case $ROOT smart_sensor_datapath_opt base optimized.sdc RVT_ONLY 0 0

# 2. Low-power RTL + clock-gating/MBFF attempt + VCD.
run_lp_case $ROOT smart_sensor_low_power low_power optimized.sdc RVT_ONLY 1 1

# 3. Timing-oriented multi-Vt.
run_lp_case $ROOT smart_sensor_low_power vt_timing optimized.sdc TIMING 1 1

# 4. Leakage-oriented multi-Vt.
run_lp_case $ROOT smart_sensor_low_power vt_leakage optimized.sdc LEAKAGE 1 1

puts ""
puts "=============================================================="
puts "ALL LOW-POWER CASES COMPLETED"
puts "=============================================================="
