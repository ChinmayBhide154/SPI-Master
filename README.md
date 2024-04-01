This SPI Master implementation comprises of a clock divider and spi driver which are connected together to create an SPI Master.

The Clock Divider divides the system clock in order to create an spi_clk with lower frequency. The clock divider is implemented with reset and decides when to assert / deassert the spi clock based on the value of an internal counter. The clock divider also automatically deasserts the spi_clk when the spi transaction is complete.

MOSI and MISO were latched together via a direct sequential assignment on the negative edge of SCLK.



3 SPI Transactions in modelsim
![image](https://github.com/ChinmayBhide154/SPI-Master/assets/85247848/0c0caf50-1946-4ebd-b84a-02fa6c96fb6b)

1 SPI Transaction zoomed in for a better look:
![image](https://github.com/ChinmayBhide154/SPI-Master/assets/85247848/3f827769-8bdf-4724-bd8b-43d66bf2cb04)


