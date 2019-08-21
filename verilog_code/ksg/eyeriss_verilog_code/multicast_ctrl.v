`timescale 1ns / 1ps

module multicast_ctrl(
    input clk,
    input rstn,
    input [5:0] ID_from_Host,
    input [5:0] Tag_from_Bus,
    input Ready_from_PE,
    input Enable_from_Bus,
    input [31:0] value_from_Bus,
    
    input weight_wea_from_Host,
    input ifmap_wea_from_Host,
    input psum_wea_from_Host,
    
    output weight_wea_to_PE,
    output ifmap_wea_to_PE,
    output psum_wea_to_PE,
    
    output Enable_to_PE,
    output Ready_to_Bus,
    output [31:0] value_to_PE
    );
    
    assign Ready_to_Bus = Ready_from_PE;
    
    
    assign weight_wea_to_PE = weight_wea_from_Host;
    assign ifmap_wea_to_PE = ifmap_wea_from_Host;
    assign psum_wea_to_PE = psum_wea_from_Host;
    
    reg [5:0] ID_reg;
    
    always @(posedge clk, negedge rstn)
    begin
        if(rstn ==1'b0)
        begin
            ID_reg<=0;
        end
        else
        begin
            ID_reg<=ID_from_Host;
        end
    end
    
    assign Enable_to_PE = (Enable_from_Bus && Ready_from_PE && (Tag_from_Bus == ID_reg));
    
    assign value_to_PE = (Enable_to_PE ==1'b1) ? value_from_Bus : 0;
    
    
endmodule
