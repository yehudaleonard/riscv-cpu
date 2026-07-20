# Load / Store Test
#
# Tests that a stored value can be
# loaded back from memory.

addi x1, x0, 16      # Base address
addi x2, x0, 99      # Value to store

sw   x2, 0(x1)

lw   x3, 0(x1)