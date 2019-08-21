`timescale 1ns / 1ps

module pe(
            input clk,
            input rstn,
            input ena,
            input weight_wea,
            input ifmap_wea,
            input psum_wea,
            
            input [31:0] value,
            output [31:0] output_Psum,
            output Ready
         );
         
         parameter IDLE = 3'b000;
         parameter READ = 3'b001;
         parameter LOAD = 3'b010;
         parameter CALC = 3'b011;
         parameter SAVE = 3'b100;
         
         reg [2:0] state;
         
         wire weight_fifo_full;
         wire weight_fifo_empty;
         wire ifmap_fifo_full; 
         wire ifmap_fifo_empty;
         
         wire [31:0] weight_fifo_dout;
         wire [31:0] ifmap_fifo_dout;
         
         wire weight_pop; 
         wire ifmap_pop;
         
         
         reg ready_reg;         
         
         
         
         reg [6:0] counter;
         reg [1:0] small_counter;
         reg [5:0] i;   
         reg [31:0] weight[2:0];
         reg [31:0] ifmap[31:0];
         reg [31:0] psum[29:0];
         reg calc_end;
         
         
         always @(posedge clk, negedge rstn)
         begin
            if(rstn == 1'b0)
            begin
                state<=IDLE;
            end
            else
            begin
                case(state)
                    IDLE:
                    begin
                        if (ena == 1'b0)
                        begin
                            state<=IDLE;
                        end
                        else if(weight_wea || ifmap_wea || psum_wea)
                        begin
                            state<=READ;
                        end 
                    end
                    READ:
                    begin
                        if (ena == 1'b0)
                        begin
                            state<=IDLE;
                        end
                        else if(weight_fifo_full && ifmap_fifo_full)
                        begin
                            state<=LOAD;
                        end
                    end
                    LOAD:
                    begin
                        if (ena == 1'b0)
                        begin
                            state<=IDLE;
                        end
                        else if(weight_fifo_empty && ifmap_fifo_empty)
                        begin
                            state<=CALC;
                        end
                    end
                    CALC:
                    begin
                        if (ena == 1'b0)
                        begin
                            state<=IDLE;
                        end
                        else if(calc_end == 1'b1)
                        begin
                            state<=SAVE;
                        end
                    end
                    SAVE:
                    begin
                        
                    end
                    default:
                    begin
                        state<=state;
                    end
                endcase
            end
         end
         

         
         assign Ready = ready_reg;
         assign weight_pop = (state==LOAD) ? 1'b1 : 1'b0;
         assign ifmap_pop = (state==LOAD) ? 1'b1 : 1'b0;
         
         //Ready value set-up
         always @(posedge clk, negedge rstn)
         begin
            if(rstn ==1'b0)
            begin
                ready_reg<=1'b0;
            end
            else
            begin
                if(state ==IDLE)
                begin
                    ready_reg<=1'b1;
                end
                else if(state == READ)
                begin
                    ready_reg<=1'b1;
                end
                else if(state == LOAD)
                begin
                    ready_reg<=1'b0;
                end
                else
                begin
                    ready_reg<=ready_reg;
                end
            end
         end
         
         fifo3 weight_fifo(
            .clk(clk),
            .rstn(rstn),
            .push(weight_wea),
            .din(value),
            .full(weight_fifo_full),
            .pop(weight_pop),
            .empty(weight_fifo_empty),
            .dout(weight_fifo_dout)
            );

         fifo32 ifmap_fifo(
            .clk(clk),
            .rstn(rstn),
            .push(ifmap_wea),
            .din(value),
            .full(ifmap_fifo_full),
            .pop(ifmap_pop),
            .empty(ifmap_fifo_empty),
            .dout(ifmap_fifo_dout)
            );
         

         
         always @(posedge clk, negedge rstn)
         begin
            if(rstn==1'b0)
            begin
                counter<=0;
                small_counter<=0;
                calc_end<=0;
                /*
                generate
                    genvar i;
                    for(i=0; i<=31; i=i+1)
                    begin
                        ifmap[i]<=0;
                    end
                endgenerate
                */
                
                weight[0] <=0;
                weight[1] <=0;
                weight[2] <=0;
                
                for(i=0; i<=31; i=i+1)
                begin
                    ifmap[i]<=0;
                end
                
                for(i=0; i<=29; i=i+1)
                begin
                    psum[i]<=0;
                end
            end
            else
            begin
                if(state == LOAD)
                begin
                    if(counter<=31)
                    begin
                        if(counter<=2)
                        begin
                            weight[counter] <= weight_fifo_dout;
                        end
                        ifmap[counter] <= ifmap_fifo_dout;
                        counter<=counter+1;
                    end
                end
                if(state ==CALC)
                begin
                    if(counter >= 32)
                    begin
                        counter<=0;
                        calc_end<=0;
                    end
                    else
                    begin
                        if(counter<30)
                        begin
                            psum[counter] = psum[counter] + (ifmap[counter+small_counter] * weight[small_counter]);
                            small_counter <= small_counter +1;
                            if(small_counter>=2)
                            begin
                                small_counter<=0;
                                counter<=counter+1;
                            end
                        end
                        else
                        begin
                            calc_end<=1;
                        end
                    end
                end                
            end
         end
         
         
endmodule
