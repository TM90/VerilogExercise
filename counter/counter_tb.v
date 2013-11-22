module counter_tb();

    wire clk;
    wire[9:0] cnt_out;
    reg res_n;
    reg enable;
    reg clear;

    clk_gen clk_gen_I(clk);
    cntn #(.n(10)) cntn_I
                (.clk(clk),
                .res_n(res_n),
                .enable(enable),
                .clear(clear),
                .cnt_out(cnt_out));
    
    initial
    begin
        res_n = 0;
        clear = 0;
        enable = 1;
        #100 
        res_n = 1;
        #1000
        enable = 0;
        #100
        clear = 1;
        #100
        clear = 0;
        #2000
        enable = 1;
        #3000
        $stop;
    end

endmodule
