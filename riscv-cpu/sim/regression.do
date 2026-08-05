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

do sim/run_sw_test.do

do sim/run_lw_test.do

do sim/run_load_store_test.do

do sim/run_branch_test.do

do sim/run_lui_auipc_test.do


echo ""
echo "========================================"
echo "CPU Regression Complete"
echo "========================================"