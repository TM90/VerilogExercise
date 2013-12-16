//Authors: Sebastian Wittka, Tobias Markus
module fifo_tb();

  parameter WIDTH = 8;
  parameter DEPTH = 5;
  parameter PERIOD = 10;
  
  wire clk;
  wire full;
  wire empty;
  wire[WIDTH-1:0] rdata;
  reg res_n;
  reg shift_in;
  reg[WIDTH-1:0] wdata;
  reg shift_out;
  
  clk_gen #(.period(PERIOD)) clk_gen_I (.clk_out(clk));
  fifo #(.WIDTH(WIDTH), .N(DEPTH)) fifo_I(.clk(clk), .res_n(res_n), .full(full), .shift_in(shift_in),
  .wdata(wdata), .empty(empty), .shift_out(shift_out), .rdata(rdata));

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

	task full_fifo;
		begin
			while(full == 0) 
			begin
				@(negedge(clk));
			    shift_in <= 1;
			    shift_out <= 0;
			    wdata <= $random;	
			end
      @(negedge(clk));
      shift_in <= 0;
		end
	endtask

	initial 
	begin
		res_n <= 0;
		shift_in <= 0;
		shift_out <= 0;
		#100
		res_n <= 1;
		full_fifo();
		#50
		empty_fifo();
		$stop;
	end

endmodule
