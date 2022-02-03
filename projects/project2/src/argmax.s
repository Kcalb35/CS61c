.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:
    li t0, 1
    bge a1, t0, loop_start
    li a1, 7
    jal exit2

loop_start:
    li t0, 1 # t0 -> index
    lw t1, 0(a0) # assumed maximum value
    li t3, 0 # assume maximum index
    addi a0, a0, 4

loop_continue:
    beq t0, a1, loop_end
    lw t2, 0(a0)
    bge t1, t2, ngt
    mv t1, t2
    mv t3, t0
ngt:
    addi a0, a0, 4
    addi t0, t0, 1
    j loop_continue

loop_end:
    mv a0, t3
    ret