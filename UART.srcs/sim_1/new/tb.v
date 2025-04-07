`timescale 1ns/1ps

module tb;

reg clk = 0, reset = 0;
reg [7:0] tx_data = 8'h00;      // 8 bit hexadecimal initialing to 0
reg tx_start = 0;
wire tx, tx_busy;

wire rx;        //wire instead of ref becasue to connect wire-to-wire 
wire [7:0] rx_data;
wire rx_done;


initial begin 
forever #10 clk = ~clk;
end

// Transmitor module instantiates  (basically, you're creating an object )
tx tx_DUT(.clk(clk),
          .reset(reset),
          .tx_data(tx_data),
          .tx_start(tx_start),
          .tx(tx),
          .tx_busy(tx_busy)
          );

// Receiver module instantiates
rx rx_DUT(.clk(clk),
          .reset(reset),
          .rx_data(rx_data),
          .rx_done(rx_done),
          .rx(rx)
          );
          
assign rx = tx;     // connecting wire-to-wire

initial begin
$display("Starting UART Testbench");
        $dumpfile("uart.vcd");
        $dumpvars(0, tb);
#10;
reset = 1;

#20;
reset = 0;

tx_data = 8'h7A;        // 122(Z ASCII) / 16 = 7 with a remainder of 10 = 7A
tx_start = 1;
#10 tx_start = 0;

wait(rx_done);      // waits till rx receive the data i.e (rx_done == 1). / receiver finishes receiving 8 bits + stop bit
#20;                // Wait 20 time units to let signals settle before checking results

$display("Received data: %h", rx_data);

end

endmodule