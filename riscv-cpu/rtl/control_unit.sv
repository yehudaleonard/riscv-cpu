`timescale 1ns/1ps

module control_unit(
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,

    output logic       reg_write,
    output logic       alu_src_a,
    output logic       alu_src_b,
    output logic [3:0] alu_ctrl,
    output logic       mem_write,
    output logic [1:0] writeback_select,
    output logic       branch,
    output logic       branch_not_equal,
    output logic       jump,
    output logic       jump_register
);

    // --------------------------------------------------
    // Opcode Definitions
    // --------------------------------------------------
    localparam logic [6:0] OPCODE_OP_IMM = 7'b0010011;
    localparam logic [6:0] OPCODE_LOAD   = 7'b0000011;
    localparam logic [6:0] OPCODE_JALR   = 7'b1100111;
    localparam logic [6:0] OPCODE_JAL    = 7'b1101111;
    localparam logic [6:0] OPCODE_LUI    = 7'b0110111;
    localparam logic [6:0] OPCODE_AUIPC  = 7'b0010111;
    localparam logic [6:0] OPCODE_STORE  = 7'b0100011;
    localparam logic [6:0] OPCODE_BRANCH = 7'b1100011;
    localparam logic [6:0] OPCODE_R_TYPE = 7'b0110011;

    // --------------------------------------------------
    // ALU Operations
    // --------------------------------------------------    
    localparam logic [3:0] ALU_ADD = 4'b0000;
    localparam logic [3:0] ALU_SUB = 4'b0001;
    localparam logic [3:0] ALU_AND = 4'b0010;
    localparam logic [3:0] ALU_OR  = 4'b0011;
    localparam logic [3:0] ALU_XOR = 4'b0100;
    localparam logic [3:0] ALU_SLT = 4'b0101;

    // --------------------------------------------------
    // Register file write-back source selection
    // --------------------------------------------------
    localparam logic [1:0] WB_ALU = 2'b00;
    localparam logic [1:0] WB_MEM = 2'b01;
    localparam logic [1:0] WB_PC4 = 2'b10;
    localparam logic [1:0] WB_IMM = 2'b11;


    always_comb begin

        // Default outputs
        reg_write        = 1'b0;
        alu_src_a        = 1'b0;    // reg_data1
        alu_src_b        = 1'b0;    // reg_data2
        mem_write        = 1'b0;
        writeback_select = WB_ALU;
        alu_ctrl         = ALU_ADD;
        branch           = 1'b0;
        branch_not_equal = 1'b0;
        jump             = 1'b0;
        jump_register    = 1'b0;

        case (opcode)

            // I-Type ADDI
            OPCODE_OP_IMM: begin

                case (funct3)

                    // ADDI
                    3'b000: begin
                        reg_write = 1'b1;
                        alu_src_b = 1'b1;   // Immediate
                        alu_ctrl  = ALU_ADD;
                    end

                endcase

            end

            // I-Type Load
            OPCODE_LOAD: begin

                case (funct3)

                    // LW
                    3'b010: begin
                        reg_write        = 1'b1;
                        alu_src_b        = 1'b1;    // Immediate
                        writeback_select = WB_MEM;
                        alu_ctrl         = ALU_ADD;
                    end

                endcase

            end

            // I-Type Jump Register
            OPCODE_JALR: begin

                case (funct3)

                    // JALR
                    3'b000: begin
                        reg_write        = 1'b1;
                        alu_src_b        = 1'b1;    // Immediate
                        alu_ctrl         = ALU_ADD;
                        writeback_select = WB_PC4;
                        jump_register    = 1'b1;
                    end

                endcase

            end

            // J-Type Jump
            OPCODE_JAL: begin
                reg_write        = 1'b1;
                jump             = 1'b1;
                writeback_select = WB_PC4;
            end

            // U-Type Load Upper Immediate
            OPCODE_LUI: begin
                reg_write        = 1'b1;
                writeback_select = WB_IMM;
            end

            // U-Type Add Upper Immediate to PC
            OPCODE_AUIPC: begin
                reg_write        = 1'b1;
                alu_src_a        = 1'b1;    // PC
                alu_src_b        = 1'b1;    // Immediate
                alu_ctrl         = ALU_ADD;
                writeback_select = WB_ALU;
            end

            // S-Type Store
            OPCODE_STORE: begin

                case (funct3)

                    // SW
                    3'b010: begin
                        alu_src_b = 1'b1;   // Immediate
                        mem_write = 1'b1;
                        alu_ctrl  = ALU_ADD;
                    end

                endcase

            end

            // B-Type Branch
            OPCODE_BRANCH: begin

                alu_src_b = 1'b0;    // reg_data2
                alu_ctrl  = ALU_SUB;

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
            OPCODE_R_TYPE: begin

                reg_write = 1'b1;

                case ({funct7, funct3})

                    // ADD
                    {7'b0000000, 3'b000}:
                        alu_ctrl = ALU_ADD;

                    // SUB
                    {7'b0100000, 3'b000}:
                        alu_ctrl = ALU_SUB;

                    // AND
                    {7'b0000000, 3'b111}:
                        alu_ctrl = ALU_AND;

                    // OR
                    {7'b0000000, 3'b110}:
                        alu_ctrl = ALU_OR;

                    // XOR
                    {7'b0000000, 3'b100}:
                        alu_ctrl = ALU_XOR;

                    // SLT
                    {7'b0000000, 3'b010}:
                        alu_ctrl = ALU_SLT;

                    default: begin
                        reg_write = 1'b0;
                        alu_ctrl  = ALU_ADD;
                    end

                endcase

            end

        endcase

    end

endmodule