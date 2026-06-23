`timescale 1ns/1ps

module control_unit(
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,

    output logic       reg_write,
    output logic       alu_src,
    output logic [3:0] alu_ctrl
);

    always_comb begin

        // Default outputs
        reg_write = 1'b0;
        alu_src   = 1'b0;
        alu_ctrl  = 4'b0000;

        case (opcode)

            // I-Type
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

            // R-Type
            7'b0110011: begin

                reg_write = 1'b1;
                alu_src   = 1'b0;

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