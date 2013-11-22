module gearbox
(
    input clk,
    input res_n,
    input shift_in,
    input shift_out,
    input[15:0] data_in,
    output reg valid_out,
    output reg full,
    output reg[19:0] data_out
);
    reg RD;
    reg WR;
    reg[4:0] RD_addr;
    reg[4:0] WR_addr;
    reg[3:0] buffer [0:31];
    wire[5:0] distance;

    assign distance = (WR_addr < RD_addr) ? WR_addr+32-RD_addr : WR_addr-RD_addr;
    always @(posedge clk, negedge res_n)
    begin
        if(res_n == 0)
        begin
            full <= 0;
            valid_out <= 0;
            RD <= 0;
            WR <= 0;
            RD_addr <= 4'b0000;
            WR_addr <= 4'b0000;
        end
        else
        begin
            if(shift_in == 1) //new data available
            begin
                WR <= 1'b1;
                WR_addr <= WR_addr+4;
            end
            if(shift_out == 1) //want to read
            begin
                if(distance>5)
                begin
                    RD <= 1'b1;
                    RD_addr <= RD_addr+5;
                end
            end
        end
    end

    always @(posedge clk)
    begin
        if(WR == 1)
        begin
            buffer[WR_addr] <= data_in[3:0];
            buffer[WR_addr+1] <= data_in[7:4];
            buffer[WR_addr+2] <= data_in[11:8];
            buffer[WR_addr+3] <= data_in[15:12];
        end
        if(RD == 1)
        begin
            data_out[3:0] <= buffer[RD_addr];
            data_out[7:4] <= buffer[RD_addr+1];
            data_out[11:8] <= buffer[RD_addr+2];
            data_out[15:12] <= buffer[RD_addr+3];
            data_out[19:16] <= buffer[RD_addr+4];
        end
    end

endmodule

