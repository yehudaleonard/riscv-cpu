vsim -gMEM_FILE="programs/jal_jalr_test.hex" work.cpu_tb

add wave sim:/cpu_tb/*
add wave sim:/cpu_tb/dut/*

run -all