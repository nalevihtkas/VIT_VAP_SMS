module cg_physical(input clk,input en_src,input din,output qout);
 wire e0,e1,e2,e3,e4,gclk;
 DFFPOS_X1 U_EN_SRC(.CLK(clk),.D(en_src),.Q(e0));
 // Physical optimization of enable-generation path.
 BUF_X2 eb0(.A(e0),.Y(e1)); BUF_X2 eb1(.A(e1),.Y(e2));
 BUF_X2 eb2(.A(e2),.Y(e3)); BUF_X2 eb3(.A(e3),.Y(e4));
 ICG_X1 U_ICG(.CLK(clk),.EN(e4),.GCLK(gclk));
 DFFPOS_X1 U_GATED_FF(.CLK(gclk),.D(din),.Q(qout));
endmodule
