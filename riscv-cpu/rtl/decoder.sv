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

            // I-Type Immediate (ADDI, LW, JALR)
            OPCODE_OP_IMM,
            OPCODE_LOAD,
            OPCODE_JALR:
                imm = {{20{instruction[31]}},
                       instruction[31:20]};

            // J-Type Immediate (JAL)
            OPCODE_JAL:
                imm = {{11{instruction[31]}},
                    instruction[31],      // imm[20]
                    instruction[19:12],   // imm[19:12]
                    instruction[20],      // imm[11]
                    instruction[30:21],   // imm[10:1]
                    1'b0};                // imm[0]

            // U-Type Immediate (LUI, AUIPC)
            OPCODE_LUI,
            OPCODE_AUIPC:
                imm = {instruction[31:12],
                       12'b0};

            // S-Type Immediate (SW)
            OPCODE_STORE:
                imm = {{20{instruction[31]}},
                       instruction[31:25],
                       instruction[11:7]};

            // B-Type Immediate (BEQ, BNE)
            OPCODE_BRANCH:
                imm = {{19{instruction[31]}},
                    instruction[31],      // imm[12]
                    instruction[7],       // imm[11]
                    instruction[30:25],   // imm[10:5]
                    instruction[11:8],    // imm[4:1]
                    1'b0};                // imm[0]

            default:
                imm = 32'b0;

        endcase

    end

endmodule