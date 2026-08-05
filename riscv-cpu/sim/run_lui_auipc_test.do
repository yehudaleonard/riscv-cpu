vsim -gMEM_FILE="programs/lui_auipc_test.hex" work.cpu_tb

add wave sim:/cpu_tb/*
add wave sim:/cpu_tb/dut/*

run -all