# x0 Protection Test
#
# Tests that register x0
# always remains zero

addi x0, x0, 100

addi x1, x0, 5

add x2, x0, x1