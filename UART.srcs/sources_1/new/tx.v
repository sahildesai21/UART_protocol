`timescale 1ns / 1ps

module tx(
    input clk,              // by default all the input are wire.
    input reset,
    input [7:0] tx_data,
    input tx_start,
    output reg tx,
    output reg tx_busy                 // tell the whether the system is busy or not.
    );
    
    parameter clk_per_bit = 87;          // clk_frequency(1MHz) / baud rate(11520) = clk_per_bit
    
    reg [7:0] tx_shift = 0;           // for storing the data for FSM
    reg [15:0] count_clk = 0;         // counts how many clk cycle passed for the current bit 
    reg sending = 0;                  // it tell whether the system is busy or not internally.
    reg  [3:0] bit_index =0;
    
    always @ (posedge clk , posedge reset) 
    begin
    if (reset == 1) begin 
        tx <= 1'b1;
        sending <= 0; 
        tx_busy <= 0;
        count_clk <= 0;
        bit_index <= 0;
        end
    else if (!tx_busy && tx_start) 
            begin
            tx <= 0;                   // start bit
            tx_busy <= 1;
            sending <= 1;
            tx_shift <= tx_data;
            count_clk <= 0;
            bit_index <= 0;        
            end
        else if(sending) 
            if (count_clk < clk_per_bit -1)  begin
                count_clk <= count_clk + 1;                     //holding time till 87 clocks so that the data can reach to the rx efficently 
                end
            else begin 
                count_clk <= 0;
                bit_index <= bit_index + 1;
                    case(bit_index)
                    0 : tx <= tx_shift[0];
                    1 : tx <= tx_shift[1];
                    2 : tx <= tx_shift[2];
                    3 : tx <= tx_shift[3];
                    4 : tx <= tx_shift[4];
                    5 : tx <= tx_shift[5];
                    6 : tx <= tx_shift[6];
                    7 : tx <= tx_shift[7];
                    8 : begin
                        sending <= 0;
                        tx_busy <= 0;
                        tx <= 1;                       //stop bit
                    end
                    endcase    
                end
            end
   
 endmodule
