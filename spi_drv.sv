module spi_drv #(
    parameter integer CLK_DIVIDE = 100, // Clock divider to indicate frequency of SCLK
    parameter integer SPI_MAXLEN = 16   // Maximum SPI transfer length
) (
    input logic sresetn,                   // Active low reset, synchronous to clk
    
    // Command interface 
    input logic start_cmd,                 // Start SPI transfer
    output logic spi_drv_rdy,              // Ready to begin a transfer
    input logic [$clog2(SPI_MAXLEN):0] n_clks,  // Number of bits (SCLK pulses) for the SPI transaction
    input logic [SPI_MAXLEN-1:0] tx_data,       // Data to be transmitted out on MOSI
    output logic [SPI_MAXLEN-1:0] rx_miso,      // Data read in from MISO
    
    // SPI pins
    input logic SCLK,                    // SPI clock sent to the slave
    output logic MOSI,                    // Master out slave in pin (data output to the slave)
    output logic MISO,
    output logic SS_N                     // Slave select, will be 0 during a SPI transaction
);
    logic [$clog2(SPI_MAXLEN):0] counter;


    always_ff@(posedge SCLK) begin
        if(!sresetn | counter == 0) begin
            counter <= n_clks;
            spi_drv_rdy <= 1'b1;
            SS_N <= 1'b1;
        end

        else begin
            if(start_cmd) begin
                counter <= counter - 1;
                spi_drv_rdy <= 1'b1;
                MOSI <= tx_data[counter - 1];
            end
            else begin
                spi_drv_rdy <= 1'b0;
                counter <= n_clks;
            end
        end
    end

    // Slave Side
    always_ff@(negedge SCLK) begin
        //MISO <= rx_miso[counter - 1];
        MISO <= MOSI;
        rx_miso[counter] <= MISO;
    end

endmodule









