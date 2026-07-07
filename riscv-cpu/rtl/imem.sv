`timescale 1ns/1ps

module imem #(
    parameter string MEM_FILE = "programs/basic_datapath.hex"
)(
    input  logic [31:0] address,
    output logic [31:0] instruction
);

    logic [31:0] memory [0:255];

    initial begin
        $readmemh(MEM_FILE, memory);
    end
    // 256 instructions -> use address[9:2]
    assign instruction = memory[address[9:2]];

endmodule