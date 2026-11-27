/*
@Description : 2:1 Multiplexer
@Author : Likhita Jonnakuti 
@Date : 11/17/2026
*/

module mux (
	input wire [31:0] d0,
	input wire [31:0] d1,
	input wire sel,
	output wire [31:0] y
);

	assign y = sel ? d1 : d0;
endmodule


