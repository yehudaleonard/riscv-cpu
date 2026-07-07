`timescale 1ns/1ps

module cpu #(
    parameter string MEM_FILE = "programs/basic_datapath.hex"
)(
    input logic clk,
    input logic reset
);

    // --------------------------------------------------
    // PC
    // --------------------------------------------------
    logic [31:0] pc;
    logic [31:0] pc_next;

    // --------------------------------------------------
    // Instruction Fetch
    // --------------------------------------------------
    logic [31:0] instruction;

    // --------------------------------------------------
    // Decoder Outputs
    // --------------------------------------------------
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rd;

    logic [31:0] imm;

    // --------------------------------------------------
    // Control Unit Outputs
    // --------------------------------------------------
    logic       reg_write;
    logic       alu_src;
    logic [3:0] alu_ctrl;

    // --------------------------------------------------
    // Register File
    // --------------------------------------------------
    logic [31:0] reg_data1;
    logic [31:0] reg_data2;

    // --------------------------------------------------
    // ALU Path
    // --------------------------------------------------
    logic [31:0] alu_in2;
    logic [31:0] alu_result;

    logic zero;

    // --------------------------------------------------
    // Next PC Logic
    // --------------------------------------------------
    assign pc_next = pc + 32'd4;

    // --------------------------------------------------
    // Program Counter
    // --------------------------------------------------
    pc pc_inst (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc)
    );

    // --------------------------------------------------
    // Instruction Memory
    // --------------------------------------------------
    imem #(
        .MEM_FILE(MEM_FILE)
    ) imem_inst (
        .address(pc),
        .instruction(instruction)
    );

    // --------------------------------------------------
    // Decoder
    // --------------------------------------------------
    decoder decoder_inst (
        .instruction(instruction),

        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),

        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),

        .imm(imm)
    );

    // --------------------------------------------------
    // Control Unit
    // --------------------------------------------------
    control_unit cu_inst (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),

        .reg_write(reg_write),
        .alu_src(alu_src),
        .alu_ctrl(alu_ctrl)
    );

    // --------------------------------------------------
    // Register File
    // --------------------------------------------------
    register_file rf_inst (
        .clk(clk),
        .write_enable(reg_write),

        .reg_source_1_address(rs1),
        .reg_source_2_address(rs2),

        .reg_destination(rd),
        .reg_data(alu_result),

        .reg_source_1_data(reg_data1),
        .reg_source_2_data(reg_data2)
    );

    // --------------------------------------------------
    // ALU Source MUX
    // --------------------------------------------------
    mux2 alu_mux (
        .a(reg_data2),
        .b(imm),
        .sel(alu_src),
        .y(alu_in2)
    );

    // --------------------------------------------------
    // ALU
    // --------------------------------------------------
    alu alu_inst (
        .a(reg_data1),
        .b(alu_in2),
        .alu_ctrl(alu_ctrl),

        .result(alu_result),
        .zero(zero)
    );

endmodule