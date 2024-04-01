`timescale 1ns / 1ps

module SPIMaster_tb;

    parameter CLK_PERIOD = 10;
    parameter CLK_DIVIDE = 4; 
    parameter SPI_MAXLEN = 16;

    logic clk;
    logic sresetn;
    logic start_cmd;
    logic spi_drv_rdy;
    logic [$clog2(SPI_MAXLEN):0] n_clks;
    logic [SPI_MAXLEN-1:0] tx_data;
    logic [SPI_MAXLEN-1:0] rx_miso;
    logic SCLK;
    logic MOSI;
    logic MISO;
    logic SS_N;
    logic [1:0] cnt;

    SPIMaster #(
        .CLK_DIVIDE(CLK_DIVIDE),
        .SPI_MAXLEN(SPI_MAXLEN)
    ) dut (
        .clk(clk),
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

    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end


    initial begin
        cnt = 0;
        repeat(3) begin
            sresetn = 0;
            start_cmd = 0;
            n_clks = SPI_MAXLEN;
            tx_data = {SPI_MAXLEN{1'b0}};

            #(CLK_PERIOD*2) sresetn = 1;
            #(CLK_PERIOD*10);

            if(cnt == 0) tx_data = 32'hA5A5_A5A5; 
            else if (cnt == 1) tx_data = 32'hA675_3B46;
            else tx_data = 32'hA5A5_A5A5;
            n_clks = 16; 
            start_cmd = 1;

            wait (spi_drv_rdy);

            #1000;

            if (rx_miso == tx_data) begin
                $display("Test Passed, Received Data matches Transmitted Data");
            end else begin
                $display("Test Failed, Received Data: %0h does not match Transmitted Data: %0h", rx_miso, tx_data);
            end
            cnt = cnt + 1;
        end

    end

    always_ff @(posedge SCLK) begin
        if (SS_N == 1'b0) begin 
            MISO <= MOSI;
        end
    end

endmodule