//Authors: Sebastian Wittka, Tobias Markus
module cnt8(clk,res_n,enable,clear,cnt_out);

    input clk;
    input res_n;
    input enable;
    input clear;

    output[7:0] cnt_out;

    reg[7:0] cnt_out;


    always @(posedge clk, negedge res_n)
        begin
            if(res_n == 0)
            begin
                cnt_out <= 0;
            end
            else
            begin
                if(clear == 0)
                begin            
                    if(enable == 1)
                    begin
                        cnt_out <= cnt_out +1;
                    end
                end
                else
                begin
                    cnt_out <= 0;
                end
            end
        end
endmodule
