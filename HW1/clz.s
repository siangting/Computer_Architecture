.data
str_1:         .string "\nThe leading zero of "
str_2:         .string " is "
str_undefined: .string "undefined" 
test_data_1:   .word 19                         # 00000000000000000000000000010011
test_data_2:   .word 4096                       # 00000000000000000001000000000000
test_data_3:   .word 1073741824                 # 01000000000000000000000000000000
test_data_4:   .word 0                          # The number 0 (to test undefined behavior)

.text
.globl main

main:
    # Test case 1
    la a0, test_data_1
    jal ra, run_clz_test

    # Test case 2
    la a0, test_data_2
    jal ra, run_clz_test

    # Test case 3
    la a0, test_data_3
    jal ra, run_clz_test

    # Test case 4 (undefined behavior for 0)
    la a0, test_data_4
    jal ra, run_clz_test

    # Exit the program
    li a7, 10
    ecall

# run_clz_test function: Executes the my_clz function and prints the result for a given test case
run_clz_test:
    addi sp, sp, -8           # Adjust the stack pointer to make space for saving registers
    sw ra, 0(sp)              # Save return address to the stack

    lw a1, 0(a0)              # Load the test data into a1
    beqz a1, handle_zero      # If test data is 0, jump to handle_zero
    mv a0, a1                 # Move test data to a0 for my_clz input
    jal ra, my_clz            # Call my_clz function
    mv t1, a0                 # Save the my_clz result (leading zero count) to t1
    mv a0, a1                 # Restore test data to a0
    mv a1, t1                 # Pass the leading zero count as a1
    jal ra, printResult       # Call printResult function
    j restore_stack           # Jump to restore stack

# Handle zero case (undefined behavior)
handle_zero:
    mv t0, a1                 # Save 0 as test data
    la a0, str_1              # Load "The leading zero of " string
    li a7, 4                  # System call code for printing a string
    ecall                     # Print "The leading zero of "

    li a0, 0
    li a7, 1                  # System call code for printing an integer
    ecall                     # Print 0

    la a0, str_2
    li a7, 4
    ecall                     # Print " is "

    la a0, str_undefined
    li a7, 4
    ecall                     # Print "undefined"
    j restore_stack           # Jump to restore stack

restore_stack:
    lw ra, 0(sp)              # Restore return address from the stack
    addi sp, sp, 8            # Restore the stack pointer
    ret                       # Return to caller

# my_clz function: Counts the number of leading zeros in an integer
# Input: a0 - input integer
# Output: a0 - count of leading zeros
my_clz:
    li  t0, 0                 # Initialize counter t0 = 0
    li  t1, 31                # Set bit index t1 = 31 (starting from the highest bit)

clz_loop:
    li t3, 1                  # Load 1 into t3
    sll t3, t3, t1            # Shift t3 left by t1 bits to create the mask (1 << t1)
    and t2, a0, t3            # t2 = a0 & (1 << t1)
    beqz t2, check_next_bit   # If t2 == 0, jump to check_next_bit
    j clz_done                # If t2 != 0, jump to clz_done

check_next_bit:
    addi t0, t0, 1            # Increment counter t0
    addi t1, t1, -1           # Decrement bit index t1
    bgez t1, clz_loop         # If t1 >= 0, continue looping

clz_done:
    mv a0, t0                 # Move the count t0 to a0 (return value)
    jr ra                     # Return to the caller

# printResult function: Displays the result "The leading zero of <test_data> is <leading zero count>"
# a0: The original input value (test_data)
# a1: The leading zero count
printResult:
    mv t0, a0                 # Save original input value (test_data) in temporary register t0
    mv t1, a1                 # Save leading zero count in temporary register t1

    la a0, str_1 
    li a7, 4
    ecall                     # Print the string "The leading zero of "

    mv a0, t0
    li a7, 1
    ecall                     # Print the test_data

    la a0, str_2
    li a7, 4
    ecall                     # Print the string " is "

    mv a0, t1
    li a7, 1
    ecall                     # Print the leading zero count

    ret                       # Return to the caller
