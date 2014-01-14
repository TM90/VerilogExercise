//Authors: Sebastian Wittka, Tobias Markus
module regb_fifo_tb();

  parameter WIDTH = 16;
  parameter DEPTH = 5;
  parameter PERIOD = 10;
  
  wire clk;
  wire full;
  wire empty;
  wire[WIDTH-1:0] rdata;
  reg counter;
  reg res_n;
  reg shift_in;
  reg[WIDTH-1:0] wdata;
  reg shift_out;
  
  clk_gen #(.period(PERIOD)) clk_gen_I (.clk_out(clk));
  regb_fifo #(.WIDTH(WIDTH), .N(DEPTH)) regb_fifo_I(.clk(clk), .res_n(res_n), .full(full), .shift_in(shift_in),
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

	task shift_fifo;
		begin
			while(counter != 0) 
			begin
				@(negedge(clk));
			    shift_in <= 1;
			    shift_out <= 1;
			    wdata <= $random;
                counter <= counter - 1;	
			end
      @(negedge(clk));
      shift_in <= 0;
      shift_out <= 0;
		end
	endtask

	initial 
	begin
        counter = 3;
		res_n <= 0;
		shift_in <= 0;
		shift_out <= 0;
		#10
		res_n <= 1;
        #10
		full_fifo();
		#10
		empty_fifo();
        #10
        shift_fifo();
		#50
		$stop;
	end

endmodule
