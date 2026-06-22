`timescale 1ns/1ps

module decoder_tb;

    // DUT input
    logic [31:0] instruction;

    // DUT outputs
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rd;

    logic [31:0] imm;

    // test control
    logic test_failed;

    decoder dut (
        .instruction(instruction),

        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),

        .imm(imm)
    );

    initial begin

        // ----------------------------------
        // INIT
        // ----------------------------------
        instruction  = 32'b0;
        test_failed   = 0;

        #1;

        // ----------------------------------
        // TEST 1: R-type (add x3, x1, x2)
        // ----------------------------------
        instruction = 32'b0000000_00010_00001_000_00011_0110011;
        #1;

        if (opcode != 7'b0110011) begin
            test_failed = 1;
            $error("TEST 1 FAILED: opcode");
        end

        if (rd != 5'd3) begin
            test_failed = 1;
            $error("TEST 1 FAILED: rd");
        end

        if (rs1 != 5'd1) begin
            test_failed = 1;
            $error("TEST 1 FAILED: rs1");
        end

        if (rs2 != 5'd2) begin
            test_failed = 1;
            $error("TEST 1 FAILED: rs2");
        end

        if (imm != 32'd0) begin
            test_failed = 1;
            $error("TEST 1 FAILED: imm should be 0 for R-type");
        end

        // ----------------------------------
        // TEST 2: I-type (addi x5, x0, 2)
        // ----------------------------------
        instruction = 32'b000000000010_00000_000_00101_0010011;
        #1;

        if (opcode != 7'b0010011) begin
            test_failed = 1;
            $error("TEST 2 FAILED: opcode");
        end

        if (rd != 5'd5) begin
            test_failed = 1;
            $error("TEST 2 FAILED: rd");
        end

        if (rs1 != 5'd0) begin
            test_failed = 1;
            $error("TEST 2 FAILED: rs1");
        end

        if (imm != 32'd2) begin
            test_failed = 1;
            $error("TEST 2 FAILED: imm");
        end

        // ----------------------------------
        // TEST 3: I-type sign extension (addi x1, x0, -5)
        // ----------------------------------
        instruction = 32'b111111111011_00000_000_00001_0010011;
        #1;

        if (imm != 32'hFFFFFFFB) begin
            test_failed = 1;
            $error("TEST 3 FAILED: sign extension");
        end

        // ----------------------------------
        // FINAL RESULT
        // ----------------------------------
        if (!test_failed)
            $display("ALL DECODER TESTS PASSED");
        else
            $display("DECODER TESTS FAILED");

        $finish;

    end

endmodule