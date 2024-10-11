.data
str_start:      .string "\nStartValue = "
str_target:     .string ", Target = "
str_output:     .string ", Minimum operations needed: "

# Test data
start_1:   .word 2
target_1:  .word 3

start_2:   .word 5
target_2:  .word 4096           # 00000000000000000001000000000000

start_3:   .word 3
target_3:  .word 1073741824     # 01000000000000000000000000000000

.text
.globl main

main:
    # Test case 1
    la a0, start_1          # Load address of start_1
    la a1, target_1         # Load address of target_1
    jal ra, run_test

    # Test case 2
    la a0, start_2          # Load address of start_2
    la a1, target_2         # Load address of target_2
    jal ra, run_test

    # Test case 3
    la a0, start_3          # Load address of start_3
    la a1, target_3         # Load address of target_3
    jal ra, run_test

    # Exit the program
    li a7, 10               # System call code for exit
    ecall

# run_test function: Executes min_operations function and prints the result
# Inputs:
#   a0: Address of startValue
#   a1: Address of target
run_test:
    addi sp, sp, -12        # Allocate stack space for saved registers
    sw ra, 8(sp)            # Save return address
    sw s0, 4(sp)            # Save s0
    sw s1, 0(sp)            # Save s1

    lw s0, 0(a0)            # Load startValue into s0
    lw s1, 0(a1)            # Load target into s1

    mv a0, s0               # Move startValue to a0
    mv a1, s1               # Move target to a1

    jal ra, min_operations  # Call min_operations function

    mv t0, s0               # Save startValue to t0
    mv t1, s1               # Save target to t1
    mv t2, a0               # Save result (operations) to t2

    jal ra, printResult     # Call printResult function

    lw ra, 8(sp)            # Restore return address
    lw s0, 4(sp)            # Restore s0
    lw s1, 0(sp)            # Restore s1
    addi sp, sp, 12         # Deallocate stack space
    ret

# min_operations function: Calculates the minimum number of operations
# Inputs:
#   a0: startValue
#   a1: target
# Output:
#   a0: Minimum number of operations
min_operations:
    addi sp, sp, -8         # Allocate stack space for saved registers
    sw s0, 4(sp)            # Save s0
    sw s1, 0(sp)            # Save s1

    mv s0, a0               # s0 = startValue
    mv s1, a1               # s1 = target
    li t0, 0                # t0 = operations

min_loop:
    bge s0, s1, min_loop_end  # If startValue >= target, exit loop

    andi t1, s1, 1            # t1 = target % 2
    beqz t1, min_even         # If t1 == 0 (even), go to min_even

    # target is odd
    addi s1, s1, 1            # target += 1
    addi t0, t0, 1            # operations += 1
    j min_loop

min_even:
    srai s1, s1, 1            # target = target / 2
    addi t0, t0, 1            # operations += 1
    j min_loop

min_loop_end:
    sub t1, s0, s1            # t1 = startValue - target
    add t0, t0, t1            # operations += (startValue - target)
    mv a0, t0                 # a0 = operations

    lw s0, 4(sp)              # Restore s0
    lw s1, 0(sp)              # Restore s1
    addi sp, sp, 8            # Deallocate stack space
    ret

# printResult function: Prints startValue, target, and minimum operations
# Inputs:
#   t0: startValue
#   t1: target
#   t2: Minimum operations
printResult:
    # Print "\nStartValue = "
    la a0, str_start
    li a7, 4                 # System call code for printing a string
    ecall

    # Print startValue
    mv a0, t0
    li a7, 1                 # System call code for printing an integer
    ecall

    # Print ", Target = "
    la a0, str_target
    li a7, 4
    ecall

    # Print target
    mv a0, t1
    li a7, 1
    ecall

    # Print ", Minimum operations needed: "
    la a0, str_output
    li a7, 4
    ecall

    # Print minimum operations
    mv a0, t2
    li a7, 1
    ecall

    # No need to print newline separately as it's included in the strings
    ret
