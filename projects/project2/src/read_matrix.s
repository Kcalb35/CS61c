.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp sp -28
    sw ra 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp) # row
    sw s4 16(sp) # col
    sw s5 20(sp) # file
    sw s6 24(sp) # matrix
    mv s1 a1
    mv s2 a2
    # fopen
    mv a1 a0
    li a2 0
    jal fopen
    li s5 -1
    beq a0 s5 fopen_error
    mv s5 a0
    # read rows and cols
    mv a1 s5
    mv a2 s1
    li a3 4 # read 4 bytes
    jal fread
    li a3 4 # read 4 bytes
    bne a0 a3 fread_error
    mv a1 s5
    mv a2 s2 
    jal fread
    li a3 4
    bne a0 a3 fread_error
    # calculate space to malloc
    lw s3 0(s1) # row
    lw s4 0(s2) # col
    mul s4 s4 s3
    slli s4 s4 2 # s4->numer of bytes
    mv a0 s4
    # malloc
    jal malloc
    li s6 -1
    beq a0 s6 malloc_error
    mv s6 a0
    # read matrix
    mv a1 s5
    mv a2 s6
    mv a3 s4
    jal fread
    bne a0 s4 fread_error 
    # return
    mv a1 s5
    jal fclose
    bne a0 x0 fclose_error
    mv a0 s6
    mv a1 s1
    mv a2 s2

    # Epilogue
    lw ra 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp) # row
    lw s4 16(sp) # col
    lw s5 20(sp) # file
    lw s6 24(sp) # matrix
    addi sp sp 28
    ret

malloc_error:
    li a1 48
    jal exit2
fopen_error:
    li a1 50
    jal exit2
fread_error:
    li a1 51
    jal exit2
fclose_error:
    li a1 52
    jal exit2