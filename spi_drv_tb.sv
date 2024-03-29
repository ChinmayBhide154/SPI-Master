// path/filename: tb_spi_drv.sv
// Corrected testbench for SPI master module, focusing on SPI clock generation and data transmission.

`timescale 1ns/1ps

module tb_spi_drv;

    localparam CLK_PERIOD = 20; // SPI clock period, adjusted as needed
    localparam SPI_MAXLEN = 16; // Maximum SPI data length

    // Testbench signals
    logic sresetn;
    logic start_cmd;
    logic spi_drv_rdy;
    logic [$clog2(SPI_MAXLEN):0] n_clks;
    logic [SPI_MAXLEN-1:0] tx_data;
    logic [SPI_MAXLEN-1:0] rx_miso;
    logic SCLK; // SPI Clock
    logic MOSI;
    logic MISO;
    logic SS_N;

    // DUT instantiation
    spi_drv #(
        .CLK_DIVIDE(100), // Parameterization as needed
        .SPI_MAXLEN(SPI_MAXLEN)
    ) dut (
        .sresetn(sresetn),
        .start_cmd(start_cmd),
        .spi_drv_rdy(spi_drv_rdy),
        .n_clks(n_clks),
        .tx_data(tx_data),
        .rx_miso(rx_miso),
        .SCLK(SCLK),
        .MOSI(MOSI),
        .MISO(MISO),
        .SS_N(SS_N)
    );

    // SCLK generator
    always #(CLK_PERIOD/2) SCLK = ~SCLK;

    // Test sequence
    initial begin
        // Initialize testbench signals
        SCLK = 0;
        sresetn = 0;
        start_cmd = 0;
        n_clks = 10;
        tx_data = 8'b11010001;
        MISO = 0; // Assume MISO is driven low when not in use

        // Reset sequence
        #40; // Wait for a few cycles
        sresetn = 1; // Release reset
        #40; // Wait for stabilization

        // SPI transaction setup
        for (int i = 0; i < 1000; i++) begin
            //n_clks = $urandom_range(1, SPI_MAXLEN);
            start_cmd = 1;
            #100; // Wait for transaction to complete, adjust as needed
        end


    end

    // Task to start SPI transaction


endmodule