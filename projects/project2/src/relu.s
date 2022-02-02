.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    li t0, 1
    bge a1, t0, loop_start
    li a0, 8
    ecall

loop_start:
    li t0, 0 # t0->index

loop_continue:
    beq t0, a1, loop_end
    lw t1, 0(a0) # t1->next element
    bge t1, x0, relu_exit
    sw x0, 0(a0)
relu_exit:
    addi t0, t0, 1
    addi a0, a0, 4
    j loop_continue

loop_end:
	ret