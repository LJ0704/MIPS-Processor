/*
@Description : Has 2 read ports and one write port. The read port taks 5 bit address input (RD_ADD1, RD_ADD2) 
					since it is 2^5 = 32 registers as source operands. They read the 32 bit register value 
					onto read data output RD_OUT1 and RD_OUT2. The write port takes 5 bit address input WR_ADD, a write 
					enable input and a clock (CLK), writes the data into the register at rising edge of the clock.
@Author : Manasi 
@Date : 11/15/2026
*/

module (
	input rd_add1[0:4],
	input rd_add2[0:4],
	input wr_en,
	input wr_data[31:0],
	input wr_add[0:4],
	input clk,
	output rd_data1[0:31],
	output rd_data2[0:31],
);
		
		  