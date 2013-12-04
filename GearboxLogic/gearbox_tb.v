//Authors: Sebastian Wittka, Tobias Markus
module gearbox_tb();

    wire clk_400;
    wire clk_320;
    wire full;
    wire valid_out;
    wire[19:0] data_out;
    reg res_n;
    reg shift_in;
    reg shift_out;
    reg[15:0] data_in;

    clk_gen #(.period(2.5)) clk_gen_I (.clk_out(clk_400));
    clk_gen #(.period(3.125)) clk_gen_II (.clk_out(clk_320));
    gearbox gearbox_I (.clk_400MHz(clk_400),.clk_320MHz(clk_320), .full(full), .valid_out(valid_out), .data_out(data_out), .res_n(res_n), 
                        .shift_in(shift_in), .shift_out(shift_out), .data_in(data_in));

    initial
    begin
        res_n = 0;
        shift_in = 0;
        shift_out = 0;
        data_in = {16{1'b0}};
    #100
        @(negedge(clk_400));
        res_n = 1;
        data_in = 16'h4321;
        shift_in = 1;
        shift_out = 1;
    #2.5
	    @(negedge(clk_400));
        data_in = 16'h8765;
    #25 // for no filling of the buffer
        @(negedge(clk_400));
        shift_in = 0;
        shift_out = 1;
    #2.5 
        @(negedge(clk_400));
        shift_in = 0;
        shift_out = 0;
    #25 // now just fill the buffer
        @(negedge(clk_400));
        shift_in = 1;
    #75 
        @(negedge(clk_400));
        shift_in = 0;
        shift_out = 1;
    #75
        @(negedge(clk_400));
        shift_out = 0; 
        $stop;
    end
endmodule
