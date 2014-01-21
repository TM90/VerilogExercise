/**
 reg fsm_req0;
reg fsm_req1;
reg fsm_req2;

wire fsm_grant0;
wire fsm_grant1;
wire fsm_grant2;

fsm_1 fsm_1_I (

    .clk(), 
    .res_n(), 
	//-- Inputs
	.req0(fsm_req0), 
	.req1(fsm_req1), 
	.req2(fsm_req2), 

	//-- Outputs
	.grant0(fsm_grant0), 
	.grant1(fsm_grant1), 
	.grant2(fsm_grant2)
);

 */
module fsm_1 ( 
    input wire clk, 
    input wire res_n, 

    // Inputs
    //------------ 
    input wire req0, 
    input wire req1, 
    input wire req2, 

    // Outputs
    //------------ 
    output wire grant0, 
    output wire grant1, 
    output wire grant2
 );

localparam IDLE = 3'b000;
localparam state0 = 3'b100;
localparam state1 = 3'b010;
localparam state2 = 3'b001;

reg [2:0] current_state, next_state;
assign {grant0, grant1, grant2} = current_state;

wire [2:0] inputvector;
assign inputvector = {req0, req1, req2};


always @(*) begin
  casex({inputvector, current_state})
    {3'b000, IDLE},
    {3'b011, IDLE}:   next_state = IDLE;
    {3'b1xx, IDLE}:   next_state = state0;
    {3'b001, IDLE}:   next_state = state2;
    {3'b010, IDLE}:   next_state = state1;
    {3'b100, state0},
    {3'b10x, state0},
    {3'b1xx, state0}:   next_state = state0;
    {3'b01x, state0}:   next_state = state1;
    {3'b001, state0}:   next_state = state2;
    {3'b000, state0}:   next_state = IDLE;
    {3'bx01, state1}:   next_state = state2;
    {3'b100, state1}:   next_state = state0;
    {3'b000, state1}:   next_state = IDLE;
    {3'bx1x, state1}:   next_state = state1;
    {3'b110, state2},
