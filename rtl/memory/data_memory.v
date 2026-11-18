/*
@Description : Data Memory 
					The data memory has a single read/write port. If the write enable, 
					WE, is 1, it writes data WD into address A on the rising edge of the 
					clock. If the write enable is 0, it reads address A onto RD.
@Author : Likhita Jonnakuti
@Date : 11/17/2026
@Reference : 
*/


module data_memory(
	input wire clock, // rising edge 
	input wire WE, //When 0, Reads address A onto RD. When 1, writes data WD into address A
	input wire [31:0] WD,
	input wire [31:0] A,
	output wire [31:0] RD
);

   //data memory is 1KB
	reg [31:0] memory [0:255];
	
	//Read data from memory
	assign RD = memory[A[9:2]];
	
	always @ (posedge clock)
		if (WE) 
			begin
				memory[A[9:2]] <= WD;
		end
	end
endmodule
		