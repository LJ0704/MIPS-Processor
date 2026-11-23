/*
@Description : 
* 32-bit MIPS Arithmetic Logic Unit (ALU)
 * Project: ECEN 5863 - Single-Cycle MIPS Processor
 *
 * Inputs:
 *   a, b        - 32-bit operands
 *   alucontrol  - 3-bit operation selector
 *
 * Outputs:
 *   aluresult   - 32-bit operation result
 *   zero        - 1 when the result is zero
 
@Author : Manasi 
@Date : 11/15/2026
 */

module alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [2:0]  alucontrol,
    output reg  [31:0] aluresult,
    output reg         zero
);

    // Combinational ALU logic
    always @(*) begin
        aluresult = 32'b0;

        case (alucontrol)
            3'b000: aluresult = a & b;                 // AND
            3'b001: aluresult = a | b;                 // OR
            3'b010: aluresult = a + b;                 // ADD
            3'b110: aluresult = a - b;                 // SUB
            3'b111: aluresult = ($signed(a) < $signed(b))
                                   ? 32'd1 : 32'd0;   // SLT

            3'b100: aluresult = a ^ b;                 // XOR

            default: aluresult = 32'b0;
        endcase

        // Zero flag used for comparisons and branches
        zero = (aluresult == 32'b0);
    end

endmodule

