`timescale 1ns / 1ps


module fifo3(input clk,
            input rstn,
            input push,
            input [31:0] din,
            output full,
            input pop,
            output empty,
            output [31:0] dout
            );

reg [31:0] data[2:0];
reg [31:0] dout_reg;
reg [1:0] r_p;
reg [1:0] w_p;
reg [1:0] count;

assign dout = dout_reg;
assign full = (count==2'b11) ? 1'b1 : 1'b0;
assign empty = (count==2'b00) ? 1'b1 : 1'b0;

always @(posedge clk, negedge rstn)
begin
    if(rstn==1'b0)
    begin
        data[0]<=0;
        data[1]<=0;
        data[2]<=0;
        count<=0;
        r_p<=0;
        w_p<=0;
        dout_reg<=0;
    end
    else
    begin
        if(push && ~full && ~pop)
        begin
            w_p<=w_p+1;
            data[w_p]<=din;
            count<=count+1;
        end
        else if(pop && ~empty && ~push)
        begin
            r_p<=r_p+1;
            dout_reg<=data[r_p];
            data[r_p]<=0;
            count<=count-1;
        end
        else
        begin
            dout_reg<=0;
        end
    end
end



endmodule
