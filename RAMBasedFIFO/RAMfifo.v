//Authors: Sebastian Wittka, Tobias Markus
module RAMfifo
	#(
	    parameter WIDTH = 8, 
	    parameter DEPTH = 9
	)
	(
	    input clk,
	    input res_n,
	    input shift_in,
	    input shift_out,
	    input[WIDTH-1:0] wdata,
	    output full,
	    output empty,
	    output reg[WIDTH-1:0] rdata
	);

	reg[WIDTH-1:0] buffer [0:2**DEPTH-1];
	reg[DEPTH-1:0] RD_addr;
	reg[DEPTH-1:0] WR_addr;
	wire[DEPTH-1:0] distance;

	assign distance = (WR_addr < RD_addr) ? WR_addr+(2**DEPTH-1)-RD_addr : WR_addr-RD_addr;   
	assign full = (distance >= 2**DEPTH-2) ? 1 : 0; // set full signal when WR_addr is max_addr-1     
	assign empty = (distance == 0 && shift_in == 0) ? 1 : 0;

	// control path 
	always @(posedge clk or negedge res_n) 
	begin
		if (res_n == 0) 
		begin
			WR_addr <= {DEPTH{1'b0}};
			RD_addr <= {DEPTH{1'b0}};	
		end
		else 
		begin
			if (shift_in == 1 && full == 0)
			begin
				WR_addr <= WR_addr + 1;
			end 
			if (shift_out == 1 && distance>=1 || shift_in == 1 && shift_out == 1)
			begin
				RD_addr <= RD_addr + 1;
			end	
		end
	end

	integer i;
	// data path 
	always @(posedge clk or negedge res_n)
	begin
		if(res_n == 0)
		begin
			// init buffer on reset with zeros
			for (i=0;i<2**DEPTH;i=i+1) 
			begin
				buffer[i] <= {WIDTH{1'b0}};
			end
		end
		else
		begin
			if(shift_in == 1 && full == 0)
			begin
				buffer[WR_addr] <= wdata;
			end
			if(shift_out == 1 && distance>=1)
			begin
				rdata <= buffer[RD_addr];
			end
			if(shift_out == 1 && shift_in == 1 && distance == 0) // when fifo is empty, data is comming and also wanted 
			begin
				rdata <= wdata;			// the data is streamed through
			end
		end
	end
	
endmodule
