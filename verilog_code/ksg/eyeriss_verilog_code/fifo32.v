`timescale 1ns / 1ps


module fifo32(input clk,
            input rstn,
            input push,
            input [31:0] din,
            output full,
            input pop,
            output empty,
            output [31:0] dout
            );

reg [31:0] data[31:0];
reg [31:0] dout_reg;
reg [4:0] r_p;
reg [4:0] w_p;
reg [5:0] count;

assign dout = dout_reg;
assign full = (count==6'b100000) ? 1'b1 : 1'b0;
assign empty = (count==6'b000000) ? 1'b1 : 1'b0;

always @(posedge clk, negedge rstn)
begin
    if(rstn==1'b0)
    begin
        data[0]<=0;
        data[1]<=0;
        data[2]<=0;
        data[3]<=0;
        data[4]<=0;
        data[5]<=0;
        data[6]<=0;
        data[7]<=0;
        data[8]<=0;
        data[9]<=0;
        
        data[10]<=0;
        data[11]<=0;
        data[12]<=0;
        data[13]<=0;
        data[14]<=0;
        data[15]<=0;
        data[16]<=0;
        data[17]<=0;
        data[18]<=0;
        data[19]<=0;
        
        data[20]<=0;
        data[21]<=0;
        data[22]<=0;
        data[23]<=0;
        data[24]<=0;
        data[25]<=0;
        data[26]<=0;
        data[27]<=0;
        data[28]<=0;
        data[29]<=0;
        
        data[30]<=0;
        data[31]<=0;
                
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
