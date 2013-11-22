module ser_64_16_tb();

    wire clk;
    reg res_n;
    reg valid_in;
    reg stop_in;
    reg[63:0] data_in;
    wire valid_out;
    wire stop_out;
    wire[15:0] data_out;

    clk_gen clk_gen_I(clk);
    ser_64_16 ser_64_16_I(
        .clk(clk),
        .res_n(res_n),
        .valid_in(valid_in),
        .data_in(data_in),
        .stop_in(stop_in),
        .stop_out(stop_out),
        .valid_out(valid_out),
        .data_out(data_out)
    );
    
    initial
    begin
        res_n = 0;
        valid_in = 0;
        stop_in = 0;
        data_in = 64'h0807060504030201;        
        #300 
        res_n = 1;
        #350
	@(negedge(clk));
        valid_in = 1;
        #20
	@(negedge(clk));
        stop_in = 1;
        #20
	@(negedge(clk));
        stop_in = 0;
        #200
        $stop;
    end

endmodule
