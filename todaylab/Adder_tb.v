// adder_tb.v

// 4-bit Adder Testbench

// ------------------------------------------------------------------
// Copyright (c) 2006 Susan Lysecky, University of Arizona
// Permission to copy is granted provided that this header remains
// intact. This software is provided with no warranties.
// ------------------------------------------------------------------

`timescale 1ns / 1ps

module Adder_tb();

   reg [3:0] A_t;
   reg [3:0] B_t;
   wire [4:0] Result_t;

   Adder Adder_1(A_t, B_t, Result_t);
   
   initial
   begin

      //case 0
      A_t <= 0; B_t <= 0;
      #1 $display("Result_t = %b", Result_t);

      //case 1
      A_t <= 6; B_t <= 1;
      #1 $display("Result_t = %b", Result_t);

      //case 2
      A_t <= 1; B_t <= 0;
      #1 $display("Result_t = %b", Result_t);

      //case 3 (overflow should occur)
      A_t <= 10; B_t <= 10;
      #1 $display("Result_t = %b", Result_t);

   end
endmodule
