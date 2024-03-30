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

    // Master Side
    /*
    always_ff@(posedge SCLK) begin
        if(!sresetn) begin
            counter <= n_clks;
            spi_drv_rdy <= 1'b1;
            SS_N <= 1'b1;
        end

        else begin
            if(start_cmd) begin
                if (counter == n_clks + 1) begin
                    SS_N <= 1'b0;
                    spi_drv_rdy <= 1'b0;
                end
                if(counter == 0) begin
                    counter <= n_clks + 1;
                end
                SS_N <= 0;
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
        MISO <= MOSI;
        rx_miso[counter + 1] <= MISO;
    end
    */

always_ff@(posedge SCLK or negedge sresetn) begin
        if(!sresetn) begin
            counter <= n_clks;
            spi_drv_rdy <= 1'b0;
            SS_N <= 1'b1;
        end

        else begin
            if(start_cmd) begin
                SS_N <= 1'b0; // Assert SS_N to start SPI communication
                spi_drv_rdy <= 1'b1;
                counter <= n_clks; // Load the counter with the number of clocks/bits to send

                if(counter > 0) begin
                    MOSI <= tx_data[counter-1]; // Transmit the next bit on MOSI
                    spi_drv_rdy <= 1'b1;
                    counter <= counter - 1; // Decrement the counter
                end

                if(counter == 0) begin
                    spi_drv_rdy <= 1'b0; // Transfer complete, indicate readiness for new command
                    SS_N <= 1'b1; // Deassert SS_N to end SPI communication
                end
            //else if(counter > 0) begin
             //   MOSI <= tx_data[counter-1]; // Transmit the next bit on MOSI
             //   spi_drv_rdy <= 1'b1;
             //   counter <= counter - 1; // Decrement the counter
            //end

            //else if(counter == 0) begin
             //   spi_drv_rdy <= 1'b0; // Transfer complete, indicate readiness for new command
             //   SS_N <= 1'b1; // Deassert SS_N to end SPI communication
            //end
            end
            else begin
                counter <= n_clks;
                spi_drv_rdy <= 1'b0;
                SS_N <= 1'b1;
            end
        end
    end
    

    // Slave Side
    always_ff@(negedge SCLK) begin
        MISO <= MOSI;
        rx_miso[counter + 1] <= MISO;
    end





    /*
always_ff@(posedge SCLK or negedge sresetn) begin
    if(!sresetn) begin
        counter <= 0;
        spi_drv_rdy <= 1'b0;
        MOSI <= 1'b0;
        SS_N <= 1'b1; // SS_N should be high (inactive) on reset
    end else if(start_cmd && spi_drv_rdy) begin
        // Prepare for SPI transfer
        SS_N <= 1'b0; // Assert SS_N to start SPI communication
        spi_drv_rdy <= 1'b0; // Not ready for new command until current is finished
        counter <= n_clks; // Load the counter with the number of clocks/bits to send
    end else if(counter > 0) begin
        MOSI <= tx_data[counter-1]; // Transmit the next bit on MOSI
        counter <= counter - 1; // Decrement the counter
    end else if(counter == 0) begin
        spi_drv_rdy <= 1'b1; // Transfer complete, indicate readiness for new command
        SS_N <= 1'b1; // Deassert SS_N to end SPI communication
    end
end

// Since you are told to latch MISO directly with MOSI, let's do this on the negedge of SCLK
// This means the slave device is assumed to sample MOSI on posedge and the master samples MISO on negedge
always_ff@(negedge SCLK or negedge sresetn) begin
    if(!sresetn) begin
        rx_miso <= 0; // Clear rx_miso on reset
    end else if(SS_N == 1'b0) begin // Only latch when SS_N is asserted (active low)
        rx_miso <= (rx_miso << 1) | MISO; // Shift in the bit from MISO
    end
end
*/

endmodule









