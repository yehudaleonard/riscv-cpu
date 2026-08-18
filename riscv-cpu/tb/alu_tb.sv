`timescale 1ns/1ps

module alu_tb;

    logic [31:0] a;
    logic [31:0] b;
    logic [3:0]  alu_ctrl;

    logic [31:0] result;
    logic        zero;

    logic test_failed;

    alu dut (
        .a(a),
        .b(b),
        .alu_ctrl(alu_ctrl),
        .result(result),
        .zero(zero)
    );

    initial begin

        // Initialize signals
        a = 0;
        b = 0;
        alu_ctrl = 0;

        test_failed = 0;

        #1;

        // ----------------------------------
        // TEST 1: ADD
        // ----------------------------------
        a = 10;
        b = 5;
        alu_ctrl = 4'b0000;
        #10;

        if (result != 15) begin
            $error("ADD failed");
            test_failed = 1;
        end

        // ----------------------------------
        // TEST 2: SUB
        // ----------------------------------
        a = 10;
        b = 5;
        alu_ctrl = 4'b0001;
        #10;

        if (result != 5) begin
            $error("SUB failed");
            test_failed = 1;
        end

        // ----------------------------------
        // TEST 3: AND
        // ----------------------------------
        a = 32'hF0F0;
        b = 32'h0FF0;
        alu_ctrl = 4'b0010;
        #10;

        if (result != 32'h00F0) begin
            $error("AND failed");
            test_failed = 1;
        end

        // ----------------------------------
        // TEST 4: OR
        // ----------------------------------
        a = 32'hF0F0;
        b = 32'h0FF0;
        alu_ctrl = 4'b0011;
        #10;

        if (result != 32'hFFF0) begin
            $error("OR failed");
            test_failed = 1;
        end

        // ----------------------------------
        // TEST 5: XOR
        // ----------------------------------
        a = 32'hAAAA;
        b = 32'h5555;
        alu_ctrl = 4'b0100;
        #10;

        if (result != 32'hFFFF) begin
            $error("XOR failed");
            test_failed = 1;
        end

        // ----------------------------------
        // TEST 6: SLT
        // ----------------------------------
        a = 3;
        b = 5;
        alu_ctrl = 4'b0101;
        #10;

        if (result != 1) begin
            $error("SLT failed");
            test_failed = 1;
        end

        // ----------------------------------
        // TEST 7: ZERO FLAG
        // ----------------------------------
        a = 5;
        b = 5;
        alu_ctrl = 4'b0001;
        #10;

        if (result != 0) begin
            $error("ZERO result failed");
            test_failed = 1;
        end

        if (zero != 1) begin
            $error("ZERO flag failed");
            test_failed = 1;
        end

        // ----------------------------------
        // FINAL RESULT
        // ----------------------------------
        if (!test_failed)
            $display("ALL ALU TESTS PASSED");
        else
            $display("ALU TESTS FAILED");

        $finish;

    end

endmodule