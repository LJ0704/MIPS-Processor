
/*
 * 32-bit Single-Cycle MIPS Datapath
 * Project: ECEN 5863
 *
 * Connects:
 *   - Register file
 *   - ALU
 *   - Register destination selection
 *   - ALU operand selection
 *   - Register write-back selection
 *
 * Control signals are supplied by the control unit.
 * Instruction and data memory are connected externally.
 
@Author : Manasi 
@Date : 11/22/2026
 */

module datapath (
    input  wire        clk,

    // Current 32-bit instruction
    input  wire [31:0] instr,

    // Control signals from control unit
    input  wire        regwrite,
    input  wire        regdst,
    input  wire        alusrc,
    input  wire        memtoreg,
    input  wire [2:0]  alucontrol,

    // Data returned by data memory (LW)
    input  wire [31:0] readdata,

    // Outputs to data memory and branch logic
    output wire [31:0] aluout,
    output wire [31:0] writedata,
    output wire        zero,

    // Optional debug signals
    output wire [31:0] srca,
    output wire [31:0] srcb,
    output wire [31:0] result
);

    // Instruction fields
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [15:0] immediate;

    assign rs        = instr[25:21];
    assign rt        = instr[20:16];
    assign rd        = instr[15:11];
    assign immediate = instr[15:0];

    // Register file signals
    wire [4:0]  writereg;
    wire [31:0] rd1;
    wire [31:0] rd2;

    // Sign-extended immediate
    wire [31:0] signimm;

    assign signimm = {{16{immediate[15]}}, immediate};

    // Select destination register:
    // R-type: rd
    // I-type: rt
    assign writereg = regdst ? rd : rt;

    // Register file: 2 read ports, 1 write port
    register_file rf (
        .rd_add1  (rs),
        .rd_add2  (rt),
        .wr_en    (regwrite),
        .wr_data  (result),
        .wr_add   (writereg),
        .clk      (clk),
        .rd_data1 (rd1),
        .rd_data2 (rd2)
    );

    // First ALU operand comes from register file
    assign srca = rd1;

    // Second ALU operand:
    // 0 = register value
    // 1 = sign-extended immediate
    assign srcb = alusrc ? signimm : rd2;

    // 32-bit ALU
    alu alu_unit (
        .a          (srca),
        .b          (srcb),
        .alucontrol (alucontrol),
        .aluresult  (aluout),
        .zero       (zero)
    );

    // Data written to memory during SW
    assign writedata = rd2;

    // Register write-back:
    // 0 = ALU result
    // 1 = memory read data
    assign result = memtoreg ? readdata : aluout;

endmodule
