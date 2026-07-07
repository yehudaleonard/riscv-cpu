vsim -gMEM_FILE="programs/alu_operations.hex" work.cpu_tb

add wave sim:/cpu_tb/*
add wave sim:/cpu_tb/dut/*

run -all