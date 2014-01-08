//Authors: Sebastian Wittka, Tobias Markus
module Arbiter
    (
        input clk,
	    input res_n,
        input req0,
        input req1,
        input req2,
        output wire grant0,
        output wire grant1,
        output wire grant2
    );
    
    reg[2:0] state_reg;
    assign grant0 = state_reg(0);
    assign grant1 = state_reg(1);
    assign grant2 = state_reg(2);

    always @(posedge clk or negedge res_n) 
	begin
        if(res_n == 0)
        begin
            state_reg <= 3{1'b0};
        end
        else
        begin
            case state_reg
                3'b000:
                    if (req0 == 1) 
                    begin
                        state_reg <= 3'b001;
                    end
                    else if (req1 == 1)
                    begin
                        state_reg <= 3'b010;
                    end
                    else if (req2 == 1)
                    begin
                        state_reg <= 3'b100;   
                    end
                3'b001:
                    if (req0 == 0 && req1 == 0 && req2 == 0) 
                    begin
                        state_reg <= 3'b000;
                    end
                    if (req0 == 1)
                    begin
                        state_reg <= 3'b001;
                    end
                    else if (req1 == 1)
                    begin
                        state_reg <= 3'b010;    
                    end
                    else if (req2 == 1)
                    begin
                        state_reg <= 3'b100;
                    end
                3'b010:
                    if (req0 == 0 && req1 == 0 && req2 == 0) 
                    begin
                        state_reg <= 3'b000;
                    end
                    if (req0 == 1)
                    begin
                        state_reg <= 3'b001;
                    end
                    else if (req1 == 1)
                    begin
                        state_reg <= 3'b010;    
                    end
                    else if (req2 == 1)
                    begin
                        state_reg <= 3'b100;
                    end
                3'b100:
                    if (req0 == 0 && req1 == 0 && req2 == 0) 
                    begin
                        state_reg <= 3'b000;
                    end
                    if (req0 == 1)
                    begin
                        state_reg <= 3'b001;
                    end
                    else if (req1 == 1)
                    begin
                        state_reg <= 3'b010;    
                    end
                    else if (req2 == 1)
                    begin
                        state_reg <= 3'b100;
                    end
                default: 
                    state_reg <= 3'b000;
            endcase
        end
    end
endmodule 
