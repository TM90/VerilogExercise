module cntn#(
	parameter n=10)
	(input clk,
	input res_n,
	input enable,
	input clear,
	output reg[n-1:0] cnt_out);

    always @(posedge clk, negedge res_n)
        begin
            if(res_n == 0)
            begin
                cnt_out <= {n{1'b0}};
            end
            else
            begin
                if(clear == 0)
                begin            
                    if(enable == 1)
                    begin
                        cnt_out <= cnt_out +{{(n-1){1'b0}},1'b1};
                    end
                end
                else
                begin
                    cnt_out <= 0;
                end
            end
        end
endmodule
