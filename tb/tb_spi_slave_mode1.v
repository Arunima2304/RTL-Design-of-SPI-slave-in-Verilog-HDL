`timescale 1ns/1ps
module tb_spi_slave;
    reg clk;
    reg rst;
    reg cs;
    reg sclk;
    reg mosi;
    reg [7:0] tx_data;
    reg cpol;
    reg cpha;
    wire miso;
    wire [7:0] rx_data;
    wire rx_valid;

    // DUT
    spi_slave dut (
        .clk(clk),
        .rst(rst),
        .cs(cs),
        .sclk(sclk),
        .mosi(mosi),
        .tx_data(tx_data),
        .cpol(cpol),
        .cpha(cpha),
        .miso(miso),
        .rx_data(rx_data),
        .rx_valid(rx_valid)
    );

    // System clock
    always #5 clk = ~clk;

    initial begin

        // Initial values
        clk = 0;
        rst = 1;
        cs = 1;
        sclk = 1;
        mosi = 0;

        // Mode 1
        cpol = 0;
        cpha = 1;
        tx_data = $random;
      $display("TX DATA = %b", tx_data);
        #20;
        rst = 0;
        #20;
        cs = 0;
        // Send Data
      #20; sclk = 1;mosi = tx_data[7];#20;sclk = 0;
      #20; sclk = 1;mosi =tx_data[6]; #20;sclk = 0; 
       #20; sclk = 1;mosi = tx_data[5];#20;sclk = 0;  
       #20; sclk = 1;mosi = tx_data[4];#20;sclk = 0; 
       #20; sclk = 1;mosi = tx_data[3];#20;sclk = 0;  
       #20; sclk = 1;mosi = tx_data[2];#20;sclk = 0; 
       #20; sclk = 1;mosi = tx_data[1];#20;sclk = 0;
       #20; sclk = 1;mosi = tx_data[0]; #20;sclk = 0; 
        // End SPI
        #20;
        cs = 1;

        #100;

        $display("RX DATA = %b", rx_data);

        $finish;

    end
  initial 
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0,tb_spi_slave);
    end

endmodule
