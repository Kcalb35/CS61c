.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp sp -28
    sw ra 0(sp)
    sw a2 4(sp)
    sw a3 8(sp)
    sw s0 12(sp)
    sw s1 16(sp)
    sw s2 20(sp) 
    sw s3 24(sp)

    mv s0 a0 # s0->filename
    mv s1 a1 # s1->matrix
    mul s2 a2 a3 # s2->row*col

    # fopen
    mv a1 s0
    li a2 1
    jal fopen
    li t0 -1
    beq a0 t0 fopen_error
    mv s3 a0 # s3->file
    # write row and col
    mv a1 s3
    addi a2 sp 4
    li a3 2
    li a4 4
    jal fwrite
    li t0 2
    bne a0 t0 fwrite_error
    # write matrix
    mv a1 s3
    mv a2 s1
    mv a3 s2
    li a4 4
    jal fwrite
    mv t0 s2
    bne a0 t0 fwrite_error
    # fclose
    mv a1 s3
    jal fclose
    bne a0 x0 fclose_error

    # Epilogue

    lw ra 0(sp)
    lw s0 12(sp)
    lw s1 16(sp)
    lw s2 20(sp) 
    lw s3 24(sp)
    addi sp sp 28

    ret
fopen_error:
    li a1 53
    jal exit2
fwrite_error:
    li a1 54
    jal exit2
fclose_error:
    li a1 55
    jal exit2