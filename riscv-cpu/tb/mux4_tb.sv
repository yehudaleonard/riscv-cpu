`timescale 1ns/1ps

module mux4_tb;

    logic [31:0] a;
    logic [31:0] b;
    logic [31:0] c;
    logic [31:0] d;
    logic [1:0]  sel;

    logic [31:0] y;

    logic test_failed;

    mux4 dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sel(sel),
        .y(y)
    );

    initial begin

        a = 0;
        b = 0;
        c = 0;
        d = 0;
        sel = 0;
        test_failed = 0;

        #1;

        // ----------------------------------
        // TEST 1: Select input A
        // ----------------------------------
        a   = 32'd123;
        b   = 32'd456;
        c   = 32'd789;
        d   = 32'd101112;
        sel = 2'b00;

        #1;

        if (y != 32'd123) begin
            test_failed = 1;
            $error("TEST 1 FAILED: sel=00 should select input A");
        end

        // ----------------------------------
        // TEST 2: Select input B
        // ----------------------------------
        sel = 2'b01;

        #1;

        if (y != 32'd456) begin
            test_failed = 1;
            $error("TEST 2 FAILED: sel=01 should select input B");
        end

        // ----------------------------------
        // TEST 3: Select input C
        // ----------------------------------
        sel = 2'b10;

        #1;

        if (y != 32'd789) begin
            test_failed = 1;
            $error("TEST 3 FAILED: sel=10 should select input C");
        end

        // ----------------------------------
        // TEST 4: Select input D
        // ----------------------------------
        sel = 2'b11;

        #1;

        if (y != 32'd101112) begin
            test_failed = 1;
            $error("TEST 4 FAILED: sel=11 should select input d");
        end

        // ----------------------------------
        // FINAL RESULT
        // ----------------------------------
        if (!test_failed)
            $display("ALL MUX4 TESTS PASSED");
        else
            $display("MUX4 TESTS FAILED");

        $finish;

    end

endmodule