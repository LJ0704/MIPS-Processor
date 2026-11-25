
`timescale 1ns/1ps

/*
 * Description:
 * Testbench for the 32-bit single-cycle MIPS datapath.
 * Verifies register write-back, arithmetic operations,
 * sign extension, memory addressing, and zero detection.
 *
 * Project: ECEN 5863 - Single-Cycle MIPS Processor
 * Module: datapath_tb
 */

module datapath_tb;

    reg clk;
    reg [31:0] instr;
    reg regwrite, regdst, alusrc, memtoreg;
    reg [2:0] alucontrol;
    reg [31:0] readdata;

    wire [31:0] aluout, writedata;
    wire [31:0] srca, srcb, result;
    wire zero;

    integer errors;

    datapath uut (
        .clk(clk),
        .instr(instr),
        .regwrite(regwrite),
        .regdst(regdst),
        .alusrc(alusrc),
        .memtoreg(memtoreg),
        .alucontrol(alucontrol),
        .readdata(readdata),
        .aluout(aluout),
        .writedata(writedata),
        .zero(zero),
        .srca(srca),
        .srcb(srcb),
        .result(result)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    task check_alu;
        input [31:0] expected;
        input expected_zero;
        begin
            #2;
            if (aluout !== expected ||
                zero !== expected_zero) begin
                $display("FAIL: ALU=%h expected=%h zero=%b",
                         aluout, expected, zero);
                errors = errors + 1;
            end
            else
                $display("PASS: ALU=%h zero=%b", aluout, zero);
        end
    endtask

    initial begin
        clk = 0;
        errors = 0;
        instr = 0;
        regwrite = 0;
        regdst = 0;
        alusrc = 0;
        memtoreg = 0;
        alucontrol = 3'b010;
        readdata = 0;

        // Write 25 into register 1 using memory write-back
        @(negedge clk);
        instr = {6'b0, 5'd0, 5'd1, 16'd0};
        readdata = 25;
        memtoreg = 1;
        regwrite = 1;

        @(posedge clk);
        #1 regwrite = 0;

        // Write 15 into register 2
        @(negedge clk);
        instr = {6'b0, 5'd0, 5'd2, 16'd0};
        readdata = 15;
        regwrite = 1;

        @(posedge clk);
        #1 regwrite = 0;

        // ADD: register 1 + register 2 = 40
        instr = {6'b0, 5'd1, 5'd2, 5'd3, 5'd0, 6'd0};
        memtoreg = 0;
        alusrc = 0;
        alucontrol = 3'b010;
        check_alu(40, 0);

        // SUB: 25 - 15 = 10
        alucontrol = 3'b110;
        check_alu(10, 0);

        // BEQ comparison: register 1 - register 1 = 0
        instr = {6'b0, 5'd1, 5'd1, 16'd0};
        alucontrol = 3'b110;
        check_alu(0, 1);

        // ADDI: register 1 + (-5) = 20
        instr = {6'b0, 5'd1, 5'd3, 16'hFFFB};
        alusrc = 1;
        alucontrol = 3'b010;
        check_alu(20, 0);

        // SW: address = register 1 + 4 = 29
        // Write data must come from register 2 = 15
        instr = {6'b0, 5'd1, 5'd2, 16'd4};
        check_alu(29, 0);

        if (writedata !== 32'd15) begin
            $display("FAIL: SW write data = %h", writedata);
            errors = errors + 1;
        end
        else
            $display("PASS: SW write data = 15");

        // LW: load memory value 99 into register 3
        @(negedge clk);
        instr = {6'b0, 5'd1, 5'd3, 16'd8};
        readdata = 99;
        alusrc = 1;
        memtoreg = 1;
        regwrite = 1;
        check_alu(33, 0);

        if (result !== 32'd99) begin
            $display("FAIL: LW write-back = %h", result);
            errors = errors + 1;
        end
        else
            $display("PASS: LW write-back = 99");

        @(posedge clk);
        #1 regwrite = 0;

        // Verify register 3 contains 99
        instr = {6'b0, 5'd3, 5'd2, 16'd0};
        alusrc = 0;
        memtoreg = 0;
        alucontrol = 3'b010;
        check_alu(114, 0);

        if (errors == 0)
            $display("ALL DATAPATH TESTS PASSED");
        else
            $display("DATAPATH TESTS FAILED: %0d errors",
                     errors);

        $finish;
    end

endmodule
