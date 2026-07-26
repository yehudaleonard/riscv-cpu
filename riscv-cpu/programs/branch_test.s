# Branch Instructions Test
#
# Tests:
# 1. BEQ Taken
# 2. BEQ Not Taken
# 3. BNE Taken
# 4. BNE Not Taken

# Initialize verification registers.
addi x20, x0, 0
addi x21, x0, 0

# ----------------------------------------
# Test 1 - BEQ Taken
# ----------------------------------------

addi x1,  x0, 5
addi x2,  x0, 5

beq  x1,  x2, 8

addi x20, x0, 111      # Should be skipped
addi x10, x0, 1        # Should execute

# ----------------------------------------
# Test 2 - BEQ Not Taken
# ----------------------------------------

addi x3,  x0, 5
addi x4,  x0, 6

beq  x3,  x4, 8

addi x11, x0, 2        # Should execute
addi x12, x0, 3        # Should also execute

# ----------------------------------------
# Test 3 - BNE Taken
# ----------------------------------------

addi x5,  x0, 7
addi x6,  x0, 8

bne  x5,  x6, 8

addi x21, x0, 111      # Should be skipped
addi x13, x0, 4        # Should execute

# ----------------------------------------
# Test 4 - BNE Not Taken
# ----------------------------------------

addi x7,  x0, 9
addi x8,  x0, 9

bne  x7,  x8, 8

addi x14, x0, 5        # Should execute
addi x15, x0, 6        # Should also execute

# ----------------------------------------
# Test 5 - Large Branch Offset
# Branch should jump forward over multiple instructions.
# ----------------------------------------

addi x16, x0, 1
addi x17, x0, 1

beq x16, x17, 20

# These instructions should be skipped
addi x1, x0, 111
addi x2, x0, 222
addi x3, x0, 333
addi x4, x0, 444

# Branch target
addi x18, x0, 99