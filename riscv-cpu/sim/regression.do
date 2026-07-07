cd C:/Users/shayn/levi/riscv-cpu

do sim/compile.do

echo ""
echo "========================================"
echo "Running Full CPU Regression"
echo "========================================"

do sim/run_basic_datapath.do

do sim/run_alu_operations.do

do sim/run_signed_operations.do

do sim/run_x0_protection.do

echo ""
echo "========================================"
echo "CPU Regression Complete"
echo "========================================"