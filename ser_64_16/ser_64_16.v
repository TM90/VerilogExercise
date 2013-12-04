//Authors: Sebastian Wittka, Tobias Markus
module ser_64_16 (
	input clk,
	input res_n,
	input valid_in,	
	input [63:0] data_in,
	input stop_in,	
	output reg stop_out,
	output reg valid_out,
	output reg[15:0] data_out);

    reg[1:0] sel;
    
    always @(posedge clk, negedge res_n)
	begin
        if(res_n == 0)
        begin
            sel <= 2'b00;
            stop_out <= 1'b0;
            valid_out <= 1'b0;
        end
        else
        begin
            if((valid_in == 1) && (stop_in == 0))
            begin
                sel <= sel + 1'b1;
                valid_out <= 1'b1;
                if(sel < 2'b11)
                begin
                    stop_out <= 1'b1;                
                end
                else 
                begin
                    stop_out <= 1'b0;
                end
            end
            else if((valid_in == 1) && (stop_in == 1))
            begin
                valid_out <= 1'b1;
                stop_out <= 1'b1;
            end
            else
            begin
                valid_out <=1'b0;
            end
        end
	end

    always @(posedge clk)
    begin
        case (sel)
            2'b00: data_out <= data_in[15:0];
            2'b01: data_out <= data_in[31:16];
            2'b10: data_out <= data_in[47:32];
            2'b11: data_out <= data_in[63:48];
        endcase
    end

endmodule

