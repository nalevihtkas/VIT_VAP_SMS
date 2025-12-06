`timescale 1ns/1ps
// Testbench for adder_8bit
module adder_8bit_tb;
    reg  [8-1:0] a;
    reg  [8-1:0] b;
    reg             inbin;
    wire [8-1:0] out;
    wire            bout_or_cout;

    adder_8bit dut (
        .a(a),
        .b(b),
        .bin(inbin),
        .diff(out),
        .bout(bout_or_cout)
    );

    reg [8:0] expected;
    integer i;
    integer errors;

    initial begin
        errors = 0;
        $dumpfile("adder_8bit.vcd");
        $dumpvars(0, adder_8bit_tb);
        for (i = 0; i < 200; i = i + 1) begin
            a = $random; b = $random; inbin = $random & 1; #5;
            expected = a + b + inbin; #5;
            if ({bout_or_cout,out} !== expected) errors = errors + 1;
        end
        if (errors == 0) $display("All tests passed for adder_8bit (N=8, mode=add)!");
        else $display("TEST FINISHED: %0d mismatches detected.", errors);
        #10; $finish;
    end
endmodule
