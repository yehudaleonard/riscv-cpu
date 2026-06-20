`timescale 1ns/1ps

module pc_tb;

    logic clk;
    logic reset;
    logic [31:0] pc_next;

    logic [31:0] pc;

    logic test_failed;

    pc dut (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        reset = 0;
        pc_next = 0;

        test_failed = 0;

        // ----------------------------------
        // TEST 1: RESET
        // ----------------------------------
        reset = 1;
        #1;

        if (pc != 0) begin
            $error("TEST 1 FAILED: Reset did not set PC to 0");
            test_failed = 1;
        end

        reset = 0;

        // ----------------------------------
        // TEST 2: LOAD 4
        // ----------------------------------
        pc_next = 32'd4;

        @(posedge clk);
        #1;

        if (pc != 32'd4) begin
            $error("TEST 2 FAILED: PC did not load pc_next");
            test_failed = 1;
        end

        // ----------------------------------
        // TEST 3: NO CHANGE BETWEEN EDGES
        // ----------------------------------
        pc_next = 32'd100;

        #2;

        if (pc != 32'd4) begin
            $error("TEST 3 FAILED: PC changed without clock edge");
            test_failed = 1;
        end

        @(posedge clk);
        #1;

        if (pc != 32'd100) begin
            $error("TEST 3 FAILED: PC did not update on clock edge");
            test_failed = 1;
        end

        // ----------------------------------
        // TEST 4: MULTIPLE UPDATES
        // ----------------------------------
        pc_next = 32'd8;

        @(posedge clk);
        #1;

        if (pc != 32'd8) begin
            $error("TEST 4 FAILED: PC update to 8 failed");
            test_failed = 1;
        end

        pc_next = 32'd12;

        @(posedge clk);
        #1;

        if (pc != 32'd12) begin
            $error("TEST 4 FAILED: PC update to 12 failed");
            test_failed = 1;
        end

        pc_next = 32'd16;

        @(posedge clk);
        #1;

        if (pc != 32'd16) begin
            $error("TEST 4 FAILED: PC update to 16 failed");
            test_failed = 1;
        end

        // ----------------------------------
        // FINAL RESULT
        // ----------------------------------
        if (!test_failed)
            $display("ALL PC TESTS PASSED");
        else
            $display("PC TESTS FAILED");

        $finish;

    end

endmodule