module clk_div #(
    parameter integer SPI_MAXLEN = 16
) (
    input wire clk,
    input wire rst,
    input integer CLK_DIVIDE, 
    input logic [$clog2(SPI_MAXLEN):0] n_pulses,
    input logic start,
    output reg spi_clk
);

reg [31:0] counter;
logic [$clog2(SPI_MAXLEN):0] n_pulses_counter;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        counter <= 0;
        spi_clk <= 0;
    end

    
    else begin
        if(counter > 1 && (counter <= ((SPI_MAXLEN * CLK_DIVIDE) >> 1) + 2) && start) begin
            spi_clk = ~spi_clk;
            counter <= counter + 1;
        end
        else if (counter == 0 || counter == 1) begin
            counter <= counter + 1;
        end
        //if(start != 1'b0 && (counter != (SPI_MAXLEN * CLK_DIVIDE) >> 1)) begin
            //spi_clk <= ~spi_clk;
          //  counter <= counter + 1;
        //end 

        else spi_clk <= 1'b0;
    end
end

endmodule