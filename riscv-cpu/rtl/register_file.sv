`timescale 1ns/1ps

module register_file(
    input logic clk,
    input logic write_enable,

    input logic [4:0] reg_source_1_address,
    input logic [4:0] reg_source_2_address,
    input logic [4:0] reg_destination,
    input logic [31:0] reg_data,

    output logic [31:0] reg_source_1_data,
    output logic [31:0] reg_source_2_data
);

logic [31:0] regs [0:31];

assign reg_source_1_data =
    (reg_source_1_address == 5'd0) ? 32'd0 : regs[reg_source_1_address];

assign reg_source_2_data =
    (reg_source_2_address == 5'd0) ? 32'd0 : regs[reg_source_2_address];

always_ff @(posedge clk) begin
    if (write_enable && reg_destination != 5'd0) begin
        regs[reg_destination] <= reg_data;
    end
end

endmodule