
`timescale 1 ns / 1 ps
module deliverable_2_tb();
         
reg clk, clk_smp,clk_sym;
reg [3:0] clk_phase;
reg reset;
reg [1:0] clk_count;
//reg [10:0] counter;
reg  [5:0] casecounter;
reg signed [17:0] imp;
reg signed [17:0] x_in;
reg signed [17:0] x_input;
wire signed [17:0] y_out, y_down, y_out_tx,x_up;
initial #100000 $stop;
initial casecounter = 0;
initial clk <= 1'b1;
initial clk_smp <= 1;
initial clk_sym <= 1;
always #80 clk <=~clk;
wire  [21:0] lfsr_test;
reg  [21:0] checker;
reg  [22:0] counter;
reg flag;
initial flag <= 0;
initial reset = 1'b1;
initial #80 reset = 1'b0;
always @ (posedge clk)
    if (reset)
        counter <= 0;
    else
        counter <= counter +1;


always @ *
case(clk_phase[1:0])
2'b11: clk_smp <= 1'b1;
default: clk_smp <= 1'b0;
endcase

always @ *
case(clk_phase)
4'b1111: clk_sym <= 1'b1;
default: clk_sym <= 1'b0;
endcase


always @ (posedge clk)
if(reset)
clk_phase <= 0;
else
clk_phase <= clk_phase +1;

always @ (*)
if (clk_smp)
case(lfsr_test[1:0])
2'b00: x_in <= -18'sd131072;
2'b01: x_in <= -18'sd43691;
2'b10: x_in <= 18'sd43690;
2'b11: x_in <= 18'sd131071;
endcase


always @ (posedge clk)
	if (reset)
	x_input <= 0;
	else if (clk_smp)
	x_input <= x_in;


// LFSR CHECKER (SWITCH CLK TO #1 and #1000000 TIME)
// always @ *
//     if(flag)
//         $stop;

// always @ *
// if(counter > 2)
//     if (checker == 22'h3ffffe)
//         flag <= 1;

// always @ *
//     checker <= lfsr_test;



 /* *************************************
     INSTANTIATION SECTION                                          
    ************************************* */
up_sampler_4 UP(
	.clk(clk),
	.reset(reset),
	.x_in(x_input),
	.y(x_up)
);

 tx_filter_nomult SUT_1(
	.clk(clk),
	.reset(reset),
	.x_in(x_up),
	.y(y_out_tx)
	);
rx_filter SUT_2(.clk(clk),
	.reset(reset),
	.x_in(y_out_tx),
	.y(y_out));

down_sampler_4 DOWN(
	.clk(clk),
    .clk_en(clk_smp),
	.reset(reset),
	.x_in(y_out),
	.y(y_down)
);

lfsr SUT_3(
    .clk(clk),
    .clk_en(clk_smp),
    .reset(reset),
    .y(lfsr_test)
);


endmodule
