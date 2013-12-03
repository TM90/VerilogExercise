// Author: Sebastian Wittka, Tobias Markus
module fifo_unit
#(
    parameter WIDTH = 4
)
(
    input clk,
    input res_n,
    input si,
    input so,
    input empty,
    input shift_out,
    input empty_reg,
    input shift_in,
    output out,
    output out_empty_reg,
    output out_empty
    
);
