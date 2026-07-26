`timescale 1ns/1ps

module next_pc_tb;

    logic [31:0] pc;
    logic [31:0] imm;
    logic        take_branch;

    logic [31:0] pc_next;

    logic test_failed;


    next_pc dut (
        .pc(pc),
        .imm(imm),
        .take_branch(take_branch),
        .pc_next(pc_next)
    );


    initial begin

        pc = 0;
        imm = 0;
        take_branch = 0;

        test_failed = 0;

        #1;

        // ----------------------------------
        // TEST 1: Normal instruction
        // PC should increment by 4
        // ----------------------------------
        pc = 32'd100;
        imm = 32'd20;
        take_branch = 1'b0;

        #1;

        if (pc_next != 32'd104) begin
            test_failed = 1;
            $error("TEST 1 FAILED: PC should increment by 4");
        end

        // ----------------------------------
        // TEST 2: Taken branch
        // PC should add immediate offset
        // ----------------------------------
        pc = 32'd100;
        imm = 32'd20;
        take_branch = 1'b1;

        #1;

        if (pc_next != 32'd120) begin
            test_failed = 1;
            $error("TEST 2 FAILED: Branch target calculation incorrect");
        end

        // ----------------------------------
        // FINAL RESULT
        // ----------------------------------
        if (!test_failed)
            $display("ALL NEXT PC TESTS PASSED");
        else
            $display("NEXT PC TESTS FAILED");

        $finish;

    end

endmodule