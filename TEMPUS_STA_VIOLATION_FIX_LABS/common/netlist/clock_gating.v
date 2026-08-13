module clock_gating_top(input clk, input en, input din, output qout);
  wire gclk;
  ICG_X1 U_ICG (.CLK(clk), .EN(en), .GCLK(gclk));
  DFFPOS_X1 U_GATED_FF (.CLK(gclk), .D(din), .Q(qout));
endmodule
