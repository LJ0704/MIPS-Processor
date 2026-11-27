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
							6'b100000: //add 
								begin 
									alucontrol = 3'b010;
								end
							6'b100010: //sub
								begin 
									alucontrol = 3'b110;
								end
							6'b100100: //and
								begin 
									alucontrol = 3'b000;
								end
							6'b100101: //or
								begin 
									alucontrol = 3'b001;
								end
							6'b101010: //slt  
								begin 
									alucontrol = 3'b111;
								end
							6'b100110: //xor
								begin 
									alucontrol = 3'b100;
								end
							default:
								begin 
									alucontrol = 3'b010;
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
							
						
				