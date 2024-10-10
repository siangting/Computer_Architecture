# clz_test.asm
# This program tests the my_clz function, which counts the number of leading zeros in an integer and displays the result.

.data
str_1:     .string "The leading zero of "  # Part 1 of the output string
str_2:     .string " is "                  # Part 2 of the output string
test_data:        .word 16                 # Test data: the number 16

.text
.globl main

main:
    # Test my_clz
    lw a0, test_data         # Load integer 16 (00000000 00000000 00000000 00010000) into a0
    jal ra, my_clz           # Call the my_clz function
    mv t1, a0                # Save the my_clz result (leading zero count) to t1
    lw a0, test_data         # Reload the test data (16) into a0

    # Call print_result function to display full result
    mv a1, t1                # Pass the my_clz result (leading zero count) as a1
    jal ra, printResult      # Call the printResult function

    # Exit the program
    li a7, 10                # System call number 10 for exit
    ecall

# my_clz function: Counts the number of leading zeros in an integer
# Input: a0 - input integer
# Output: a0 - count of leading zeros
my_clz:
    li  t0, 0                # Initialize counter t0 = 0
    li  t1, 31               # Set bit index t1 = 31 (starting from the highest bit)

clz_loop:
    li t3, 1                 # Load 1 into t3
    sll t3, t3, t1           # Shift t3 left by t1 bits to create the mask
    and t2, a0, t3           # t2 = a0 & (1 << t1)
    beqz t2, check_next_bit   # If t2 == 0, jump to check_next_bit
    j clz_done               # If t2 != 0, jump to clz_done

check_next_bit:
    addi t0, t0, 1           # Increment counter t0
    addi t1, t1, -1          # Decrement bit index t1
    bgez t1, clz_loop        # If t1 >= 0, continue looping

clz_done:
    mv a0, t0                # Move the count t0 to a0 (return value)
    jr ra                    # Return to the caller

# printResult function: Displays the result "The leading zero of <test_data> is <leading zero count>"
# a0: The original input value (test_data)
# a1: The leading zero count
printResult:
    mv t0, a0                  # Save original input value (test_data) in temporary register t0
    mv t1, a1                  # Save leading zero count in temporary register t1

    la a0, str_1                # Load the address of the first string ("The leading zero of ")
    li a7, 4                   # System call code for printing a string
    ecall                      # Print the string "The leading zero of "

    mv a0, t0                  # Move the test_data (16) to a0 for printing
    li a7, 1                   # System call code for printing an integer
    ecall                      # Print the test_data (e.g., 16)

    la a0, str_2              # Load the address of the second string (" is ")
    li a7, 4                   # System call code for printing a string
    ecall                      # Print the string " is "

    mv a0, t1                  # Move the leading zero count (result) to a0 for printing
    li a7, 1                   # System call code for printing an integer
    ecall                      # Print the leading zero count (e.g., 27)

    ret                        # Return to the caller
