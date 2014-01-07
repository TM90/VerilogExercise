//Authors: Sebastian Wittka, Tobias Markus
module Arbiter
	#(
	    parameter WIDTH = 8
	)
    (
        input clk,
	    input res_n,
        input[WIDTH-1:0] input0,
        input[WIDTH-1:0] input1,
        input[WIDTH-1:0] input2,
        input req0,
        input req1,
        input req2,
        output reg grant0,
        output reg grant1,
        output reg grant2
    );
    
    reg[2:0] state_reg;

    always @(posedge clk or negedge res_n) 
	begin
        if(res_n == 0)
        begin
            state_reg <= 3{1'b0};
        end
        else
        begin

        end
    end
endmodule 
