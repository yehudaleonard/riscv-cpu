`timescale 1ns/1ps

module next_pc(
    input logic [31:0] pc,
    input logic [31:0] imm,
    input logic [31:0] jalr_target,
    input logic        take_branch,
    input logic        jump,
    input logic        jump_register,

    output logic [31:0] pc_next,
    output logic [31:0] pc_plus4
);

always_comb begin

    pc_plus4 = pc + 32'd4;

    if (jump_register) begin
        pc_next = {jalr_target[31:1], 1'b0};
    end

    else if (jump || take_branch) begin
        pc_next = pc + imm;
    end

    else begin
        pc_next = pc_plus4;
    end

end

endmodule