// adder.v

// 4-bit Adder

// ------------------------------------------------------------------
// Copyright (c) 2006 Susan Lysecky, University of Arizona
// Permission to copy is granted provided that this header remains
// intact. This software is provided with no warranties.
// ------------------------------------------------------------------

`timescale 1ns / 1ps

module Adder(A, B, Result);

   input [3:0] A;
   input [3:0] B;
   output [4:0] Result;
   reg [4:0] Result;

   always @ (A or B)
   begin
   
      Result <= A + B;
   end

endmodule
