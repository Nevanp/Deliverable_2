
`timescale 1 ns / 1 ps
module deliverable_2_tb();
         
reg clk, clk25_4;
reg reset;
reg [1:0] clk_count;
//reg [10:0] counter;
reg  [5:0] casecounter;
reg signed [17:0] imp;
reg signed [17:0] x_in;
reg signed [17:0] x_input;
wire signed [17:0] y_out, y_down, y_out_tx,x_up;
initial #10000000 $stop;
initial casecounter = 0;
initial clk <= 1'b1;
initial clk25_4 <= 1;
always #1 clk <=~clk;
wire  [21:0] lfsr_test;
reg  [21:0] checker;
reg  [22:0] counter;
reg flag;
initial flag <= 0;
initial reset = 1'b1;
initial #4 reset = 1'b0;
always @ (posedge clk)
    if (reset)
        counter <= 0;
    else
        counter <= counter +1;

always @ *
    if(flag)
        $stop;

always @ *
if(counter > 2)
    if (checker == 22'h3ffffe)
        flag <= 1;

always @ *
    checker <= lfsr_test;



lfsr SUT_1(
    .clk(clk),
    .reset(reset),
    .y(lfsr_test)
);


endmodule
