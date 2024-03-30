`timescale 1ns/1ps

module tb_clk_div;

    // Parameters for the testbench
    localparam CLK_PERIOD = 10; // Clock period in ns for 100MHz
    integer CLK_DIVIDE = 100;
    localparam SPI_MAXLEN = 16;

    // Testbench Signals
    logic clk;
    logic rst;
    logic spi_clk;
    logic start;
    logic [$clog2(SPI_MAXLEN):0] n_pulses;
    logic done;

    // Instantiate the Device Under Test (DUT)

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

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk; // Toggle clock every half period
    end

    // Reset logic
    initial begin
        rst = 0; // Reset is active low
        // Keep reset low for 5 clock cycles
        repeat(5) @(posedge clk);
        #5000;
        start = 1'b1;
        n_pulses = 10;
        rst = 1; // Release reset
    end

    // Test Sequence
    initial begin
        // Initialize
        @(negedge rst); // Wait for reset to go low
        @(posedge rst); // Wait for reset to release

        // Observe the output for some time
        repeat(1000) @(posedge clk);

        // Finish the simulation
        $finish;
    end

    // Optional: Monitor Outputs
    initial begin
        $monitor("Time: %0t | rst: %b | clk: %b | spi_clk: %b", $time, rst, clk, spi_clk);
    end

endmodule