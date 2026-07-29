`timescale 1ns/1ps

module control_unit(
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,

    output logic       reg_write,
    output logic       alu_src,
    output logic [3:0] alu_ctrl,
    output logic       mem_write,
    output logic [1:0] writeback_select,
    output logic       branch,
    output logic       branch_not_equal,
    output logic       jump,
    output logic       jump_register
);
    // Register file write-back source selection
    localparam logic [1:0] WB_ALU = 2'b00;
    localparam logic [1:0] WB_MEM = 2'b01;
    localparam logic [1:0] WB_PC4 = 2'b10;

    always_comb begin

        // Default outputs
        reg_write        = 1'b0;
        alu_src          = 1'b0;
        mem_write        = 1'b0;
        writeback_select = WB_ALU;
        alu_ctrl         = 4'b0000;
        branch           = 1'b0;
        branch_not_equal = 1'b0;
        jump             = 1'b0;
        jump_register    = 1'b0;

        case (opcode)

            // I-Type ADDI
            7'b0010011: begin

                case (funct3)

                    // ADDI
                    3'b000: begin
                        reg_write = 1'b1;
                        alu_src   = 1'b1;
                        alu_ctrl  = 4'b0000;
                    end

                endcase

            end

            // I-Type Load
            7'b0000011: begin

                case (funct3)

                    // LW
                    3'b010: begin
                        reg_write        = 1'b1;
                        alu_src          = 1'b1;
                        writeback_select = WB_MEM;
                        alu_ctrl         = 4'b0000;
                    end

                endcase

            end

            // I-Type Jump Register
            7'b1100111: begin

                case (funct3)

                    // JALR
                    3'b000: begin
                        reg_write        = 1'b1;
                        alu_src          = 1'b1;
                        alu_ctrl         = 4'b0000; // ADD
                        writeback_select = WB_PC4;
                        jump_register    = 1'b1;
                    end

                endcase

            end

            // J-Type Jump
            7'b1101111: begin
                reg_write        = 1'b1;
                jump             = 1'b1;
                writeback_select = WB_PC4;
            end

            // S-Type Store
            7'b0100011: begin

                case (funct3)

                    // SW
                    3'b010: begin
                        alu_src   = 1'b1;
                        mem_write = 1'b1;
                        alu_ctrl  = 4'b0000;
                    end

                endcase

            end

            // B-Type Branch
            7'b1100011: begin

                alu_src = 1'b0;
                alu_ctrl = 4'b0001;   // SUB

                case (funct3)

                    // BEQ
                    3'b000:
                        branch = 1'b1;

                    // BNE
                    3'b001:
                        branch_not_equal = 1'b1;

                endcase

            end

            // R-Type
            7'b0110011: begin

                reg_write = 1'b1;

                case ({funct7, funct3})

                    // ADD
                    {7'b0000000, 3'b000}:
                        alu_ctrl = 4'b0000;

                    // SUB
                    {7'b0100000, 3'b000}:
                        alu_ctrl = 4'b0001;

                    // AND
                    {7'b0000000, 3'b111}:
                        alu_ctrl = 4'b0010;

                    // OR
                    {7'b0000000, 3'b110}:
                        alu_ctrl = 4'b0011;

                    // XOR
                    {7'b0000000, 3'b100}:
                        alu_ctrl = 4'b0100;

                    // SLT
                    {7'b0000000, 3'b010}:
                        alu_ctrl = 4'b0101;

                    default: begin
                        reg_write = 1'b0;
                        alu_ctrl  = 4'b0000;
                    end

                endcase

            end

        endcase

    end

endmodule