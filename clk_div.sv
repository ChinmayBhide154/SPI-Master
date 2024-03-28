module clk_div(
    input wire clk,
    input wire rst,
    input integer CLK_DIVIDE, // Assume 32-bit wide for generality
    output reg spi_clk
);

reg [31:0] counter;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        counter <= 0;
        spi_clk <= 0;
    end else begin
        if (counter == (CLK_DIVIDE >> 1) - 1) begin
            spi_clk <= ~spi_clk;
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
end

endmodule