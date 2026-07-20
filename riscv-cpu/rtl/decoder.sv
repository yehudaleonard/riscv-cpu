`timescale 1ns/1ps

module decoder(
    input logic [31:0] instruction,

    output logic [6:0] opcode,
    output logic [2:0] funct3,
    output logic [6:0] funct7,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [4:0] rd,

    output logic [31:0] imm
);

    // Common fields
    assign opcode = instruction[6:0];

    assign rd     = instruction[11:7];
    assign funct3 = instruction[14:12];

    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];

    assign funct7 = instruction[31:25];

    // Immediate generation
    always_comb begin

        case (opcode)

            // I-Type Immediate (ADDI, LW)
            7'b0010011,
            7'b0000011:
                imm = {{20{instruction[31]}},
                       instruction[31:20]};

            // S-Type Immediate (SW)
            7'b0100011:
                imm = {{20{instruction[31]}},
                       instruction[31:25],
                       instruction[11:7]};

            default:
                imm = 32'b0;

        endcase

    end

endmodule