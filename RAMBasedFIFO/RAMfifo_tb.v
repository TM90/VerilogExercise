//Authors: Sebastian Wittka, Tobias Markus
module module_name ();
	
	parameter WIDTH = 32;
	parameter DEPTH = 12;
	parameter PERIOD = 10;
	wire clk;
	reg res_n;
	reg shift_in;
	reg shift_out;
	reg [WIDTH-1:0] wdata;
	wire full;
	wire emtpy;
	wire [WIDTH-1:0] rdata;

	clk_gen #(.period(PERIOD)) clk_gen_I (.clk_out(clk));
	RAMfifo #(.WIDTH(WIDTH),.DEPTH(DEPTH)) RAMfifo_I (.clk(clk),.res_n(res_n), .shift_in(shift_in),
			.shift_out(shift_out),.wdata(wdata),.full(full),.empty(empty),.rdata(rdata));

	task empty_fifo;
		input empty;
		output shift_out;
	begin
		while(empty == 1)
		begin
			@(negedge(clk));
			shift_out <= 1;
		end
		@(negedge(clk));
		shift_out <= 0;
	endtask

	task fill_fifo;
		input wordsToFill;
		output shift_in;
		output wdata;
	begin
		if (wordsToFill>(2**DEPTH)) 
		begin
			$error "You want to fill the FIFO with to many words.\n 
					wordsToFill= %d words\n FIFO_size= %d words\n"	
		end
		else
		begin

			for (i = 0; i < wordsToFill; i = i +1) 
			begin
    	  		@(negedge(clk));
    	  			shift_in <= 1;
    	  			wdata <= $random;
    		end
		end
	endtask

	initial 
	begin
		res_n <= 0;
		shift_in <= 0;
		shift_out <= 0;
		wdata <= 0;
		#100
		res_n <= 1;
		fill_fifo(1024,shift_in,wdata);
		#50
		empty_fifo(empty,shift_out);
		$stop;
	end
endmodule