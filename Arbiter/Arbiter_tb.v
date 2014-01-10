//Authors: Sebastian Wittka, Tobias Markus
module Arbiter_tb();

parameter PERIOD = 10;

wire clk;
reg res_n;
reg req0;
reg req1;
reg req2;
wire grant0;
wire grant1;
wire grant2;

clk_gen #(.period(PERIOD)) clk_gen_I (.clk_out(clk));

Arbiter Arbiter_I (.clk(clk),.res_n(res_n),.req0(req0),.req1(req1),.req2(req2)
				,.grant0(grant0),.grant1(grant1),.grant2(grant2));

initial 
begin
	res_n <= 0;
	req0 <= 0;
	req1 <= 0;
	req2 <= 0;
	#100
	res_n <= 1;
	req0 <= 1;
	req1 <= 1;
	req2 <= 1;
	#100
	req0 <= 0;
	req1 <= 1;
	req2 <= 1;
	#100
	req0 <= 1;
	req1 <= 0;
	req2 <= 1;
	#100
	req0 <= 1;
	req1 <= 1;
	req2 <= 0;
	#100
	$stop;

end
endmodule