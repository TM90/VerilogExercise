//Authors: Sebastian Wittka, Tobias Markus

module regb_fifo_unit
#(
    parameter WIDTH = 8
)
(
    input clk,
    input res_n,
    input[WIDTH-1:0] si,
    input[WIDTH-1:0] so,
    input shift_out,
    input empty_n_reg_next,
    input empty_n_reg_before,
    input shift_in,
    output reg[WIDTH-1:0] out,
    output reg out_empty_n_reg
);
	wire empty, enable;
	reg [1:0] select;
	// f
	assign empty = empty_n_reg_before | (~shift_out & empty_n_reg_next);
	assign enable = (empty_n_reg_before | ~empty_n_reg_next | shift_in | shift_out) &
	(empty_n_reg_before | ~empty_n_reg_next | ~shift_in | ~shift_out);

   // control register
    always @(posedge clk, negedge res_n)
    begin
        if(res_n == 0)
		  begin
		      out_empty_n_reg = 0;
		  end
		  else
		  begin
		     if(enable == 1)
			  begin
			      out_empty_n_reg = empty;
			  end
		  end
    end

    // data multiplexer (g)
	 always @(shift_out,shift_in,out_empty_n_reg,empty_n_reg_before)
	 begin
	     case({shift_in,shift_out})
            2'b00: select <= 2'b00;
				2'b01: select <= 2'b01;
				2'b10:
				begin
					 if(out_empty_n_reg == 1)
					 begin
					     select <= 2'b00;	  
					 end
					 else
					 begin
					     select <= 2'b10;
					 end
		      end
				2'b11:
				begin
				    if(empty_n_reg_before == 1)
					 begin
					     select <= 2'b01;
					 end
					 else
					 begin
					     select <= 2'b10;
				    end
			   end
		  endcase
    end

    // data path 
    always @(posedge clk, negedge res_n)    
    begin
        if(res_n == 0)
        begin
            out <=  {WIDTH{1'b0}};
        end
        else
        begin
            case (select)
                0: out <= out; 
                1: out <= so;
                2: out <= si;
                default: out <= out;
            endcase
        end    
    end

endmodule
