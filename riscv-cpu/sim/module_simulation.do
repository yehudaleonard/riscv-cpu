# ============================================================
# Module-Level Simulation
# ============================================================

vlib work

# ============================================================
# Compile RTL Modules
# ============================================================

vlog rtl/alu.sv
vlog rtl/branch_unit.sv
vlog rtl/control_unit.sv
vlog rtl/decoder.sv
vlog rtl/dmem.sv
vlog rtl/imem.sv
vlog rtl/mux2.sv
vlog rtl/mux4.sv
vlog rtl/next_pc.sv
vlog rtl/pc.sv
vlog rtl/register_file.sv


# ============================================================
# Compile Module Testbenches
# ============================================================

vlog tb/alu_tb.sv
vlog tb/branch_unit_tb.sv
vlog tb/control_unit_tb.sv
vlog tb/decoder_tb.sv
vlog tb/dmem_tb.sv
vlog tb/imem_tb.sv
vlog tb/mux2_tb.sv
vlog tb/mux4_tb.sv
vlog tb/next_pc_tb.sv
vlog tb/pc_tb.sv
vlog tb/register_file_tb.sv


# ============================================================
# Run ALU Testbench
# ============================================================

echo ""
echo "========================================"
echo "Running ALU Testbench"
echo "========================================"

vsim -c work.alu_tb
run -all
quit -sim


# ============================================================
# Run Branch Unit Testbench
# ============================================================

echo ""
echo "========================================"
echo "Running Branch Unit Testbench"
echo "========================================"

vsim -c work.branch_unit_tb
run -all
quit -sim


# ============================================================
# Run Control Unit Testbench
# ============================================================

echo ""
echo "========================================"
echo "Running Control Unit Testbench"
echo "========================================"

vsim -c work.control_unit_tb
run -all
quit -sim


# ============================================================
# Run Decoder Testbench
# ============================================================

echo ""
echo "========================================"
echo "Running Decoder Testbench"
echo "========================================"

vsim -c work.decoder_tb
run -all
quit -sim


# ============================================================
# Run Data Memory Testbench
# ============================================================

echo ""
echo "========================================"
echo "Running Data Memory Testbench"
echo "========================================"

vsim -c work.dmem_tb
run -all
quit -sim


# ============================================================
# Run Instruction Memory Testbench
# ============================================================

echo ""
echo "========================================"
echo "Running Instruction Memory Testbench"
echo "========================================"

vsim -c work.imem_tb
run -all
quit -sim


# ============================================================
# Run MUX2 Testbench
# ============================================================

echo ""
echo "========================================"
echo "Running MUX2 Testbench"
echo "========================================"

vsim -c work.mux2_tb
run -all
quit -sim


# ============================================================
# Run MUX4 Testbench
# ============================================================

echo ""
echo "========================================"
echo "Running MUX4 Testbench"
echo "========================================"

vsim -c work.mux4_tb
run -all
quit -sim


# ============================================================
# Run Next PC Testbench
# ============================================================

echo ""
echo "========================================"
echo "Running Next PC Testbench"
echo "========================================"

vsim -c work.next_pc_tb
run -all
quit -sim


# ============================================================
# Run PC Testbench
# ============================================================

echo ""
echo "========================================"
echo "Running PC Testbench"
echo "========================================"

vsim -c work.pc_tb
run -all
quit -sim


# ============================================================
# Run Register File Testbench
# ============================================================

echo ""
echo "========================================"
echo "Running Register File Testbench"
echo "========================================"

vsim -c work.register_file_tb
run -all
quit -sim


# ============================================================
# Finished
# ============================================================

echo ""
echo "========================================"
echo "MODULE SIMULATION COMPLETE"
echo "========================================"