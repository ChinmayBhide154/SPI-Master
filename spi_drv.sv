module spi_drv #(
    parameter integer CLK_DIVIDE = 100, 
    parameter integer SPI_MAXLEN = 16   
) (
    input logic sresetn,                   
    input logic start_cmd,                
    output logic spi_drv_rdy,              
    input logic [$clog2(SPI_MAXLEN):0] n_clks,  
    input logic [SPI_MAXLEN-1:0] tx_data,      
    output logic [SPI_MAXLEN-1:0] rx_miso,     
    
    input logic SCLK,                    
    output logic MOSI,                   
    output logic MISO,
    output logic SS_N                     
);

    logic [($clog2(SPI_MAXLEN) + 1):0] counter;

    always_ff@(negedge SCLK or negedge sresetn) begin
        if(!sresetn) begin
            counter <= 0;
            spi_drv_rdy <= 1'b1;
            SS_N <= 1'b1;
        end

        else begin
            if(start_cmd && spi_drv_rdy) begin
                SS_N <= 1'b0; 
                spi_drv_rdy <= 1'b0;
                counter <= n_clks;
                MOSI <= tx_data[n_clks - 1];
            end
            if(counter > 1) begin
                MOSI <= tx_data[counter - 2]; 
                counter <= counter - 1; 
            end

            else if(counter == 1 & SS_N == 1'b0) begin
                MOSI <= tx_data[0];
                SS_N <= 1'b1; 
            end
        end
    end
    
    always_ff@(posedge SCLK) begin
        if (~SS_N) begin
            MISO <= MOSI;
            rx_miso[counter - 1] <= MOSI;
        end
    end
endmodule









