.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    # save
    addi sp sp -32
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw ra 28(sp)

    mv s0 a0
    mv s1 a1
    mv s2 a2
    mv s3 a3
    mv s4 a4

    # Error checks
    li t0 1
    blt s1 t0 size_error1
    blt s2 t0 size_error1
    blt s4 t0 size_error2
    blt a5 t0 size_error2
    bne s2 s4 size_error3

    li s5 0
outer_loop_start:
   beq s5 s1 outer_loop_end
    li s6 0
inner_loop_start:
    beq s6 a5 inner_loop_end
    # v0
    mul a0 s2 s5
    slli a0 a0 2
    add a0 a0 s0
    # v1
    slli a1 s6 2
    add a1 a1 s3
    # stride and length
    mv a2 s2
    li a3 1
    mv a4 a5
    # dot
    jal dot
    sw a0 0(a6)

    addi a6 a6 4
    addi s6 s6 1
    j inner_loop_start
inner_loop_end:
    addi s5, s5, 1
    j outer_loop_start

outer_loop_end:
    # Epilogue
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw ra 28(sp)
    addi sp sp 32
    ret

size_error1:
    li a1 2
    jal exit2
size_error2:
    li a1 3
    jal exit2
size_error3:
    li a1 4
    jal exit2