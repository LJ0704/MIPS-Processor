
`timescale 1ns/1ps

/*
 * Description:
 * Testbench for the 32-bit MIPS register file.
 * Verifies synchronous writes, two asynchronous
 * read ports, write-enable control, and register $zero.
 *
 * Project: ECEN 5863 - Single-Cycle MIPS Processor
 * Module: register_file_tb
 */

module register_file_tb;

    reg clk;
    reg [4:0] rd_add1, rd_add2, wr_add;
    reg wr_en;
    reg [31:0] wr_data;
    wire [31:0] rd_data1, rd_data2;

    integer errors;

    register_file uut (
        .rd_add1(rd_add1),
        .rd_add2(rd_add2),
        .wr_en(wr_en),
        .wr_data(wr_data),
        .wr_add(wr_add),
        .clk(clk),
        .rd_data1(rd_data1),
        .rd_data2(rd_data2)
    );

    // Clock period = 10 ns
    always #5 clk = ~clk;

    task check;
        input [31:0] expected1, expected2;
        begin
            #1;
            if (rd_data1 !== expected1 ||
                rd_data2 !== expected2) begin
                $display("FAIL: RD1=%h RD2=%h", rd_data1, rd_data2);
                errors = errors + 1;
            end
            else
                $display("PASS: RD1=%h RD2=%h", rd_data1, rd_data2);
        end
    endtask

    initial begin
        clk = 0;
        errors = 0;
        rd_add1 = 0;
        rd_add2 = 0;
        wr_en = 0;
        wr_add = 0;
        wr_data = 0;

        // Register 0 must always read as zero
        #2;
        check(0, 0);

        // Write 25 to register 1
        @(negedge clk);
        wr_en = 1;
        wr_add = 1;
        wr_data = 25;
        @(posedge clk);
        #1;
        wr_en = 0;
        rd_add1 = 1;
        check(25, 0);

        // Write 15 to register 2
        @(negedge clk);
        wr_en = 1;
        wr_add = 2;
        wr_data = 15;
        @(posedge clk);
        #1;
        wr_en = 0;
        rd_add2 = 2;
        check(25, 15);

        // Attempt to overwrite register 0
        @(negedge clk);
        wr_en = 1;
        wr_add = 0;
        wr_data = 99;
        @(posedge clk);
        #1;
        wr_en = 0;
        rd_add1 = 0;
        check(0, 15);

        // Check write-enable protection
        @(negedge clk);
        wr_en = 0;
        wr_add = 2;
        wr_data = 100;
        @(posedge clk);
        #1;
        rd_add1 = 1;
        check(25, 15);

        if (errors == 0)
            $display("ALL REGISTER FILE TESTS PASSED");
        else
            $display("REGISTER FILE TESTS FAILED: %0d errors",
                     errors);

        $finish;
    end

endmodule
