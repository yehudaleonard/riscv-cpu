`timescale 1ns/1ps

module cpu #(
    parameter string MEM_FILE = "programs/basic_datapath.hex"
)(
    input logic clk,
    input logic reset
);

    // --------------------------------------------------
    // Program Counter
    // --------------------------------------------------
    logic [31:0] pc;
    logic [31:0] pc_next;
    logic [31:0] pc_plus4;

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
    // Control Signals
    // --------------------------------------------------
    logic       reg_write;
    logic       alu_src;
    logic       mem_write;
    logic [3:0] alu_ctrl;
    logic [1:0] writeback_select;

    logic       branch;
    logic       branch_not_equal;
    logic       jump;
    logic       jump_register;

    // --------------------------------------------------
    // Register File
    // --------------------------------------------------
    logic [31:0] reg_data1;
    logic [31:0] reg_data2;
    logic [31:0] write_back_data;

    // --------------------------------------------------
    // ALU
    // --------------------------------------------------
    logic [31:0] alu_in2;
    logic [31:0] alu_result;
    logic        zero;

    // --------------------------------------------------
    // Branch Control
    // --------------------------------------------------
    logic take_branch;

    // --------------------------------------------------
    // Data Memory
    // --------------------------------------------------
    logic [31:0] read_data;

    // --------------------------------------------------
    // Next PC
    // --------------------------------------------------
    next_pc next_pc_inst (
        .pc(pc),
        .imm(imm),
        .jalr_target(alu_result),
        .take_branch(take_branch),
        .jump(jump),
        .jump_register(jump_register),

        .pc_next(pc_next),
        .pc_plus4(pc_plus4)
    );
    
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
        .mem_write(mem_write),
        .writeback_select(writeback_select),
        .alu_ctrl(alu_ctrl),
        .branch(branch),
        .branch_not_equal(branch_not_equal),
        .jump(jump),
        .jump_register(jump_register)
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
        .reg_data(write_back_data),

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

    // --------------------------------------------------
    // Branch Unit
    // --------------------------------------------------
    branch_unit branch_unit_inst (
        .branch(branch),
        .branch_not_equal(branch_not_equal),
        .zero(zero),

        .take_branch(take_branch)
    );

    // --------------------------------------------------
    // Data Memory
    // --------------------------------------------------
    dmem dmem_inst (
        .clk(clk),
        .write_enable(mem_write),
        .address(alu_result),
        .write_data(reg_data2),
        
        .read_data(read_data)
    );

    // --------------------------------------------------
    // Write-Back MUX
    // --------------------------------------------------
    mux3 write_back_mux (
        .a(alu_result),
        .b(read_data),
        .c(pc_plus4),
        .sel(writeback_select),
        .y(write_back_data)
    );

endmodule