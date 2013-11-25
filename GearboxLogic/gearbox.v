module gearbox
(
    input clk,
    input res_n,
    input shift_in,
    input shift_out,
    input[15:0] data_in,
    output reg valid_out,
    output full,
    output reg[19:0] data_out
);
    reg RD;
    reg WR;
    reg[4:0] RD_addr;
    reg[4:0] WR_addr;
    reg[3:0] buffer [0:31];
    wire[5:0] distance;
    wire[4:0] wr_addr_int0;
    wire[4:0] wr_addr_int1;
    wire[4:0] wr_addr_int2;
    wire[4:0] wr_addr_int3; 
    wire[4:0] rd_addr_int0;
    wire[4:0] rd_addr_int1;
    wire[4:0] rd_addr_int2;
    wire[4:0] rd_addr_int3;    
    wire[4:0] rd_addr_int4;

    assign distance = (WR_addr < RD_addr) ? WR_addr+32-RD_addr : WR_addr-RD_addr;
    assign full = (distance > 27) ? 1 : 0; // set full signal when WR_addr is max_addr-1     
    
    // to get the an overflow for out of buffer range 
    assign wr_addr_int0 = WR_addr;
    assign wr_addr_int1 = WR_addr+1;
    assign wr_addr_int2 = WR_addr+2;
    assign wr_addr_int3 = WR_addr+3;
    
    assign rd_addr_int0 = RD_addr;
    assign rd_addr_int1 = RD_addr+1;
    assign rd_addr_int2 = RD_addr+2;
    assign rd_addr_int3 = RD_addr+3;
    assign rd_addr_int4 = RD_addr+4;

    always @(posedge clk,negedge res_n)
    begin
        if(res_n == 0)
        begin
            RD <= 0;
            WR <= 0;
            valid_out <= 0;
            RD_addr <= 4'b0000;
            WR_addr <= 4'b0000;
        end
        else
        begin
            // full signal has to be added
            if(shift_in == 1 && full == 0) //new data available
            begin
                WR_addr <= WR_addr+4; // when full condition do not write has to be added
            end
            if(shift_out == 1 && distance>=5) //want to read
            begin
                valid_out <= 1;
                RD_addr <= RD_addr+5;
            end
            else
            begin
                valid_out <= 0;
            end
        end
    end
    
    always @(posedge clk)
    begin
        if(shift_in == 1 && full == 0) // enable and address calculation need a one CLK cycle time gap
        begin
            buffer[wr_addr_int0] <= data_in[3:0];
            buffer[wr_addr_int1] <= data_in[7:4];
            buffer[wr_addr_int2] <= data_in[11:8];
            buffer[wr_addr_int3] <= data_in[15:12];
        end
        if(shift_out == 1 && distance>=5)
        begin
            data_out[3:0] <= buffer[rd_addr_int0];
            data_out[7:4] <= buffer[rd_addr_int1];
            data_out[11:8] <= buffer[rd_addr_int2];
            data_out[15:12] <= buffer[rd_addr_int3];
            data_out[19:16] <= buffer[rd_addr_int4];
        end
    end

endmodule

