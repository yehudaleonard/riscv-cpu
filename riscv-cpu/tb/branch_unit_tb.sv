`timescale 1ns/1ps

module branch_unit_tb;

    logic branch;
    logic branch_not_equal;
    logic zero;

    logic take_branch;

    logic test_failed;


    branch_unit dut (
        .branch(branch),
        .branch_not_equal(branch_not_equal),
        .zero(zero),
        .take_branch(take_branch)
    );


    initial begin

        branch = 0;
        branch_not_equal = 0;
        zero = 0;

        test_failed = 0;

        #1;

        // ----------------------------------
        // TEST 1: BEQ taken
        // branch instruction + zero result
        // ----------------------------------
        branch = 1'b1;
        branch_not_equal = 1'b0;
        zero = 1'b1;

        #1;

        if (take_branch != 1'b1) begin
            test_failed = 1;
            $error("TEST 1 FAILED: BEQ should take branch when zero=1");
        end

        // ----------------------------------
        // TEST 2: BEQ not taken
        // branch instruction + non-zero result
        // ----------------------------------
        zero = 1'b0;

        #1;

        if (take_branch != 1'b0) begin
            test_failed = 1;
            $error("TEST 2 FAILED: BEQ should not take branch when zero=0");
        end

        // ----------------------------------
        // TEST 3: BNE taken
        // branch_not_equal + non-zero result
        // ----------------------------------
        branch = 1'b0;
        branch_not_equal = 1'b1;
        zero = 1'b0;

        #1;

        if (take_branch != 1'b1) begin
            test_failed = 1;
            $error("TEST 3 FAILED: BNE should take branch when zero=0");
        end

        // ----------------------------------
        // TEST 4: BNE not taken
        // branch_not_equal + zero result
        // ----------------------------------
        zero = 1'b1;

        #1;

        if (take_branch != 1'b0) begin
            test_failed = 1;
            $error("TEST 4 FAILED: BNE should not take branch when zero=1");
        end

        // ----------------------------------
        // FINAL RESULT
        // ----------------------------------
        if (!test_failed)
            $display("ALL BRANCH UNIT TESTS PASSED");
        else
            $display("BRANCH UNIT TESTS FAILED");

        $finish;

    end

endmodule