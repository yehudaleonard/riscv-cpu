`timescale 1ns/1ps

module imem_tb;

    logic [31:0] address;
    logic [31:0] instruction;

    logic test_failed;

    imem dut (
        .address(address),
        .instruction(instruction)
    );

    initial begin

        test_failed = 0;

        // ----------------------------------
        // Initialize memory (test program)
        // ----------------------------------
        // memory[0] = addi x1, x0, 5
        // memory[1] = addi x2, x0, 10
        // memory[2] = add  x3, x1, x2

        dut.memory[0] = 32'h00500093;
        dut.memory[1] = 32'h00A00113;
        dut.memory[2] = 32'h002081B3;

        // ----------------------------------
        // TEST 1: Fetch instruction 0
        // ----------------------------------
        address = 0;
        #1;

        if (instruction != 32'h00500093) begin
            $error("TEST 1 FAILED: wrong instruction at address 0");
            test_failed = 1;
        end

        // ----------------------------------
        // TEST 2: Fetch instruction 1
        // ----------------------------------
        address = 4;
        #1;

        if (instruction != 32'h00A00113) begin
            $error("TEST 2 FAILED: wrong instruction at address 4");
            test_failed = 1;
        end

        // ----------------------------------
        // TEST 3: Fetch instruction 2
        // ----------------------------------
        address = 8;
        #1;

        if (instruction != 32'h002081B3) begin
            $error("TEST 3 FAILED: wrong instruction at address 8");
            test_failed = 1;
        end

        // ----------------------------------
        // FINAL RESULT
        // ----------------------------------
        if (!test_failed)
            $display("ALL IMEM TESTS PASSED");
        else
            $display("IMEM TESTS FAILED");

        $finish;
    end

endmodule