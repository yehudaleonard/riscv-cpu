`timescale 1ns/1ps

module control_unit_tb;

    // DUT inputs
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    // DUT outputs
    logic       reg_write;
    logic       alu_src_a;
    logic       alu_src_b;
    logic [3:0] alu_ctrl;
    logic       mem_write;
    logic [1:0] writeback_select;
    logic       branch;
    logic       branch_not_equal;
    logic       jump;
    logic       jump_register;

    // Test control
    logic test_failed;

    // DUT instance
    control_unit dut (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),

        .reg_write(reg_write),
        .alu_src_a(alu_src_a),
        .alu_src_b(alu_src_b),
        .alu_ctrl(alu_ctrl),
        .mem_write(mem_write),
        .writeback_select(writeback_select),
        .branch(branch),
        .branch_not_equal(branch_not_equal),
        .jump(jump),
        .jump_register(jump_register)
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

        if (reg_write != 1 ||
            alu_src_a != 0 ||
            alu_src_b != 0 ||
            alu_ctrl != 4'b0000) begin
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

        if (reg_write != 1 ||
            alu_src_a != 0 ||
            alu_src_b != 0 ||
            alu_ctrl != 4'b0001) begin
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

        if (reg_write != 1 ||
            alu_src_a != 0 ||
            alu_src_b != 0 ||
            alu_ctrl != 4'b0010) begin
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

        if (reg_write != 1 ||
            alu_src_a != 0 ||
            alu_src_b != 0 ||
            alu_ctrl != 4'b0011) begin
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

        if (reg_write != 1 ||
            alu_src_a != 0 ||
            alu_src_b != 0 ||
            alu_ctrl != 4'b0100) begin
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

        if (reg_write != 1 ||
            alu_src_a != 0 ||
            alu_src_b != 0 ||
            alu_ctrl != 4'b0101) begin
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

        if (reg_write != 1 ||
            alu_src_a != 0 ||
            alu_src_b != 1 ||
            alu_ctrl != 4'b0000) begin
            test_failed = 1;
            $error("TEST 7 FAILED: ADDI");
        end

        // ----------------------------------
        // TEST 8: LW
        // ----------------------------------
        opcode = 7'b0000011;
        funct3 = 3'b010;

        #1;

        if (reg_write != 1 ||
            alu_src_a != 0 ||
            alu_src_b != 1 ||
            alu_ctrl != 4'b0000 ||
            mem_write != 0 ||
            writeback_select != 2'b01) begin
            test_failed = 1;
            $error("TEST 8 FAILED: LW");
        end

        // ----------------------------------
        // TEST 9: JALR
        // ----------------------------------
        opcode = 7'b1100111;
        funct3 = 3'b000;

        #1;

        if (reg_write != 1 ||
            alu_src_a != 0 ||
            alu_src_b != 1 ||
            alu_ctrl != 4'b0000 ||
            writeback_select != 2'b10 ||
            jump_register != 1) begin
            test_failed = 1;
            $error("TEST 9 FAILED: JALR");
        end

        // ----------------------------------
        // TEST 10: JAL
        // ----------------------------------
        opcode = 7'b1101111;

        #1;

        if (reg_write != 1 ||
            writeback_select != 2'b10 ||
            jump != 1) begin
            test_failed = 1;
            $error("TEST 10 FAILED: JAL");
        end

        // ----------------------------------
        // TEST 11: LUI
        // ----------------------------------
        opcode = 7'b0110111;

        #1;

        if (reg_write != 1 ||
            writeback_select != 2'b11) begin
            test_failed = 1;
            $error("TEST 11 FAILED: LUI");
        end

        // ----------------------------------
        // TEST 12: AUIPC
        // ----------------------------------
        opcode = 7'b0010111;

        #1;

        if (reg_write != 1 ||
            alu_src_a != 1 ||
            alu_src_b != 1 ||
            alu_ctrl != 4'b0000 ||
            writeback_select != 2'b00) begin
            test_failed = 1;
            $error("TEST 12 FAILED: AUIPC");
        end

        // ----------------------------------
        // TEST 13: SW
        // ----------------------------------
        opcode = 7'b0100011;
        funct3 = 3'b010;

        #1;

        if (reg_write != 0 ||
            alu_src_a != 0 ||
            alu_src_b != 1 ||
            alu_ctrl != 4'b0000 ||
            mem_write != 1) begin
            test_failed = 1;
            $error("TEST 13 FAILED: SW");
        end

        // ----------------------------------
        // TEST 14: BEQ
        // ----------------------------------
        opcode = 7'b1100011;
        funct3 = 3'b000;

        #1;

        if (reg_write != 0 ||
            alu_src_a != 0 ||
            alu_src_b != 0 ||
            alu_ctrl != 4'b0001 ||
            branch != 1 ||
            branch_not_equal != 0) begin
            test_failed = 1;
            $error("TEST 14 FAILED: BEQ");
        end

        // ----------------------------------
        // TEST 15: BNE
        // ----------------------------------
        opcode = 7'b1100011;
        funct3 = 3'b001;

        #1;

        if (reg_write != 0 ||
            alu_src_a != 0 ||
            alu_src_b != 0 ||
            alu_ctrl != 4'b0001 ||
            branch != 0 ||
            branch_not_equal != 1) begin
            test_failed = 1;
            $error("TEST 15 FAILED: BNE");
        end

        // ----------------------------------
        // TEST 16: Invalid instruction
        // ----------------------------------
        opcode = 7'b1111111;
        funct3 = 3'b111;
        funct7 = 7'b1111111;

        #1;

        if (reg_write != 0 ||
            alu_src_a != 0 ||
            alu_src_b != 0 ||
            alu_ctrl != 4'b0000 ||
            mem_write != 0 ||
            writeback_select != 2'b00 ||
            branch != 0 ||
            branch_not_equal != 0 ||
            jump != 0 ||
            jump_register != 0) begin
            test_failed = 1;
            $error("TEST 16 FAILED: invalid instruction handling");
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