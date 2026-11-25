
// @Description:
// Testbench for the 32-bit MIPS Arithmetic Logic Unit (ALU).
// This testbench verifies ADD, SUB, AND, OR, XOR, and
// signed SLT operations using predefined input values.
// It also checks the zero flag and compares the actual
// ALU outputs with expected results.
// 
// Test results are displayed as PASS or FAIL in ModelSim.
//
//  @Project : ECEN 5863 - Single-Cycle MIPS Processor
//  @Module  : alu_tb
//  @Author  : Manasi
//  @Date    : 11/24/2026
 
 
`timescale 1ns/1ps

module alu_tb;

    reg [31:0] a, b;
    reg [2:0] alucontrol;
    wire [31:0] aluresult;
    wire zero;

    integer errors;

    alu uut (
        .a(a),
        .b(b),
        .alucontrol(alucontrol),
        .aluresult(aluresult),
        .zero(zero)
    );

    task check;
        input [31:0] expected;
        input expected_zero;
        begin
            #10;
            if (aluresult !== expected || zero !== expected_zero) begin
                $display("FAIL: control=%b A=%d B=%d result=%h zero=%b",
                         alucontrol, a, b, aluresult, zero);
                errors = errors + 1;
            end
            else
                $display("PASS: control=%b result=%h zero=%b",
                         alucontrol, aluresult, zero);
        end
    endtask

    initial begin
        errors = 0;

        // ADD: 10 + 5 = 15
        a = 10; b = 5; alucontrol = 3'b010;
        check(15, 0);

        // SUB: 10 - 5 = 5
        alucontrol = 3'b110;
        check(5, 0);

        // AND: 10 & 5 = 0
        alucontrol = 3'b000;
        check(0, 1);

        // OR: 10 | 5 = 15
        alucontrol = 3'b001;
        check(15, 0);

        // XOR: 10 ^ 5 = 15
        alucontrol = 3'b100;
        check(15, 0);

        // SLT: 5 < 10
        a = 5; b = 10; alucontrol = 3'b111;
        check(1, 0);

        // Signed SLT: -1 < 1
        a = 32'hFFFFFFFF; b = 1;
        alucontrol = 3'b111;
        check(1, 0);

        // Equal subtraction: 5 - 5 = 0
        a = 5; b = 5; alucontrol = 3'b110;
        check(0, 1);

        if (errors == 0)
            $display("ALL ALU TESTS PASSED");
        else
            $display("ALU TESTS FAILED: %0d errors", errors);

        $finish;
    end

endmodule
