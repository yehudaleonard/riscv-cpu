`timescale 1ns/1ps

module branch_unit (
    input logic branch,
    input logic branch_not_equal,
    input logic zero,

    output logic take_branch
);

assign take_branch =
       (branch && zero)
    || (branch_not_equal && !zero);

endmodule