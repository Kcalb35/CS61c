.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    li t0 1 
    bge a2, t0, length_valid
    li a0 5
    ecall
length_valid:
    bge a3, t0, stride1_valid
    li a0 6
    ecall
stride1_valid:
    bge a4, t0, stride2_valid
    li a0 6
    ecall
stride2_valid:
    li t0 0 # t0->index
    li t4 0 # t4-> sum

loop_start:
    mul t1, t0, a3 # t1->offset
    slli t1, t1, 2
    add t2, a0, t1
    lw t2, 0(t2) # t2->value1

    mul t1, t0, a4
    slli t1, t1, 2
    add t3, a1, t1
    lw t3, 0(t3) # t3->value2

    mul t2, t2, t3
    add t4, t4, t2
    addi t0, t0, 1

    beq t0, a2, loop_end

    j loop_start
loop_end:
    mv a0 t4
    ret