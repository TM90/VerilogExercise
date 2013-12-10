module RAMfifo
	#(
	    parameter WIDTH, 
	    parameter DEPTH
	(
	    input clk,
	    input res_n,
	    input shift_in,
	    input shift_out,
	    input[WIDTH-1:0] wdata,
	    output full,
	    output empty,
	    output reg[WIDTH-1:0]rdata
	);

	reg[WIDTH-1:0] buffer [0:2**DEPTH-1];
	reg[DEPTH-1:0] RD_addr;
	reg[DEPTH-1:0] WR_addr;

	assign distance = (WR_addr < RD_addr) ? WR_addr+(2**DEPTH-1)-RD_addr : WR_addr-RD_addr;   
	assign full = (distance >= 2**DEPTH-2) ? 1 : 0; // set full signal when WR_addr is max_addr-1     

	always @(posedge clk or negedge res_n) 
	begin
		if (res_n == 0) 
		begin
			// reset	
		end
		else 
		begin
			if(shift_in == 1 && full==0)	
		end
	end

endmodule
