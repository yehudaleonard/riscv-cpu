vsim -gMEM_FILE="programs/basic_datapath.hex" work.cpu_tb

add wave sim:/cpu_tb/*
add wave sim:/cpu_tb/dut/*

run -all