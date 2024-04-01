`timescale 1ns/1ps

module tb_clk_div;

    localparam CLK_PERIOD = 10; 
    integer CLK_DIVIDE = 100;
    localparam SPI_MAXLEN = 16;

    logic clk;
    logic rst;
    logic spi_clk;
    logic start;
    logic [$clog2(SPI_MAXLEN):0] n_pulses;
    logic done;


    clk_div #(
        .SPI_MAXLEN(SPI_MAXLEN)
    ) DUT (
    	.rst(rst),
    	.clk(clk),
	    .CLK_DIVIDE(CLK_DIVIDE),
    	.spi_clk(spi_clk),
        .start(start),
        .n_pulses(n_pulses),
        .done(done)
    );

    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk; 
    end

    initial begin
        rst = 0; 
        repeat(5) @(posedge clk);
        #5000;
        start = 1'b1;
        n_pulses = 10;
        rst = 1; 
    end

    initial begin
        @(negedge rst);
        @(posedge rst); 

        repeat(1000) @(posedge clk);

        $finish;
    end

    initial begin
        $monitor("Time: %0t | rst: %b | clk: %b | spi_clk: %b", $time, rst, clk, spi_clk);
    end

endmodule