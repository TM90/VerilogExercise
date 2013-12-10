//Authors: Sebastian Wittka, Tobias Markus
module fifo_tb();
  wire clk;
  wire full;
  wire empty;
  wire[WIDTH-1:0] out;
  reg res_n;
  reg shift_in;
  reg[WIDTH-1:0] in;
  reg shift_out;
  assign WIDTH = 4;
  
  task_tb task_tb();
  clk_gen clk_gen_I(clk);
  fifo (.WIDTH(WIDTH), .N(5)) fifo_I(.clk(clk), .res_n(res_n), .full(full), .shift_in(shift_in),
  (.in(in), .empty(empty), .shift_out(shift_out), .out(out));
endmodule

module task_tb ();
  task task_fifo();
  
  endtask
  begin
    task_fifo();
  end
endmodule
