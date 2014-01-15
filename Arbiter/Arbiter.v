//Authors: Sebastian Wittka, Tobias Markus
module Arbiter
    (
        input clk,
	    input res_n,
        input wire[2:0] req,
        output wire[2:0] grant
    );
    
    reg[2:0] state_reg;
    assign grant = state_reg;

    always @(posedge clk or negedge res_n) 
	begin
        if(res_n == 0)
        begin
            state_reg  <= {3{1'b0}};
        end
        else
        begin
            casex({state_reg, req})
                // state 000
                6'b000xx1:
                    state_reg <= 3'b001;
                6'b000x10:
                    state_reg <= 3'b010;
                6'b000100:
                    state_reg <= 3'b100;
                // state 001    
                6'b001000:
                    state_reg <= 3'b000;
                6'b001x10:
                    state_reg <= 3'b010;
                6'b001100:
                    state_reg <= 3'b100;
                // state 010    
                6'b010000:
                    state_reg <= 3'b000;
                6'b010001:
                    state_reg <= 3'b001;
                6'b01010x:
                    state_reg <= 3'b100;
                // state 100
                6'b100000:
                    state_reg <= 3'b000;
                6'b1000x1:
                    state_reg <= 3'b001;
                6'b100010:
                    state_reg <= 3'b010;
                // the rest
                default:
                    state_reg <= state_reg;
            endcase
        end
    end
endmodule