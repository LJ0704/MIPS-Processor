/*
 * Project: ECEN 5863 - Single-Cycle MIPS Processor
@Description : Has 2 read ports and one write port. The read port taks 5 bit address input (RD_ADD1, RD_ADD2) 
					since it is 2^5 = 32 registers as source operands. They read the 32 bit register value 
					onto read data output RD_OUT1 and RD_OUT2. The write port takes 5 bit address input WR_ADD, a write 
					enable input and a clock (CLK), writes the data into the register at rising edge of the clock.

@Author : Manasi 
@Date : 11/15/2026
*/

module register_file (
    input  wire [4:0]  rd_add1,
    input  wire [4:0]  rd_add2,
    input  wire        wr_en,
    input  wire [31:0] wr_data,
    input  wire [4:0]  wr_add,
    input  wire        clk,
    output wire [31:0] rd_data1,
    output wire [31:0] rd_data2
);

    // Storage for 32 general-purpose registers
    reg [31:0] registers [0:31];

    // Read ports: asynchronous
    assign rd_data1 = (rd_add1 == 5'd0)
                     ? 32'b0 : registers[rd_add1];

    assign rd_data2 = (rd_add2 == 5'd0)
                     ? 32'b0 : registers[rd_add2];

    // Write port: synchronous
    always @(posedge clk) begin
        if (wr_en && (wr_add != 5'd0))
            registers[wr_add] <= wr_data;
    end

endmodule




		
		  