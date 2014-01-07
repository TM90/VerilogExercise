module regb_fifo_unit_tb();

  parameter WIDTH = 8;
  parameter PERIOD = 10;
  
  
  wire clk;
  reg res_n;
  reg[WIDTH-1:0] si;
  reg[WIDTH-1:0] so;
  reg shift_out;
  reg empty_n_reg_next;
  reg empty_n_reg_before;
  reg shift_in;
  
  wire[WIDTH-1:0] out;
  wire out_empty_n_reg;

  clk_gen #(.period(PERIOD)) clk_gen_I (.clk_out(clk));
  regb_fifo_unit #(.WIDTH(WIDTH)) regb_fifo_unit_I(.clk(clk), .res_n(res_n), .si(si),
  .so(so), .shift_out(shift_out), .empty_n_reg_next(empty_n_reg_next),
  .empty_n_reg_before(empty_n_reg_before), .shift_in(shift_in), .out(out),
  .out_empty_n_reg(out_empty_n_reg));

	initial 
	begin
		res_n <= 0;
		shift_in <= 0;
		shift_out <= 0;
		si <= 8'b00000001;
		so <= 8'b00010000;
		empty_n_reg_next <= 0;
		empty_n_reg_before <= 0;
		#20
		res_n <= 1;
		@(negedge(clk)); //si lesen
		empty_n_reg_next <= 1;
		shift_in <= 1;
		si <= 8'b00000001;
		so <= 8'b11111111;
		@(negedge(clk)); //ausgabe
		shift_in <= 0;
		shift_out <= 1;
		so <= 8'b00010000;
		si <= 8'b11111111;
		@(negedge(clk)); //hold
		shift_in <= 0;
		shift_out <= 0;
		so <= 8'b11111111;
		si <= 8'b11111111;
		@(negedge(clk)); //out mit so
		empty_n_reg_before <= 1;
		shift_out <= 1;
		so <= 8'b00100000;
		si <= 8'b11111111;
		@(negedge(clk)); //out mit si
		empty_n_reg_before <= 0;
		shift_in <= 1;
		si <= 8'b00000010;
		so <= 8'b11111111;
		@(negedge(clk)); //shift mit so
		empty_n_reg_before <= 1;
		shift_in <= 0;
		si <= 8'b11111111;
		so <= 8'b00110000;
		@(negedge(clk));
		$stop;
	end

endmodule
