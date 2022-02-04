.globl classify

.data
classify_string: .string "classify to: "

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    li t0 5
    bne a0 t0 not_enough_params
    addi sp sp -56
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
    sw s5 24(sp)
    sw s6 28(sp)

    mv s0 a1 # s0->argv
    mv s1 a2 # s1->print flag

	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
    lw a0 4(s0)
    addi a1 sp 32
    addi a2 sp 36
    jal read_matrix
    mv s2 a0



    # Load pretrained m1
    lw a0 8(s0)
    addi a1 sp 40
    addi a2 sp 44
    jal read_matrix
    mv s3 a0


    # Load input matrix
    lw a0 12(s0)
    addi a1 sp 48
    addi a2 sp 52
    jal read_matrix
    mv s4 a0

    
    # malloc
    lw a0 32(sp)
    lw t0 52(sp)
    mul a0 a0 t0
    slli a0 a0 2
    jal malloc
    mv s5 a0


    lw a0 40(sp)
    lw t0 52(sp)
    mul a0 a0 t0
    slli a0 a0 2
    jal malloc
    mv s6 a0

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # hidden1=m0* input
    mv a0 s2
    lw a1 32(sp)
    lw a2 36(sp)
    mv a3 s4
    lw a4 48(sp)
    lw a5 52(sp)
    mv a6 s5
    jal matmul


    # relu
    mv a0 s5
    lw a1 32(sp)
    lw t0 52(sp)
    mul a1 a1 t0
    jal relu


    # m1 * hidden1
    mv a0 s3
    lw a1 40(sp)
    lw a2 44(sp)
    mv a3 s5
    lw a4 32(sp)
    lw a5 52(sp)
    mv a6 s6
    jal matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

    lw a0 16(s0)
    mv a1 s6
    lw a2 40(sp)
    lw a3 52(sp)
    jal write_matrix


    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0 s6
    lw a1 40(sp)
    lw t0 52(sp)
    mul a1 a1 t0
    jal argmax

    # Print classification
    bne s1 x0 classify_end 
    mv s0 a0 # s0->classify
    la a1 classify_string
    jal print_str
    mv a1 s0
    jal print_int

    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char


classify_end:
    # free
    mv a0 s5
    jal free
    mv a0 s6
    jal free


    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    lw s5 24(sp)
    lw s6 28(sp)
    addi sp sp 56

    ret

not_enough_params:
    li a1 49
    jal exit2