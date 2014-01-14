//Authors: Sebastian Wittka, Tobias Markus
module Arbiter_tb();

parameter PERIOD = 10;

wire clk;
reg res_n;
reg[2:0] req;
wire[2:0] grant;

clk_gen #(.period(PERIOD)) clk_gen_I (.clk_out(clk));

Arbiter Arbiter_I (.clk(clk),.res_n(res_n),.req(req)
				,.grant(grant));

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
	$stop;

end
endmodule