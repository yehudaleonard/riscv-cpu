`timescale 1ns / 1ps

module dmem
(
    input  logic        clk,
    input  logic        write_enable,
    input  logic [31:0] address,
    input  logic [31:0] write_data,

    output logic [31:0] read_data
);

    // 256 words of 32-bit data memory.
    logic [31:0] memory [0:255];

    // Asynchronous read.
    assign read_data = memory[address[9:2]];

    // Synchronous write.
    always_ff @(posedge clk) begin
        if (write_enable)
            memory[address[9:2]] <= write_data;
    end

endmodule