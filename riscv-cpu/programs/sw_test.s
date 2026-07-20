# Store Test
#
# Tests that SW correctly writes
# register data into memory.

addi x1, x0, 16      # Base address
addi x2, x0, 42      # Value to store

sw   x2, 0(x1)