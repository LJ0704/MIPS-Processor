module board_top_file(
    input  wire       CLOCK_50,
    input  wire [1:0] KEY,
    input  wire [9:0] SW,
    output wire [9:0] LEDR,
    output wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);
    wire reset = ~KEY[0];
    wire clk_slow;

    clock_divider #(.DIV(25_000_000)) divider (
        .clk_in(CLOCK_50), .reset(reset), .clk_out(clk_slow)
    );

    wire [31:0] dbg_pc, dbg_aluout, dbg_instr, dbg_result;
    wire        dbg_zero, dbg_regwrite;

    mips_processor cpu (
        .clk(clk_slow),
        .reset(reset),
        .dbg_pc(dbg_pc),
        .dbg_aluout(dbg_aluout),
        .dbg_instr(dbg_instr),
        .dbg_result(dbg_result),
        .dbg_zero(dbg_zero),
        .dbg_regwrite(dbg_regwrite)
    );

    // Holds the last value written to the register file
    reg [31:0] last_result;
    always @(posedge clk_slow) begin
        if (dbg_regwrite) last_result <= dbg_result;
    end

    // SW[9:8] picks what the HEX shows:
    // 00 = PC            (see jump / branch targets)
    // 01 = ALU result    (add/sub/and/or/slt/xor/address)
    // 10 = instruction   (opcode + funct)
    // 11 = last write-back (persists across jump)
    reg [23:0] disp;
    always @(*) begin
        case (SW[9:8])
            2'b00: disp = dbg_pc[23:0];
            2'b01: disp = dbg_aluout[23:0];
            2'b10: disp = dbg_instr[23:0];
            2'b11: disp = last_result[23:0];
        endcase
    end

    seven_seg h5 (.hex(disp[23:20]), .seg(HEX5));
    seven_seg h4 (.hex(disp[19:16]), .seg(HEX4));
    seven_seg h3 (.hex(disp[15:12]), .seg(HEX3));
    seven_seg h2 (.hex(disp[11:8]),  .seg(HEX2));
    seven_seg h1 (.hex(disp[7:4]),   .seg(HEX1));
    seven_seg h0 (.hex(disp[3:0]),   .seg(HEX0));

    assign LEDR = dbg_pc[9:0];   // PC always on LEDs, so jump is obvious
endmodule