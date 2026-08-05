# LUI and AUIPC Instructions Test
#
# Tests:
# 1. LUI Load Upper Immediate
# 2. AUIPC Add Upper Immediate to PC


# ----------------------------------------
# Test 1 - LUI
#
# Immediate = 0x12345
#
# Expected:
# x20 = 0x12345000
# ----------------------------------------

lui x20, 0x12345


# ----------------------------------------
# Test 2 - AUIPC
#
# Immediate = 0x10
#
# Expected:
# x21 = PC + 0x10000
# ----------------------------------------

auipc x21, 0x10