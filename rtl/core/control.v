/*
@Description : Main control unit. Decodes opcode into datapath control signals.
@Author : Likhita Jonnakuti
@Date : 11/26/2026
@Reference : Table 7.5 Main decoder truth table enhaced support (Test Book)
*/

module control(
	input wire [5:0] opcode,
	output reg regwrite,
	output reg regdst,
	output reg branch,
	output reg jump,
	output reg memread,
	output reg memtoreg,
	output reg [1:0] alucontrol,
	output reg memwrite,
	output reg alusrc,
	output reg memwrite
);
	always @(*) 
		begin 
			regwrite = 1'b0;
			regdst = 1'b0;
			alusrc = 1'b0;
			memtoreg = 1'b0;
			memwrite = 1'b0;
			branch = 1'b0;
			jump = 1'b0;
			aluop = 2'b00;
			
			case (opcode)
				6'b000000: //R -type
					begin
						regwrite = 1'b1;
						regdst = 1'b1;
						aluop = 2'b10;
					end
				6'b001000: //addi tuper instruction 
					begin
						regwrite = 1'b1;
						regdst = 1'b0;
						aluop = 2'00;
					end
				6'b000010: //j
					begin
						jump = 1'b1;
					end
				6'b100011: //lw
					begin
						regwrite = 1'b1;
						alusrc = 1'b1;
						aluop = 2'b00;
						memtoreg = 1'b1;
					end
				6'b101011: //sw
					begin
						memwrite = 1'b1;
						alusrc = 1'b1;
						aluop = 2'b00;
					end
				6'b000100: // beq
					begin              
						branch = 1'b1;
						aluop  = 2'b01;
					end
				default:
					begin
					end
			endcase
		end
		
endmodule
						
			