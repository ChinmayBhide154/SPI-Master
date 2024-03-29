module spi_drv #(
    parameter integer SPI_MAXLEN = 32
)(
    input wire clk,
    input wire sresetn,
    input wire start_cmd,
    input wire spi_clk, // Driven by clk_div module
    input wire [SPI_MAXLEN-1:0] tx_data,
    input wire [$clog2(SPI_MAXLEN):0] n_clks,
    input wire MISO,
    output reg MOSI,
    output reg SS_N = 1'b1,
    output reg spi_drv_rdy = 1'b1,
    output reg [SPI_MAXLEN-1:0] rx_miso
);

    // Define states
    typedef enum int {IDLE, LOAD, TRANSFER, UNLOAD} state_t;
    state_t current_state = IDLE, next_state = IDLE;

    reg [SPI_MAXLEN-1:0] tx_data_reg;
    reg [$clog2(SPI_MAXLEN):0] bit_count = 0;
    reg spi_clk_last = 0; // To detect edges of spi_clk

    // State transition logic
    always @(posedge clk or negedge sresetn) begin
        if (!sresetn) begin
            current_state <= IDLE;
            spi_clk_last <= 0;
        end else begin
            current_state <= next_state;
            spi_clk_last <= spi_clk;
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            IDLE: begin
                if (start_cmd && spi_drv_rdy)
                    next_state = LOAD;
                else
                    next_state = IDLE;
            end
            LOAD: begin
                next_state = TRANSFER;
            end
            TRANSFER: begin
                if (bit_count == 0)
                    next_state = UNLOAD;
                else
                    next_state = TRANSFER;
            end
            UNLOAD: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output and internal logic based on state
    always @(posedge clk) begin
        if (!sresetn) begin
            // Reset all outputs and internal registers
            spi_drv_rdy <= 1'b1;
            SS_N <= 1'b1;
            MOSI <= 1'b0;
            tx_data_reg <= 0;
            bit_count <= 0;
            rx_miso <= 0;
        end else begin
            case (current_state)
                IDLE: begin
                    spi_drv_rdy <= 1'b1;
                end
                LOAD: begin
                    // Load data and prepare for transmission
                    tx_data_reg <= tx_data;
                    bit_count <= n_clks;
                    SS_N <= 1'b0; // Assert Slave Select
                    spi_drv_rdy <= 1'b0;
                end
                TRANSFER: if (spi_clk != spi_clk_last) begin // Edge detected
                    if (!spi_clk) begin // Falling edge of SPI clock
                        MOSI <= tx_data_reg[SPI_MAXLEN-1]; // Set next bit
                        tx_data_reg <= tx_data_reg << 1; // Shift data
                    end else begin // Rising edge of SPI clock
                        rx_miso <= (rx_miso << 1) | MISO; // Read bit
                        bit_count <= bit_count - 1;
                    end
                end
                UNLOAD: begin
                    SS_N <= 1'b1; // Deassert Slave Select
                    spi_drv_rdy <= 1'b1; // Ready for next command
                end
            endcase
        end
    end
endmodule









