/*
@Description : Program counter is an 32 bit register. Its ouput PC points to the current instruction and
					input (pc') points to next instruction. Update the PC every posedge of the clock
@Author : Likhita Jonnakuti 
@Date : 11/17/2026
*/

module program_counter(
	input wire [31:0] next_pc,
	input wire reset,
	input wire clk,
	output reg [31:0] pc
);

	//Update PC at evry poseedge of the clock
	always @(posedge clk)
		begin 
			if(reset)
				pc <= 32'd0;
			else
				pc <= next_pc; //retains the previous value of pc in between the clock edge
				
		end	
endmodule

	
				