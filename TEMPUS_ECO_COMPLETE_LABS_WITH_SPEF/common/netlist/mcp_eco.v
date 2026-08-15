module mcp_eco_top(input clk,input din,output qout);
wire n0,n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,n12;
DFFPOS_X1 U_LAUNCH(.CLK(clk),.D(din),.Q(n0));
BUF_X1 b0(.A(n0),.Y(n1)); BUF_X1 b1(.A(n1),.Y(n2));
BUF_X1 b2(.A(n2),.Y(n3)); BUF_X1 b3(.A(n3),.Y(n4));
BUF_X1 b4(.A(n4),.Y(n5)); BUF_X1 b5(.A(n5),.Y(n6));
BUF_X1 b6(.A(n6),.Y(n7)); BUF_X1 b7(.A(n7),.Y(n8));
BUF_X1 b8(.A(n8),.Y(n9)); BUF_X1 b9(.A(n9),.Y(n10));
BUF_X1 b10(.A(n10),.Y(n11)); BUF_X1 b11(.A(n11),.Y(n12));
DFFPOS_X1 U_CAPTURE(.CLK(clk),.D(n12),.Q(qout));
endmodule
