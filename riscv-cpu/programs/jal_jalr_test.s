# JAL and JALR Instructions Test
#
# Tests:
# 1. JAL Jump + Write PC+4
# 2. JALR Register Jump + Write PC+4
# 3. JALR Bit 0 Clearing


# Initialize verification registers.

addi x20, x0, 0
addi x21, x0, 0
addi x22, x0, 0
addi x23, x0, 0
addi x24, x0, 0
addi x25, x0, 0


# ----------------------------------------
# Test 1 - JAL Jump + PC+4 Write
#
# PC = 24
# Target = 32
# Offset = 8
# ----------------------------------------

jal x5, 8

addi x20, x0, 111      # Should be skipped
addi x10, x0, 1        # Target


# ----------------------------------------
# Test 2 - JALR Register Jump + PC+4 Write
#
# x11 contains target address 56
# ----------------------------------------

addi x11, x0, 56

jalr x6, x11, 0

addi x21, x0, 111      # Should be skipped
addi x22, x0, 222      # Should be skipped
addi x23, x0, 333      # Should be skipped

addi x12, x0, 2        # Target


# ----------------------------------------
# Test 3 - JALR Bit 0 Clearing
#
# x13 = 77
#
# JALR target:
# (77 + 0) & ~1 = 76
# ----------------------------------------

addi x13, x0, 77

jalr x7, x13, 0

addi x24, x0, 222      # Should be skipped
addi x25, x0, 333      # Should be skipped

addi x14, x0, 3        # Target