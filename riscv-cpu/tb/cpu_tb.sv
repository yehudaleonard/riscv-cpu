`timescale 1ns/1ps

module cpu_tb #(
    parameter string MEM_FILE = "programs/basic_datapath.hex"
);

    logic clk;
    logic reset;

    logic test_failed;

    cpu #(
        .MEM_FILE(MEM_FILE)
    ) dut (
        .clk(clk),
        .reset(reset)
    );

    // --------------------------
    // Clock generation
    // --------------------------
    always #5 clk = ~clk;

    // --------------------------------------------------
    // Reset CPU
    // --------------------------------------------------
    task reset_cpu();
        begin
            reset = 1'b1;

            @(posedge clk);

            reset = 1'b0;
        end
    endtask

    // --------------------------------------------------
    // Run N cycles
    // --------------------------------------------------
    task run_cycles(input int cycles);
        repeat (cycles)
            @(posedge clk);
            #1;
    endtask

    // --------------------------------------------------
    // Check Register File
    // --------------------------------------------------
    task check_reg(input int reg_num, input logic [31:0] expected);
        logic [31:0] actual;

        actual = dut.rf_inst.regs[reg_num];

        if (actual !== expected) begin
            $error("REG CHECK FAILED: x%0d expected %0d (0x%08h), got %0d (0x%08h)",
                reg_num, expected, expected, actual, actual);

            test_failed = 1;
        end
        else begin
            $display("REG CHECK PASSED: x%0d = %0d (0x%08h)",
                    reg_num, actual, actual);
        end
    endtask

    // --------------------------------------------------
    // Check Data Memory
    // --------------------------------------------------
    task check_mem(input logic [31:0] address,
                input logic [31:0] expected);

        logic [31:0] actual;

        actual = dut.dmem_inst.memory[address[9:2]];

        if (actual !== expected) begin
            $error("MEM CHECK FAILED: addr 0x%08h expected %0d (0x%08h), got %0d (0x%08h)",
                address, expected, expected,
                actual, actual);

            test_failed = 1;
        end
        else begin
            $display("MEM CHECK PASSED: addr 0x%08h = %0d (0x%08h)",
                address, actual, actual);
        end

    endtask

    // --------------------------------------------------
    // Check Program Counter
    // --------------------------------------------------
    task check_pc(input logic [31:0] expected);

        if (dut.pc !== expected) begin
            $error("PC CHECK FAILED: expected 0x%08h, got 0x%08h",
                expected, dut.pc);

            test_failed = 1;
        end
        else begin
            $display("PC CHECK PASSED: 0x%08h", dut.pc);
        end

    endtask

    // --------------------------------------------------
    // Test - Basic Datapath
    // --------------------------------------------------
    task test_basic_datapath();
        begin
            $display("\n========================================");
            $display("Running Test 1 - Basic Datapath");
            $display("========================================");

            reset_cpu();

            // ----------------------------
            // Execute Program
            // ----------------------------
            run_cycles(3);

            // ----------------------------
            // Verify Results
            // ----------------------------
            check_reg(1, 32'd5);
            check_reg(2, 32'd10);
            check_reg(3, 32'd15);

            check_pc(32'd12);
        end
    endtask

    // --------------------------------------------------
    // Test - ALU Operations
    // --------------------------------------------------
    task test_alu_operations();
        begin
            $display("\n========================================");
            $display("Running Test 2 - ALU Operations");
            $display("========================================");

            reset_cpu();

            // ----------------------------
            // Execute Program
            // ----------------------------
            run_cycles(8);

            // ----------------------------
            // Verify Results
            // ----------------------------
            check_reg(1, 32'd15);
            check_reg(2, 32'd5);
            check_reg(3, 32'd20);
            check_reg(4, 32'd10);
            check_reg(5, 32'd5);
            check_reg(6, 32'd15);
            check_reg(7, 32'd10);
            check_reg(8, 32'd1);

            check_pc(32'd32);
        end
    endtask

    // --------------------------------------------------
    // Test - Signed Operations
    // --------------------------------------------------
    task test_signed_operations();
        begin
            $display("\n========================================");
            $display("Running Test 3 - Signed Operations");
            $display("========================================");

            reset_cpu();

            // ----------------------------
            // Execute Program
            // ----------------------------
            run_cycles(6);

            // ----------------------------
            // Verify Results
            // ----------------------------
            check_reg(1, 32'hFFFF_FFFB); // -5
            check_reg(2, 32'd5);
            check_reg(3, 32'd0);
            check_reg(4, 32'hFFFF_FFF6); // -10
            check_reg(5, 32'd1);
            check_reg(6, 32'd0);

            check_pc(32'd24);
        end
    endtask

    // --------------------------------------------------
    // Test - x0 Protection
    // --------------------------------------------------
    task test_x0_protection();
        begin
            $display("\n========================================");
            $display("Running Test 4 - x0 Protection");
            $display("========================================");

            reset_cpu();

            // ----------------------------
            // Execute Program
            // ----------------------------
            run_cycles(3);

            // ----------------------------
            // Verify Results
            // ----------------------------
            check_reg(1, 32'd5);
            check_reg(2, 32'd5);

            check_pc(32'd12);
        end
    endtask

    // --------------------------------------------------
    // Test - Store (SW)
    // --------------------------------------------------
    task test_store();
        begin
            $display("\n========================================");
            $display("Running Test 5 - Store (SW)");
            $display("========================================");

            reset_cpu();

            // ----------------------------
            // Execute Program
            // ----------------------------
            run_cycles(3);

            // ----------------------------
            // Verify Results
            // ----------------------------
            check_mem(32'd16, 32'd42);

            check_pc(32'd12);
        end
    endtask

    // --------------------------------------------------
    // Test - Load (LW)
    // --------------------------------------------------
    task test_load();
        begin
            $display("\n========================================");
            $display("Running Test 6 - Load (LW)");
            $display("========================================");

            // Preload memory location:
            // address 16 -> memory[4]
            dut.dmem_inst.memory[4] = 32'd123;

            reset_cpu();

            // ----------------------------
            // Execute Program
            // ----------------------------
            run_cycles(2);

            // ----------------------------
            // Verify Results
            // ----------------------------
            check_reg(3, 32'd123);

            check_pc(32'd8);
        end
    endtask

    // --------------------------------------------------
    // Test - Load / Store
    // --------------------------------------------------
    task test_load_store();
        begin
            $display("\n========================================");
            $display("Running Test 7 - Load / Store");
            $display("========================================");

            reset_cpu();

            // ----------------------------
            // Execute Program
            // ----------------------------
            run_cycles(4);

            // ----------------------------
            // Verify Results
            // ----------------------------
            check_mem(32'd16, 32'd99);
            check_reg(3, 32'd99);

            check_pc(32'd16);
        end
    endtask

    initial begin
        clk = 0;
        reset = 0;
        test_failed = 0;

        if (MEM_FILE == "programs/basic_datapath.hex")
            test_basic_datapath();

        else if (MEM_FILE == "programs/alu_operations.hex")
            test_alu_operations();

        else if (MEM_FILE == "programs/signed_operations.hex")
            test_signed_operations();

        else if (MEM_FILE == "programs/x0_protection.hex")
            test_x0_protection();

        else if (MEM_FILE == "programs/sw_test.hex")
            test_store();

        else if (MEM_FILE == "programs/lw_test.hex")
            test_load();

        else if (MEM_FILE == "programs/load_store_test.hex")
            test_load_store();

        else begin
            $error("Unknown MEM_FILE = %s", MEM_FILE);
            test_failed = 1;
        end

        $display("\n========================================");

        if (test_failed)
            $display("TEST RESULT: FAILED");
        else
            $display("CPU TEST PASSED");

        $display("========================================\n");

        $finish;
    end

endmodule