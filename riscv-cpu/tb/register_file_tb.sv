`timescale 1ns/1ps

module register_file_tb;

    // DUT inputs
    logic clk;
    logic write_enable;

    logic [4:0] reg_source_1_address;
    logic [4:0] reg_source_2_address;
    logic [4:0] reg_destination;
    logic [31:0] reg_data;

    // DUT outputs
    logic [31:0] reg_source_1_data;
    logic [31:0] reg_source_2_data;

    logic test_failed;

    // DUT instance
    register_file dut (
        .clk(clk),
        .write_enable(write_enable),

        .reg_source_1_address(reg_source_1_address),
        .reg_source_2_address(reg_source_2_address),
        .reg_destination(reg_destination),
        .reg_data(reg_data),

        .reg_source_1_data(reg_source_1_data),
        .reg_source_2_data(reg_source_2_data)
    );

    // clock generation (10ns period)
    always #5 clk = ~clk;

    initial begin

        // init
        clk = 0;
        write_enable = 0;
        reg_destination = 0;
        reg_data = 0;
        reg_source_1_address = 0;
        reg_source_2_address = 0;

        test_failed = 0;

        #10;

        // --------------------------------------------------
        // TEST 1: write and read back
        // --------------------------------------------------
        reg_destination = 5;
        reg_data = 32'h1234ABCD;
        write_enable = 1;

        #10;

        write_enable = 0;

        reg_source_1_address = 5;
        #1;

        if (reg_source_1_data != 32'h1234ABCD) begin
            $error("TEST 1 FAILED: write/read mismatch");
            test_failed = 1;
        end

        // --------------------------------------------------
        // TEST 2: independent registers
        // --------------------------------------------------
        reg_destination = 10;
        reg_data = 32'hDEADBEEF;
        write_enable = 1;

        #10;
        write_enable = 0;

        reg_source_1_address = 10;
        #1;

        if (reg_source_1_data != 32'hDEADBEEF) begin
            $error("TEST 2 FAILED: register independence broken");
            test_failed = 1;
        end

        // --------------------------------------------------
        // TEST 3: x0 must stay zero
        // --------------------------------------------------
        reg_destination = 0;
        reg_data = 32'hFFFFFFFF;
        write_enable = 1;

        #10;
        write_enable = 0;

        reg_source_1_address = 0;
        #1;

        if (reg_source_1_data != 0) begin
            $error("TEST 3 FAILED: x0 modified");
            test_failed = 1;
        end

        // --------------------------------------------------
        // TEST 4: dual read test
        // --------------------------------------------------
        reg_source_1_address = 5;
        reg_source_2_address = 10;

        #1;

        if (reg_source_1_data != 32'h1234ABCD ||
            reg_source_2_data != 32'hDEADBEEF) begin
            $error("TEST 4 FAILED: dual read incorrect");
            test_failed = 1;
        end

        // --------------------------------------------------
        // TEST 5: write_enable must block writes
        // --------------------------------------------------
        reg_destination = 5;
        reg_data = 32'hA7541999;
        write_enable = 0;

        #10;

        reg_source_1_address = 5;
        #1;

        if (reg_source_1_data != 32'h1234ABCD) begin
            $error("TEST 5 FAILED: write occurred while write_enable=0");
            test_failed = 1;
        end

        // --------------------------------------------------
        // FINAL RESULT
        // --------------------------------------------------
        if (!test_failed)
            $display("ALL REGISTER FILE TESTS PASSED");
        else
            $display("REGISTER FILE TESTS FAILED");

        $finish;

    end

endmodule