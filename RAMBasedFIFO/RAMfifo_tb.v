//Authors: Sebastian Wittka, Tobias Markus
module module_name ();
	
	parameter WIDTH = 32;
	parameter DEPTH = 12;
	wire clk;
	reg res_n;
	reg shift_in;
	reg shift_out;
	reg [WIDTH-1:0] wdata;
	wire full;
	wire emtpy;
	wire [WIDTH-1:0] rdata;

	clk_gen #(.period(10)) clk_gen_I (.clk_out(clk));
	RAMfifo #(.WIDTH(WIDTH),.DEPTH(DEPTH)) RAMfifo_I (.clk(clk),.res_n(res_n), .shift_in(shift_in),
			.shift_out(shift_out),.wdata(wdata),.full(full),.empty(empty),.rdata(rdata));

	initial 
	begin
		
	end
endmodule