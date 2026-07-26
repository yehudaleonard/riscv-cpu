`timescale 1ns/1ps

module next_pc (
    input logic [31:0] pc,
    input logic [31:0] imm,
    input logic        take_branch,

    output logic [31:0] pc_next
);

always_comb begin

    if (take_branch)
        pc_next = pc + imm;

    else
        pc_next = pc + 32'd4;

end

endmodule