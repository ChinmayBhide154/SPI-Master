module clk_div #(
    parameter integer SPI_MAXLEN = 16
) (
    input wire clk,
    input wire rst,
    input integer CLK_DIVIDE, // Assume 32-bit wide for generality
    input logic [$clog2(SPI_MAXLEN):0] n_pulses,
    input logic start,
    output logic done,
    output reg spi_clk
);

reg [31:0] counter;
logic [$clog2(SPI_MAXLEN):0] n_pulses_counter;
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        counter <= 0;
        spi_clk <= 0;
        n_pulses_counter <= n_pulses;
        done <= 1'b0;
    end 
    
    else begin
        if(start & n_pulses_counter != 1'b0) begin
            //if (counter == (CLK_DIVIDE >> 1) - 1) begin
            spi_clk <= ~spi_clk;
                //counter <= 0;
            //end 
            
            //else begin
                counter <= counter + 1;
            //end

            n_pulses_counter = n_pulses_counter - 1;
            done <= 1'b0;
        end

        else begin
            spi_clk <= 1'b0;
            n_pulses_counter <= n_pulses;
            done = 1'b1;
            counter <= 0;
        end
    end
end

endmodule