// 2 CLKs

module gearbox
(
    input clk_400MHz,
    input clk_320MHz,
    input res_n,
    input shift_in,
    input shift_out,
    input[15:0] data_in,
    output reg valid_out,
    output full,
    output reg[19:0] data_out
);
    reg[4:0] RD_addr;
    reg[4:0] WR_addr;
    reg[3:0] buffer [0:31];
    wire[5:0] distance;

    assign distance = (WR_addr < RD_addr) ? WR_addr+32-RD_addr : WR_addr-RD_addr;
    assign full = (distance >= 27) ? 1 : 0; // set full signal when WR_addr is max_addr-1     

    always @(posedge clk_400MHz,negedge res_n)
    begin
        if(res_n == 0)
        begin
            WR_addr <= 4'b0000;
        end
        else
        begin
            // full signal has to be added
            if(shift_in == 1 && full == 0) //new data available
            begin
                WR_addr <= WR_addr + 4; // when full condition do not write has to be added
            end
        end
    end

    always @(posedge clk_320MHz,negedge res_n)
    begin
        if(res_n == 0)
        begin
            valid_out <= 0;
            RD_addr <= 4'b0000;
            //WR_addr <= 4'b0000;
        end
        else 
        begin
            if(shift_out == 1 && distance >= 5) //want to read
            begin
                valid_out <= 1;
                RD_addr <= RD_addr + 5;
            end
            else
            begin
                valid_out <= 0;
            end    
        end    
    end
    
    always @(posedge clk_400MHz)
    begin
        if(shift_in == 1 && full == 0) // enable and address calculation need a one CLK cycle time gap
        begin
            buffer[WR_addr] <= data_in[3:0];
            buffer[(WR_addr + 1) % 32] <= data_in[7:4];
            buffer[(WR_addr + 2) % 32] <= data_in[11:8];
            buffer[(WR_addr + 3) % 32] <= data_in[15:12];
        end
    end

    always @(posedge clk_320MHz)
    begin
        if(shift_out == 1 && distance >= 5)
        begin
            data_out[3:0] <= buffer[RD_addr];
            data_out[7:4] <= buffer[(RD_addr + 1) % 32];
            data_out[11:8] <= buffer[(RD_addr + 2) % 32];
            data_out[15:12] <= buffer[(RD_addr + 3) % 32];
            data_out[19:16] <= buffer[(RD_addr + 4) % 32];
        end
    end

endmodule

