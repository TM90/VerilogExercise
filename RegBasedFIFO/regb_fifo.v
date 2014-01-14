//Authors: Sebastian Wittka, Tobias Markus

module regb_fifo #(parameter N=5, parameter WIDTH=8)
(input wire clk,
input wire res_n,
input wire[WIDTH-1:0] wdata,
input wire shift_in,
input wire shift_out,
output wire[WIDTH-1:0] rdata,
output wire empty,
output wire full);

wire [WIDTH-1:0] unit_out[N:0], unit_so[N:0];
wire [N:0] unit_empty_n_reg_out, unit_empty_n_reg_before_in, unit_empty_n_reg_next_in;

generate
  genvar i;
  for(i=0; i<N; i=i+1)
    begin: fifo
      regb_fifo_unit #(.WIDTH(WIDTH)) regb_fifo_unit_I(.clk(clk), .res_n(res_n),
		.si(wdata), .so(unit_so[i]), .shift_out(shift_out),
		.empty_n_reg_next(unit_empty_n_reg_next_in[i]),
      .empty_n_reg_before(unit_empty_n_reg_before_in[i]),
		.shift_in(shift_in), .out(unit_out[i]),
      .out_empty_n_reg(unit_empty_n_reg_out[i]));
      assign unit_so[i+1] = unit_out[i];
      assign unit_empty_n_reg_before_in[i+1] = unit_empty_n_reg_out[i];
      assign unit_empty_n_reg_next_in[i] = unit_empty_n_reg_out[i+1];
    end
  
  assign unit_so[0] = {WIDTH{1'b0}};
  assign rdata = unit_out[N-1];
  assign unit_empty_n_reg_before_in[0] = 1'b0;
  assign empty = ~unit_empty_n_reg_out[N-1];
  assign unit_empty_n_reg_next_in[N-1] = 1'b1;
  assign full = unit_empty_n_reg_out[0];

endgenerate

endmodule 