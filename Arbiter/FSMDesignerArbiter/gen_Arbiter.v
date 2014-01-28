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
module gen_Arbiter ( 
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
    {3'b000, state2}:   next_state = IDLE;
    {3'b1x0, state2}:   next_state = state0;
    {3'b010, state2}:   next_state = state1;
    {3'bxx1, state2}:   next_state = state2;
    default:  next_state = IDLE;
  endcase
end

`ifdef ASYNC_RES
 always @(posedge clk or negedge res_n ) begin
`else
 always @(posedge clk) begin
`endif
    if (!res_n)
    begin
        current_state <= IDLE;
    end
    else begin
        current_state <= next_state;
    end
end

`ifdef CAG_COVERAGE
// synopsys translate_off

	// State coverage
	//--------

	//-- Coverage group declaration
	covergroup cg_states @(posedge clk);
		states : coverpoint current_state {
			bins IDLE = {IDLE};
			bins state0 = {state0};
			bins state1 = {state1};
			bins state2 = {state2};
		}
	endgroup : cg_states

	//-- Coverage group instanciation
	cg_states state_cov_I;
	initial begin
		state_cov_I = new();
		state_cov_I.set_inst_name("state_cov_I");
	end

	// Transitions coverage
	//--------

	tc_trans_1_req0: cover property( @(posedge clk) disable iff (!res_n)(inputvector ==? 3'b1xx) &&(current_state == IDLE)|=> (current_state == state0));

	tc_trans_2_req0: cover property( @(posedge clk) disable iff (!res_n)(inputvector ==? 3'b01x) &&(current_state == state0)|=> (current_state == state1));

	tc_trans_3_req1: cover property( @(posedge clk) disable iff (!res_n)(inputvector ==? 3'bx01) &&(current_state == state1)|=> (current_state == state2));

	tc_trans_4_req0: cover property( @(posedge clk) disable iff (!res_n)(inputvector ==? 3'b000) &&(current_state == state2)|=> (current_state == IDLE));

	tc_a_l: cover property( @(posedge clk) disable iff (!res_n)(inputvector ==? 3'b1x0) &&(current_state == state2)|=> (current_state == state0));

	tc_trans_6_req2: cover property( @(posedge clk) disable iff (!res_n)(inputvector ==? 3'b100) &&(current_state == state1)|=> (current_state == state0));

	tc_trans_7_req0: cover property( @(posedge clk) disable iff (!res_n)(inputvector ==? 3'b010) &&(current_state == state2)|=> (current_state == state1));

	tc_trans_8_req0: cover property( @(posedge clk) disable iff (!res_n)(inputvector ==? 3'b001) &&(current_state == state0)|=> (current_state == state2));

	tc_trans_9_req0: cover property( @(posedge clk) disable iff (!res_n)(inputvector ==? 3'b000) &&(current_state == state1)|=> (current_state == IDLE));

	tc_trans_10_req0: cover property( @(posedge clk) disable iff (!res_n)(inputvector ==? 3'b000) &&(current_state == state0)|=> (current_state == IDLE));

	tc_trans_11_req0: cover property( @(posedge clk) disable iff (!res_n)(inputvector ==? 3'b001) &&(current_state == IDLE)|=> (current_state == state2));

	tc_trans_12_req0: cover property( @(posedge clk) disable iff (!res_n)(inputvector ==? 3'b010) &&(current_state == IDLE)|=> (current_state == state1));

	tc_trans_14_req2: cover property( @(posedge clk) disable iff (!res_n)(inputvector ==? 3'bxx1) &&(current_state == state2)|=> (current_state == state2));

	tc_trans_15_default: cover property( @(posedge clk) disable iff (!res_n) (current_state == IDLE)|=> (current_state == IDLE) );

	tc_trans_16_default: cover property( @(posedge clk) disable iff (!res_n) (current_state == state0)|=> (current_state == state0) );

	tc_trans_17_z: cover property( @(posedge clk) disable iff (!res_n)(inputvector ==? 3'bx1x) &&(current_state == state1)|=> (current_state == state1));

// synopsys translate_on
`endif


endmodule
