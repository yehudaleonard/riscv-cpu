vsim -gMEM_FILE="programs/load_store_test.hex" work.cpu_tb

add wave sim:/cpu_tb/*
add wave sim:/cpu_tb/dut/*

run -all