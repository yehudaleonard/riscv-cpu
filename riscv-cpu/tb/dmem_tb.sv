`timescale 1ns / 1ps

module dmem_tb;

    logic        clk;
    logic        write_enable;
    logic [31:0] address;
    logic [31:0] write_data;
    logic [31:0] read_data;

    logic test_failed;

    dmem dut (
        .clk(clk),
        .write_enable(write_enable),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );

    // --------------------------
    // Clock generation
    // --------------------------
    always #5 clk = ~clk;

    //--------------------------------------------------------------------------
    // Helper Tasks
    //--------------------------------------------------------------------------

    task automatic check_data(
        input logic [31:0] expected
    );
    begin
        if (read_data !== expected) begin
            $display("ERROR: Expected 0x%08h, Got 0x%08h", expected, read_data);
            test_failed = 1;
        end
        else begin
            $display("PASS: Read 0x%08h", read_data);
        end
    end
    endtask

    //--------------------------------------------------------------------------
    // Test Sequence
    //--------------------------------------------------------------------------

    initial begin

        clk = 0;
        write_enable = 0;
        address      = 0;
        write_data   = 0;
        test_failed = 0;

        //----------------------------------------------------------------------
        // Test 1 : Single Write / Read
        //----------------------------------------------------------------------

        $display("\n========================================");
        $display("Running Test 1 - Single Write / Read");
        $display("========================================");

        address      = 32'h00000000;
        write_data   = 32'h12345678;
        write_enable = 1;

        @(posedge clk);

        write_enable = 0;

        #1;
        check_data(32'h12345678);

        //----------------------------------------------------------------------
        // Test 2 : Multiple Addresses
        //----------------------------------------------------------------------

        $display("\n========================================");
        $display("Running Test 2 - Multiple Addresses");
        $display("========================================");

        address = 32'h00000004;
        write_data = 32'hAAAAAAAA;
        write_enable = 1;
        @(posedge clk);

        address = 32'h00000008;
        write_data = 32'h55555555;
        @(posedge clk);

        write_enable = 0;

        address = 32'h00000004;
        #1;
        check_data(32'hAAAAAAAA);

        address = 32'h00000008;
        #1;
        check_data(32'h55555555);

        //----------------------------------------------------------------------
        // Test 3 : Overwrite
        //----------------------------------------------------------------------

        $display("\n========================================");
        $display("Running Test 3 - Overwrite");
        $display("========================================");    

        address = 32'h00000004;
        write_data = 32'hCAFEBABE;
        write_enable = 1;

        @(posedge clk);

        write_enable = 0;

        #1;
        check_data(32'hCAFEBABE);

        //----------------------------------------------------------------------
        // Test 4 : Write Disable
        //----------------------------------------------------------------------

        $display("\n========================================");
        $display("Running Test 4 - Write Disabled");
        $display("========================================");

        address = 32'h00000004;
        write_data = 32'hFFFFFFFF;
        write_enable = 0;

        @(posedge clk);

        #1;
        check_data(32'hCAFEBABE);

        //----------------------------------------------------------------------
        // Final Result
        //----------------------------------------------------------------------

        $display("\n========================================");

        if (test_failed)
            $display("\nDMEM TEST FAILED");
        else
            $display("\nALL DMEM TESTS PASSED");

        $display("========================================\n");

        $finish;

    end

endmodule