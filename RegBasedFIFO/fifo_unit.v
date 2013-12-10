//Authors: Sebastian Wittka, Tobias Markus
module fifo_unit
#(
    parameter WIDTH = 4
)
(
    input clk,
    input res_n,
    input[WIDTH-1:0] si,
    input[WIDTH-1:0] so,
    input empty_n_before,
    input shift_out,
    input empty_n_reg_next,
    input empty_n_reg_before,
    input shift_in,
    output reg[WIDTH-1:0] out,
    output reg out_empty_n_reg,
	 output wire out_empty_n
);
    // control multiplexer (f)
    always @(shift_out,shift_in,out_empty_n_reg_next,empty_n_reg_before)
    begin
        case ({shift_out,shift_in,out_empty_reg_next,empty_reg_before})
            0: empty_n;
        endcase
    end
	 
    // control register
    always @(posedge clk, negedge res_n)
    begin
        
    end

    // data multiplexer (g)
	 always @()
	 begin
	     case({})
		  
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
                1: out <= si;
                2: out <= so;
                default: out <= out;
            endcase
        end    
    end

endmodule
