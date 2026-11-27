/*
@Description : Sign Extension 
@Author : Likhita Jonnakuti
@Date : 11/19/2026
@Reference : 1) https://medium.com/@LambdaMamba/building-a-mips-single-cycle-processor-in-verilog-9a3fac6321d
				 2) Digital Design and Computer Architecture Book: https://www.academia.edu/40117228/Digital_Design_and_Computer_Architecture#outer_page_364
*/

//Need to compile for errors
module sign_extend(
	input wire [15:0] instr,
	output wire [31:0]signimm
);
	
	assign signimm = {{16{instr[15]}}, instr[15:0]};
		
endmodule