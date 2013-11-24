module gearbox_tb();

    wire clk;
    wire full;
    wire valid_out;
    wire[19:0] data_out;
    reg res_n;
    reg shift_in;
    reg shift_out;
    reg[15:0] data_in;

    clk_gen clk_gen_I (.clk_out(clk));
    gearbox gearbox_I (.clk(clk), .full(full), .valid_out(valid_out), .data_out(data_out), .res_n(res_n), .shift_in(shift_in), .shift_out(shift_out), .data_in(data_in));

    initial
    begin
        res_n = 0;
        shift_in = 0;
        shift_out = 0;
        data_in = {16{1'b0}};
    #100
        @(negedge(clk));
        res_n = 1;
        data_in = 16'h4321;
        shift_in = 1;
        shift_out = 1;
    #10
	    @(negedge(clk));
        data_in = 16'h8765;
    #10 // for a defined filling of the buffer
        @(negedge(clk));
        shift_in = 0;
        shift_out = 1;
    #10
        @(negedge(clk));
        shift_in = 0;
        shift_out = 0;
    #100
        $stop;
    end
endmodule
