/*
@Description : ALU decoder which converts ALU opcode (from the controller) and function (from the instruction memory)
					into 3 bit ALU operation
@Author : Likhita Jonnakuti
@Date : 11/25/2026
*/

module alu_control(
	input wire [1:0] aluop,
	input wire [5:0] funct,
	output reg [2:0] alucontrol
);

	always @(*)
		begin
			case (aluop)
				2'b00: 
					begin
						alucontrol = 3'b010; //add, lw, sw, addi
					end
				2'b01:
					begin 
						alucontrol = 3'b110; // sub, beq
					end
				2'b10:
					begin
						case (funct)
							6'100000: //add 
								begin 
									alucontrol = 3'010;
								end
							6'100010: //sub
								begin 
									alucontrol = 3'110;
								end
							6'100100: //and
								begin 
									alucontrol = 3'000;
								end
							6'100101: //or
								begin 
									alucontrol = 3'001;
								end
							6'101010: //slt  
								begin 
									alucontrol = 3'111;
								end
							6'100110: //xor
								begin 
									alucontrol = 3'100;
								end
							default:
								begin 
									alucontrol = 3'010;
								end
						endcase
					end
					default:
						begin
							alucontrol = 3'b010;
						end
				endcase
		end
endmodule
							
						
				