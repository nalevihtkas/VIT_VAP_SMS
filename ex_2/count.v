module count(out, clk, rst);
    output reg [3:0] out;
    input clk, rst;

    initial begin
        out = 4'b0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            out <= 4'b0;
        else
            out <= out + 1;
    end
endmodule