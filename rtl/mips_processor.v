//This is where all the stuff will be integrated?
module mips_processor (
    input  wire        clk,
    input  wire        reset,
    output wire [31:0] dbg_pc,
    output wire [31:0] dbg_aluout,
    output wire [31:0] dbg_instr,
    output wire [31:0] dbg_result,
    output wire        dbg_zero,
    output wire        dbg_regwrite
);

    wire [31:0] pc, next_pc, pc_plus4, instr;
	 wire [31:0] result;

    wire        regwrite, regdst, alusrc, memtoreg, memwrite;
    wire        branch, branch_ne, jump;
    wire [1:0]  aluop;
    wire [2:0]  alucontrol;

    wire [31:0] readdata, aluout, writedata, signimm;
    wire        zero;

    wire [31:0] branch_target, jump_target, branch_pc;
    wire        branch_taken;

    // sign-extended immediate for the branch offset
    assign signimm = {{16{instr[15]}}, instr[15:0]};

    program_counter pc_reg (
        .next_pc(next_pc), .reset(reset), .clk(clk), .pc(pc)
    );

    instruction_memory imem (
        .A(pc), .RD(instr)
    );

    control ctrl (
        .opcode   (instr[31:26]),
        .regwrite (regwrite),
        .regdst   (regdst),
        .branch   (branch),
        .branch_ne(branch_ne),
        .jump     (jump),
        .memtoreg (memtoreg),
        .aluop    (aluop),
        .memwrite (memwrite),
        .alusrc   (alusrc)
    );

    alu_control aluctrl (
        .aluop     (aluop),
        .funct     (instr[5:0]),
        .alucontrol(alucontrol)
    );

    datapath dp (
        .clk       (clk),
        .instr     (instr),
        .regwrite  (regwrite),
        .regdst    (regdst),
        .alusrc    (alusrc),
        .memtoreg  (memtoreg),
        .alucontrol(alucontrol),
        .readdata  (readdata),
        .aluout    (aluout),
        .writedata (writedata),
        .zero      (zero),
        .result    (result)
    );

    data_memory dmem (
        .clock(clk), .WE(memwrite), .WD(writedata), .A(aluout), .RD(readdata)
    );

    adder pc4_adder (
        .a(pc), .b(32'd4), .y(pc_plus4)
    );

    adder branch_adder (
        .a(pc_plus4), .b({signimm[29:0], 2'b00}), .y(branch_target)
    );

    assign jump_target  = {pc_plus4[31:28], instr[25:0], 2'b00};
    assign branch_taken = branch & (zero ^ branch_ne);

    mux mux_branch (
        .d0(pc_plus4), .d1(branch_target), .sel(branch_taken), .y(branch_pc)
    );

    mux mux_jump (
        .d0(branch_pc), .d1(jump_target), .sel(jump), .y(next_pc)
    );
	 
	 assign dbg_pc       = pc;
    assign dbg_aluout   = aluout;
    assign dbg_instr    = instr;
    assign dbg_result   = result;
    assign dbg_zero     = zero;
    assign dbg_regwrite = regwrite;

endmodule