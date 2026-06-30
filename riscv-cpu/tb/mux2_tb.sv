`timescale 1ns/1ps

module mux2_tb;

    logic [31:0] a;
    logic [31:0] b;
    logic        sel;

    logic [31:0] y;

    logic test_failed;

    mux2 dut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );

    initial begin

        a = 0;
        b = 0;
        sel = 0;
        test_failed = 0;

        #1;

        // ----------------------------------
        // TEST 1: Select input A
        // ----------------------------------
        a   = 32'd123;
        b   = 32'd456;
        sel = 1'b0;

        #1;

        if (y != 32'd123) begin
            test_failed = 1;
            $error("TEST 1 FAILED: sel=0 should select input A");
        end

        // ----------------------------------
        // TEST 2: Select input B
        // ----------------------------------
        sel = 1'b1;

        #1;

        if (y != 32'd456) begin
            test_failed = 1;
            $error("TEST 2 FAILED: sel=1 should select input B");
        end

        // ----------------------------------
        // FINAL RESULT
        // ----------------------------------
        if (!test_failed)
            $display("ALL MUX2 TESTS PASSED");
        else
            $display("MUX2 TESTS FAILED");

        $finish;

    end

endmodule