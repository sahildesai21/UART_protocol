`timescale 1ns / 1ps

module rx(
    input clk,
    input reset,
    input rx,
    output reg rx_done,
    output reg [7:0] rx_data 
    );
    
    parameter clk_per_bit = 868;
    
    reg receiving = 0;
    reg [7:0] rx_shift = 0;
    reg [3:0] bit_index = 0; 
    reg [15:0] count_clk = 0;
    
    always @ (posedge clk , posedge reset) begin 
        if (reset==1) begin 
            rx_done <= 0;
            count_clk <= 0;
            bit_index <= 0;
            receiving <= 0;                
            end
             
        else begin
            rx_done <= 0;
            if ( !receiving && (rx == 0) ) begin  
            receiving <= 1;
            count_clk <= 0;
            bit_index <= 0;  
            end
        else if (receiving) begin
                if (count_clk < clk_per_bit -1) begin
                bit_index <= bit_index + 1;
                count_clk <= 0;
                
                case (bit_index)
                1 : rx_shift[0] <= rx; 
                2 : rx_shift[1] <= rx;
                3 : rx_shift[2] <= rx;
                4 : rx_shift[3] <= rx;
                5 : rx_shift[4] <= rx;
                6 : rx_shift[5] <= rx;
                7 : rx_shift[6] <= rx;
                8 : rx_shift[7] <= rx;
                9 : begin
                    rx_data <= rx_shift;
                    rx_done <= 1;
                    receiving <= 0;
                    end
                endcase
             end   
           else begin
             count_clk <= count_clk + 1;
           end
        end          
     end
  end   
endmodule