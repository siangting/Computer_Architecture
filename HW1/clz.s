# my_clz_test.asm
# This program tests the my_clz function, which counts the number of leading zeros in an integer and displays the result.

.data
clz_output:       .string "my_clz result: " # String to display the my_clz result

.text
.globl main

main:
    # Test my_clz
    li a0, 16                # Load integer 16 (00000000 00000000 00000000 00010000) into a0
    jal ra, my_clz           # Call the my_clz function
    la a1, clz_output        # Load the address of clz_output string into a1
    jal ra, print_result     # Call the print_result function to display the result

    # Exit the program
    li a7, 93                # System call number 93 for exit
    ecall

# my_clz function: Counts the number of leading zeros in an integer
# Input: a0 - input integer
# Output: a0 - count of leading zeros
my_clz:
    li  t0, 0                # Initialize counter t0 = 0
    li  t1, 31               # Set bit index t1 = 31 (starting from the highest bit)

clz_loop:
    li t3, 1                 # Load 1 into t3
    sll t3, t3, t1           # Shift t3 left by t1 bits to create the mask (1 << t1)
    and t2, a0, t3           # t2 = a0 & (1 << t1)
    beqz t2, continue_loop   # If t2 == 0, jump to continue_loop
    j clz_done               # If t2 != 0, jump to clz_done

continue_loop:
    addi t0, t0, 1           # Increment counter t0
    addi t1, t1, -1          # Decrement bit index t1
    bgez t1, clz_loop        # If t1 >= 0, continue looping

clz_done:
    mv a0, t0                # Move the count t0 to a0 (return value)
    jr ra                    # Return to the caller

# print_result function: Displays the result
# Inputs:
#   a1 - Address of the string to display
#   a0 - Integer value to display
print_result:
    mv t0, a0                # Save the result (integer) to temporary register t0
    mv a0, a1                # Move the string address to a0
    li a7, 4                 # System call number 4 for printing a string
    ecall                    # Make the system call to print the string

    mv a0, t0                # Move the result (integer) back to a0 for printing
    li a7, 1                 # System call number 1 for printing an integer
    ecall                    # Make the system call to print the integer

    # Print a newline (optional, for better formatting)
    li a0, 10                # Newline character
    li a7, 11                # System call number 11 for printing a character
    ecall                    # Make the system call to print the newline

    jr ra                    # Return to the caller
