//Authors: Sebastian Wittka, Tobias Markus
module RAMfifo_tb ();
	
	parameter WIDTH = 32;
	parameter DEPTH = 12;
	parameter PERIOD = 10;
	wire clk;
	reg res_n;
	reg shift_in;
	reg shift_out;
	reg [WIDTH-1:0] wdata;
	wire full;
	wire empty;
	wire [WIDTH-1:0] rdata;
	integer i;
	clk_gen #(.period(PERIOD)) clk_gen_I (.clk_out(clk));
	RAMfifo #(.WIDTH(WIDTH),.DEPTH(DEPTH)) RAMfifo_I (.clk(clk),.res_n(res_n), .shift_in(shift_in),
			.shift_out(shift_out),.wdata(wdata),.full(full),.empty(empty),.rdata(rdata));

	task empty_fifo;
		begin
			while(empty == 0)
			begin
				@(negedge(clk));
				shift_in <= 0;
				shift_out <= 1;
			end
			@(negedge(clk));
			shift_out <= 0;
		end
	endtask

	task fill_fifo;
		input integer wordsToFill;
		begin
		if(wordsToFill > 2**DEPTH)
		begin
			$display("ERROR: You want to fill to many bytes into the FIFO");
			$stop;
		end
			for (i=0;i<wordsToFill;i=i+1) 
			begin
				@(negedge(clk));
			    shift_in <= 1;
			    shift_out <= 0;
			    wdata <= $random;	
			end
		end
	endtask

	initial 
	begin
		res_n <= 0; //is this .res_n a pointer ???
		shift_in <= 0;
		shift_out <= 0;
		#100
		res_n <= 1;
		fill_fifo(1024);
		#50
		empty_fifo();
		$stop;
	end
endmodule