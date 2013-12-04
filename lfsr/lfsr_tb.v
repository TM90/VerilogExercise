//Authors: Sebastian Wittka, Tobias Markus
module lfsr_tb();

  wire clk;
  reg res_n;
  reg enable;
  reg clear;
  wire d_out;

  clk_gen clk_gen_I(.clk_out(clk));
  lfsr #(.num_reg(56), .poly(2**56+2**46+2**23+2**15+2**12+1))  lfsr_I
        (.clk(clk), .res_n(res_n), .enable(enable), .clear(clear), .d_out(d_out));

  initial
  begin
    res_n = 0;
	 enable = 0;
	 clear = 0;
    #100
    res_n = 1;
	 #200
	 enable = 1;
    #500
	 clear = 1;
	 #100 
	 clear = 0;
	 #1000
    $stop;
  end
endmodule
