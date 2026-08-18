`timescale 1ns/1ps

module next_pc_tb;

    logic [31:0] pc;
    logic [31:0] imm;
    logic [31:0] jalr_target;
    logic        take_branch;
    logic        jump;
    logic        jump_register;

    logic [31:0] pc_next;
    logic [31:0] pc_plus4;

    logic test_failed;


    next_pc dut (
        .pc(pc),
        .imm(imm),
        .jalr_target(jalr_target),
        .take_branch(take_branch),
        .jump(jump),
        .jump_register(jump_register),
        .pc_next(pc_next),
        .pc_plus4(pc_plus4)
    );


    initial begin

        pc = 0;
        imm = 0;
        jalr_target = 0;
        take_branch = 0;
        jump = 0;
        jump_register = 0;

        test_failed = 0;

        #1;

        // ----------------------------------
        // TEST 1: Normal instruction
        // PC should increment by 4
        // ----------------------------------
        pc = 32'd100;
        imm = 32'd20;
        take_branch = 1'b0;
        jump = 1'b0;
        jump_register = 1'b0;

        #1;

        if (pc_next != 32'd104) begin
            test_failed = 1;
            $error("TEST 1 FAILED: PC should increment by 4");
        end

        if (pc_plus4 != 32'd104) begin
            test_failed = 1;
            $error("TEST 1 FAILED: pc_plus4 should equal PC + 4");
        end

        // ----------------------------------
        // TEST 2: Taken branch
        // PC should add immediate offset
        // ----------------------------------
        pc = 32'd100;
        imm = 32'd20;
        take_branch = 1'b1;
        jump = 1'b0;
        jump_register = 1'b0;

        #1;

        if (pc_next != 32'd120) begin
            test_failed = 1;
            $error("TEST 2 FAILED: Branch target calculation incorrect");
        end

        if (pc_plus4 != 32'd104) begin
            test_failed = 1;
            $error("TEST 2 FAILED: pc_plus4 should equal PC + 4");
        end

        // ----------------------------------
        // TEST 3: JAL
        // PC should add immediate offset
        // ----------------------------------
        pc = 32'd100;
        imm = 32'd40;
        take_branch = 1'b0;
        jump = 1'b1;
        jump_register = 1'b0;

        #1;

        if (pc_next != 32'd140) begin
            test_failed = 1;
            $error("TEST 3 FAILED: JAL target calculation incorrect");
        end

        // ----------------------------------
        // TEST 4: JALR
        // PC should use aligned JALR target
        // ----------------------------------
        pc = 32'd100;
        imm = 32'd20;
        jalr_target = 32'h00000105;
        take_branch = 1'b0;
        jump = 1'b0;
        jump_register = 1'b1;

        #1;

        if (pc_next != 32'h00000104) begin
            test_failed = 1;
            $error("TEST 4 FAILED: JALR target calculation incorrect");
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