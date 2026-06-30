`timescale 1ns/1ps

module cpu_tb;

    logic clk;
    logic reset;

    logic test_failed;

    cpu dut (
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
            // Load Program
            // ----------------------------
            dut.imem_inst.memory[0] = 32'h00500093; // addi x1, x0, 5
            dut.imem_inst.memory[1] = 32'h00A00113; // addi x2, x0, 10
            dut.imem_inst.memory[2] = 32'h002081B3; // add  x3, x1, x2

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
            // Load Program
            // ----------------------------
            dut.imem_inst.memory[0] = 32'h01400093; // addi x1, x0, 20
            dut.imem_inst.memory[1] = 32'h00700113; // addi x2, x0, 7

            dut.imem_inst.memory[2] = 32'h402081B3; // sub  x3, x1, x2
            dut.imem_inst.memory[3] = 32'h0020F233; // and  x4, x1, x2
            dut.imem_inst.memory[4] = 32'h0020E2B3; // or   x5, x1, x2
            dut.imem_inst.memory[5] = 32'h0020C333; // xor  x6, x1, x2

            // ----------------------------
            // Execute Program
            // ----------------------------
            run_cycles(6);

            // ----------------------------
            // Verify Results
            // ----------------------------
            check_reg(1, 32'd20);
            check_reg(2, 32'd7);
            check_reg(3, 32'd13);
            check_reg(4, 32'd4);
            check_reg(5, 32'd23);
            check_reg(6, 32'd19);

            check_pc(32'd24);
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
            // Load Program
            // ----------------------------
            dut.imem_inst.memory[0] = 32'hFFB00093; // addi x1, x0, -5
            dut.imem_inst.memory[1] = 32'h00300113; // addi x2, x0, 3
            dut.imem_inst.memory[2] = 32'h0020A1B3; // slt  x3, x1, x2
            dut.imem_inst.memory[3] = 32'h00208233; // add  x4, x1, x2

            // ----------------------------
            // Execute Program
            // ----------------------------
            run_cycles(4);

            // ----------------------------
            // Verify Results
            // ----------------------------
            check_reg(1, 32'hFFFF_FFFB); // -5
            check_reg(2, 32'd3);
            check_reg(3, 32'd1);
            check_reg(4, 32'hFFFF_FFFE); // -2

            check_pc(32'd16);
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
            // Load Program
            // ----------------------------
            dut.imem_inst.memory[0] = 32'h07B00013; // addi x0, x0, 123
            dut.imem_inst.memory[1] = 32'h00500093; // addi x1, x0, 5
            dut.imem_inst.memory[2] = 32'h00008133; // add  x2, x1, x0

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

    initial begin
        clk = 0;
        reset = 0;
        test_failed = 0;

        test_basic_datapath();
        test_alu_operations();
        test_signed_operations();
        test_x0_protection();

        $display("\n========================================");

        if (test_failed)
            $display("TEST RESULT: FAILED");
        else
            $display("ALL CPU TESTS PASSED");

        $display("========================================\n");

        $finish;
    end

endmodule