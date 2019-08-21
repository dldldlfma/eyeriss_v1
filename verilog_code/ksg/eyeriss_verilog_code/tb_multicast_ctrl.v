`timescale 1ns / 1ps

module tb_mc_ctrl();

reg clk;
reg rstn;
reg ena;
reg [5:0] ID_from_Host;
reg [5:0] Tag_from_Bus;
wire Ready_from_PE;
reg Enable_from_Bus;
reg [31:0] value_from_Bus;

    
reg weight_wea_from_Host;
reg ifmap_wea_from_Host;
reg psum_wea_from_Host;
    
wire Enable_to_PE;
wire Ready_to_Bus;
wire [31:0] value_to_PE;

always #5 clk = ~clk;


initial
begin
    weight_wea_from_Host=0;
    ifmap_wea_from_Host=0;
    psum_wea_from_Host=0;
    clk =0;
    rstn =1;
    ID_from_Host=30;
    Tag_from_Bus=0;
    value_from_Bus=0;
    
    Enable_from_Bus=0;
    #1;
    rstn =0;
    #1;
    rstn=1;
    ena=1;
    Enable_from_Bus=1;
    repeat(5) @(posedge clk);
    
    Tag_from_Bus=30;
    value_from_Bus=1;
    repeat(5) @(posedge clk);
    ID_from_Host=33;
    value_from_Bus=1;
    repeat(3) @(posedge clk);
    
    Tag_from_Bus=33;
    
    repeat(5) @(posedge clk);
    
    repeat(5) 
    begin
        @(posedge clk)
        begin
            value_from_Bus=value_from_Bus +1;
            
        end
    end;
    value_from_Bus=1;
    weight_wea_from_Host=1;
    
    repeat(5) 
    begin
        @(posedge clk)
        begin
            value_from_Bus=value_from_Bus +1;
            
        end
    end;
    weight_wea_from_Host=0;
    
    ID_from_Host=30;
    Tag_from_Bus=40;
    
    repeat(10) @(posedge clk);
    Tag_from_Bus=30;
    
    ifmap_wea_from_Host=1;
    
    value_from_Bus=1;
    repeat(35) 
    begin
        @(posedge clk)
        begin
            value_from_Bus=value_from_Bus +1;   
        end
    end;
    ifmap_wea_from_Host=0;
    
    repeat(100) @(posedge clk);
    
    
    $finish;
end

multicast_ctrl tb(
    clk,
    rstn,
    ID_from_Host,
    Tag_from_Bus,
    Ready_from_PE,
    Enable_from_Bus,
    value_from_Bus,
        
    weight_wea_from_Host,
    ifmap_wea_from_Host,
    psum_wea_from_Host,
    
    weight_wea_to_PE,
    ifmap_wea_to_PE,
    psum_wea_to_PE,
        
    Enable_to_PE,
    Ready_to_Bus,
    value_to_PE
    );
    
    pe pe_tb(
        clk,
        rstn,
        ena,
        weight_wea_to_PE,
        ifmap_wea_to_PE,
        psum_wea_to_PE,
        
        value_to_PE,
        output_Psum,
        Ready_from_PE
      );
    
    
endmodule
