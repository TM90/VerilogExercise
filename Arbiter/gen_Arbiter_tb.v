//Authors: Sebastian Wittka, Tobias Markus
module Arbiter_tb();

parameter PERIOD = 10;

wire clk;
reg res_n;
reg[2:0] req;
wire[2:0] grant;

clk_gen #(.period(PERIOD)) clk_gen_I (.clk_out(clk));

gen_Arbiter gen_Arbiter_I(

    .clk(clk), 
    .res_n(res_n), 
	//-- Inputs
	.req0(req[0]), 
	.req1(req[1]), 
	.req2(req[2]), 

	//-- Outputs
	.grant0(grant[0]), 
	.grant1(grant[1]), 
	.grant2(grant[2])
);

initial 
begin
	res_n <= 0;
	req <= 3'b000;
	#100
	res_n <= 1;
	req <= 3'b111;
	#100
	req <= 3'b110;
	#100
	req <= 3'b100;
	#100
	req <= 3'b001;
	#100
	req <= 3'b010;
	#100
	req <= 3'b110;
	#100
	req <= 3'b011;
	#100
	req <= 3'b101;
	#100
	$stop;

end
endmodule
