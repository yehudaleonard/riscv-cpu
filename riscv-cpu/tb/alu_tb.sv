`timescale 1ns/1ps

module alu_tb;

logic [31:0] a;
logic [31:0] b;
logic [3:0]  alu_ctrl;

logic [31:0] result;
logic        zero;

alu dut (
.a(a),
.b(b),
.alu_ctrl(alu_ctrl),
.result(result),
.zero(zero)
);

initial begin

a = 0;
b = 0;
alu_ctrl = 0;

#1;

// ADD
a = 10;
b = 5;
alu_ctrl = 4'b0000;
#10;

if (result != 15)
    $error("ADD failed");

// SUB
a = 10;
b = 5;
alu_ctrl = 4'b0001;
#10;

if (result != 5)
    $error("SUB failed");

// AND
a = 32'hF0F0;
b = 32'h0FF0;
alu_ctrl = 4'b0010;
#10;

if (result != 32'h00F0)
    $error("AND failed");

// OR
a = 32'hF0F0;
b = 32'h0FF0;
alu_ctrl = 4'b0011;
#10;

if (result != 32'hFFF0)
    $error("OR failed");

// XOR
a = 32'hAAAA;
b = 32'h5555;
alu_ctrl = 4'b0100;
#10;

if (result != 32'hFFFF)
    $error("XOR failed");

// SLT
a = 3;
b = 5;
alu_ctrl = 4'b0101;
#10;

if (result != 1)
    $error("SLT failed");

$display("ALL TESTS PASSED");

$finish;

end

endmodule
