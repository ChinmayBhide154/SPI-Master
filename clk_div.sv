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
        //n_pulses_counter <= n_pulses;
    end 
    
    else begin
        //if((start != 1'b0) & (n_pulses_counter != 1'b0)) begin
        if(start != 1'b0 && counter != (SPI_MAXLEN * CLK_DIVIDE) << 2) begin
            spi_clk <= ~spi_clk;
            counter <= counter + 1;
            //n_pulses_counter = n_pulses_counter - 1;
        end
        
        else begin
            spi_clk <= 1'b0;
            n_pulses_counter <= n_pulses;
            counter <= 0;
        end
    end
end


endmodule