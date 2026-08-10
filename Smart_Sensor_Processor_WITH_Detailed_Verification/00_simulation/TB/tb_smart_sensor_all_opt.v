
`timescale 1ns/1ps
module tb_smart_sensor_all_opt;
    reg clk=0, rst_n=0, start=0, enable=1, power_on=1, isolate=0;
    reg [7:0] s0=0,s1=0,s2=0,s3=0;
    wire [19:0] result;
    wire valid;
    wire [15:0] monitor_enable;

    smart_sensor_all_opt dut(
        .clk(clk),.rst_n(rst_n),.start(start),.enable(enable),
        .power_on(power_on),.isolate(isolate),
        .s0(s0),.s1(s1),.s2(s2),.s3(s3),
        .result(result),.valid(valid),.monitor_enable(monitor_enable)
    );

    always #5 clk=~clk;

    initial begin
        $dumpfile("activity.vcd");
        $dumpvars(0,tb_smart_sensor_all_opt);
        #20 rst_n=1;
        @(negedge clk);
        s0=8'd10; s1=8'd3; s2=8'd4; s3=8'd2; start=1;
        @(negedge clk); start=0;
        repeat(4) @(negedge clk);
        power_on=0; isolate=1;
        repeat(2) @(negedge clk);
        power_on=1; isolate=0;
        #30 $finish;
    end
endmodule
