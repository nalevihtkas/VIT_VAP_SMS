#!/bin/bash

# ============================================================
# VLSI LAB-1 : UNIX + Verilog + ModelSim Automation
# Single Master Script (Industry Style)
# ============================================================

echo "=============================================="
echo " VLSI LAB-1 : SETUP + SIMULATION START"
echo "=============================================="

BASE=~/vlsi_course/lab1_unix_intro
mkdir -p $BASE/{src,sim,scripts,docs}
cd $BASE || exit 1

echo "[INFO] Directory structure created at:"
pwd
ls

cat > src/adder4.v <<EOF
module adder4 (
    input  [3:0] a,
    input  [3:0] b,
    output [4:0] sum
);
    assign sum = a + b;
endmodule
EOF

cat > src/tb_adder4.v <<EOF
`timescale 1ns/1ps
module tb_adder4;
  reg  [3:0] a, b;
  wire [4:0] sum;

  adder4 dut (.a(a), .b(b), .sum(sum));

  initial begin
    $display("Time   a   b  | sum");
    $display("--------------------");
    a = 0; b = 0; #10; $display("%4t  %d  %d  | %d", $time, a, b, sum);
    a = 5; b = 7; #10; $display("%4t  %d  %d  | %d", $time, a, b, sum);
    a = 9; b = 6; #10; $display("%4t  %d  %d  | %d", $time, a, b, sum);
    $finish;
  end
endmodule
EOF

cat > scripts/run_adder4.do <<EOF
echo "============================================================"
echo " RUNNING TESTCASE : tb_adder4"
echo "============================================================"
vlib work
vlog ../src/adder4.v ../src/tb_adder4.v
vsim -c work.tb_adder4
run -all
quit
EOF

echo "=============================================="
echo " RUNNING MODELSIM / QUESTASIM"
echo "=============================================="

vsim -c -do scripts/run_adder4.do | tee sim/sim.log

echo "=============================================="
echo " SIMULATION COMPLETE"
echo "=============================================="

cat sim/sim.log
