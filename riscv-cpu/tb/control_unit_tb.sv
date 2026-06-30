`timescale 1ns/1ps

module control_unit_tb;

    // DUT inputs
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    // DUT outputs
    logic       reg_write;
    logic       alu_src;
    logic [3:0] alu_ctrl;

    // Test control
    logic test_failed;

    // DUT instance
    control_unit dut (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),

        .reg_write(reg_write),
        .alu_src(alu_src),
        .alu_ctrl(alu_ctrl)
    );

    initial begin

        opcode      = 0;
        funct3      = 0;
        funct7      = 0;
        test_failed = 0;

        #1;

        // ----------------------------------
        // TEST 1: ADD
        // ----------------------------------
        opcode = 7'b0110011;
        funct7 = 7'b0000000;
        funct3 = 3'b000;

        #1;

        if (reg_write != 1 || alu_src != 0 || alu_ctrl != 4'b0000) begin
            test_failed = 1;
            $error("TEST 1 FAILED: ADD");
        end

        // ----------------------------------
        // TEST 2: SUB
        // ----------------------------------
        opcode = 7'b0110011;
        funct7 = 7'b0100000;
        funct3 = 3'b000;

        #1;

        if (reg_write != 1 || alu_src != 0 || alu_ctrl != 4'b0001) begin
            test_failed = 1;
            $error("TEST 2 FAILED: SUB");
        end

        // ----------------------------------
        // TEST 3: AND
        // ----------------------------------
        opcode = 7'b0110011;
        funct7 = 7'b0000000;
        funct3 = 3'b111;

        #1;

        if (reg_write != 1 || alu_src != 0 || alu_ctrl != 4'b0010) begin
            test_failed = 1;
            $error("TEST 3 FAILED: AND");
        end

        // ----------------------------------
        // TEST 4: OR
        // ----------------------------------
        opcode = 7'b0110011;
        funct7 = 7'b0000000;
        funct3 = 3'b110;

        #1;

        if (reg_write != 1 || alu_src != 0 || alu_ctrl != 4'b0011) begin
            test_failed = 1;
            $error("TEST 4 FAILED: OR");
        end

        // ----------------------------------
        // TEST 5: XOR
        // ----------------------------------
        opcode = 7'b0110011;
        funct7 = 7'b0000000;
        funct3 = 3'b100;

        #1;

        if (reg_write != 1 || alu_src != 0 || alu_ctrl != 4'b0100) begin
            test_failed = 1;
            $error("TEST 5 FAILED: XOR");
        end

        // ----------------------------------
        // TEST 6: SLT
        // ----------------------------------
        opcode = 7'b0110011;
        funct7 = 7'b0000000;
        funct3 = 3'b010;

        #1;

        if (reg_write != 1 || alu_src != 0 || alu_ctrl != 4'b0101) begin
            test_failed = 1;
            $error("TEST 6 FAILED: SLT");
        end

        // ----------------------------------
        // TEST 7: ADDI
        // ----------------------------------
        opcode = 7'b0010011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;

        #1;

        if (reg_write != 1 || alu_src != 1 || alu_ctrl != 4'b0000) begin
            test_failed = 1;
            $error("TEST 7 FAILED: ADDI");
        end

        // ----------------------------------
        // TEST 8: Invalid instruction
        // ----------------------------------
        opcode = 7'b1111111;
        funct3 = 3'b111;
        funct7 = 7'b1111111;

        #1;

        if (reg_write != 0 || alu_src != 0 || alu_ctrl != 4'b0000) begin
            test_failed = 1;
            $error("TEST 8 FAILED: invalid instruction handling");
        end

        // ----------------------------------
        // FINAL RESULT
        // ----------------------------------
        if (!test_failed)
            $display("ALL CONTROL UNIT TESTS PASSED");
        else
            $display("CONTROL UNIT TESTS FAILED");

        $finish;

    end

endmodule