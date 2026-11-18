/*
@Description : Instruction memory
@Author : Likhita Jonnakuti
@Date : 11/17/2026
@Reference : 1) https://medium.com/@LambdaMamba/building-a-mips-single-cycle-processor-in-verilog-9a3fac6321d
				 2) Digital Design and Computer Architecture Book: https://www.academia.edu/40117228/Digital_Design_and_Computer_Architecture#outer_page_364
*/

//Need to compile for errors
module instruction_memory(
	input wire [31:0] A,
	output wire [31:0] RD
);
	
		reg [31:0] memory [0:255]; // 1KB of instruction storage (256 * 32 / 8)
		
		initial begin
			$readmemh("test_program.mem", memory);
		end
		
		assign RD = memory[A[9:2]];
		
endmodule