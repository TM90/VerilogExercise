module lfsr #(
    parameter num_reg = 3,
    parameter[63:0] poly =7   
)
(
    input clk,
    input res_n,
    input enable,
    input clear,
    output d_out    
);
	reg[num_reg-1:0] q_reg;
	integer i;
	assign d_out = q_reg[num_reg-1];
	always @(posedge clk,negedge res_n)
	begin
		if(res_n==0)
		begin
			q_reg <= {num_reg{1'b1}};
		end
		else
		begin
			for(i=0;  i< num_reg; i=i+1)
			begin
				if(enable==1)
				begin
					if(i==0 && poly[0]==1)
					begin
						q_reg[0] <= q_reg[num_reg-1]; // highest and lowest bit in poly have to be set
					end 
					else
					begin
						if(poly[i]== 1)
						begin
							q_reg[i] <= q_reg[i-1] ^ q_reg[num_reg-1];		
						end
						else
						begin
							q_reg[i] <= q_reg[i-1];
						end
					end
				end
				if(clear==1)
				begin
					q_reg <= {num_reg{1'b1}};
				end
			end
		end
	end
endmodule
