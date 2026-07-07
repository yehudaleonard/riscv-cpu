vsim -gMEM_FILE="programs/x0_protection.hex" work.cpu_tb

add wave sim:/cpu_tb/*
add wave sim:/cpu_tb/dut/*

run -all