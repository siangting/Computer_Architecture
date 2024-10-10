.data
str_1:         .string "The leading zero of "  # Part 1 of the output string
str_2:         .string " is "                  # Part 2 of the output string
newline:       .byte 10                        # Newline character
test_data_1:   .word 16                        # Test data 1: the number 16
test_data_2:   .word 128                       # Test data 2: the number 128
test_data_3:   .word 1024                      # Test data 3: the number 1024

.text
.globl main

main:
    # Test case 1
    la a0, test_data_1        # Load address of test_data_1 (16)
    jal ra, run_clz_test      # Run the clz test

    # Test case 2
    la a0, test_data_2        # Load address of test_data_2 (128)
    jal ra, run_clz_test      # Run the clz test

    # Test case 3
    la a0, test_data_3        # Load address of test_data_3 (1024)
    jal ra, run_clz_test      # Run the clz test

    # Exit the program
    li a7, 10                 # System call number 10 for exit
    ecall

# run_clz_test function: Executes the my_clz function and prints the result for a given test case
# Input: a0 - address of the test data
run_clz_test:
    addi sp, sp, -8           # Adjust the stack pointer to make space for saving registers
    sw ra, 0(sp)              # Save return address to the stack

    lw a1, 0(a0)              # Load the test data into a1
    mv a0, a1                 # Move test data to a0 for my_clz input
    jal ra, my_clz            # Call my_clz function
    mv t1, a0                 # Save the my_clz result (leading zero count) to t1
    mv a0, a1                 # Restore test data to a0
    mv a1, t1                 # Pass the leading zero count as a1
    jal ra, printResult       # Call printResult function

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

    la a0, str_1              # Load the address of the first string ("The leading zero of ")
    li a7, 4                  # System call code for printing a string
    ecall                     # Print the string "The leading zero of "

    mv a0, t0                 # Move the test_data (16/128/1024) to a0 for printing
    li a7, 1                  # System call code for printing an integer
    ecall                     # Print the test_data

    la a0, str_2              # Load the address of the second string (" is ")
    li a7, 4                  # System call code for printing a string
    ecall                     # Print the string " is "

    mv a0, t1                 # Move the leading zero count (result) to a0 for printing
    li a7, 1                  # System call code for printing an integer
    ecall                     # Print the leading zero count

    # Print a newline character
    la a0, newline            # Load the newline character
    li a7, 11                 # System call code for printing a character
    ecall                     # Print the newline character

    ret                       # Return to the caller
