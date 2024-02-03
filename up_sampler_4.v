module up_sampler_4(
    input clk,
	input reset,
	input signed [17:0] x_in,
	output reg signed [17:0] y   
);

reg sampler;
reg [1:0] counter;



always @ *
    case(counter)
    2'b00: sampler <= 1;
    default: sampler <= 0;
    endcase

always @ (posedge clk)
begin
    if (reset)
        counter <= 0;
    else
        counter = counter + 1'b1;
end

always @ (posedge clk)
    case(sampler)
    1'b0: y <= 0;
     1'b1: y <= x_in;
    endcase

endmodule