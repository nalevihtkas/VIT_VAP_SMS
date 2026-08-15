module hold_eco_top(input clk,input din,output qout);
wire n0,n1;
DFFPOS_X1 U_LAUNCH(.CLK(clk),.D(din),.Q(n0));
BUF_X1 b0(.A(n0),.Y(n1));
DFFPOS_X1 U_CAPTURE(.CLK(clk),.D(n1),.Q(qout));
endmodule
