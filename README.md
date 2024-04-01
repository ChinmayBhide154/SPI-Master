This SPI Master implementation comprises of a clock divider and spi driver which are connected together to create an SPI Master.

The Clock Divider divides the system clock in order to create an spi_clk with lower frequency. The clock divider is implemented with reset and decides when to assert / deassert the spi clock based on the value of an internal counter. The clock divider also automatically deasserts the spi_clk when the spi transaction is complete.

MOSI and MISO were latched together via a direct sequential assignment on the negative edge of SCLK.



1 SPI Transaction in modelsim (All Signals)
![image](https://github.com/ChinmayBhide154/SPI-Master/assets/85247848/2c596036-a79c-40d5-b820-74b7990f9d89)

3 SPI Transactions in modelsim (All Signals)
![image](https://github.com/ChinmayBhide154/SPI-Master/assets/85247848/5a59a8dd-ea17-49e6-a3bc-278a215b5268)

1 SPI Transaction in Modelsim (Relevant Signals)
![image](https://github.com/ChinmayBhide154/SPI-Master/assets/85247848/141d34b4-5f18-4783-b753-52244e19168c)


3 SPI Transactions in Modelsim (Relevant Signals):
![image](https://github.com/ChinmayBhide154/SPI-Master/assets/85247848/79363076-1942-452b-b66e-30486e8aeb3b)



