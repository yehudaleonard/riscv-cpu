# Load Test
#
# Tests that LW correctly reads
# data from memory into a register.

addi x1, x0, 16      # Base address

lw   x3, 0(x1)