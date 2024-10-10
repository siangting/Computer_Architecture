.data
str_1:         .string "\nThe leading zero of "  # Part 1 of the output string
str_2:         .string " is "                  # Part 2 of the output string
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

# my_clz function: Counts the number of leading zeros in an integer using Binary Search Approach
# Input: a0 - input integer
# Output: a0 - count of leading zeros
my_clz:
    beqz a0, clz_zero          # If input is zero, leading zeros is 32
    li   t0, 0                 # Initialize counter t0 = 0

    li   t1, 0xFFFF0000        # t1 = 0xFFFF0000
    and  t2, a0, t1            # t2 = a0 & 0xFFFF0000
    beqz t2, clz_high16_zero   # If high 16 bits are zero, skip
    # High 16 bits are not zero
    # Do nothing, t0 remains 0
    j clz_check_high8

clz_high16_zero:
    addi t0, t0, 16            # t0 += 16
    slli  a0, a0, 16            # a0 <<= 16

clz_check_high8:
    li   t1, 0xFF000000        # t1 = 0xFF000000
    and  t2, a0, t1            # t2 = a0 & 0xFF000000
    beqz t2, clz_high8_zero    # If next 8 bits are zero, skip
    # Next 8 bits are not zero
    # Do nothing
    j clz_check_high4

clz_high8_zero:
    addi t0, t0, 8             # t0 += 8
    slli  a0, a0, 8             # a0 <<= 8

clz_check_high4:
    li   t1, 0xF0000000        # t1 = 0xF0000000
    and  t2, a0, t1            # t2 = a0 & 0xF0000000
    beqz t2, clz_high4_zero    # If next 4 bits are zero, skip
    # Next 4 bits are not zero
    # Do nothing
    j clz_check_high2

clz_high4_zero:
    addi t0, t0, 4             # t0 += 4
    slli  a0, a0, 4             # a0 <<= 4

clz_check_high2:
    li   t1, 0xC0000000        # t1 = 0xC0000000
    and  t2, a0, t1            # t2 = a0 & 0xC0000000
    beqz t2, clz_high2_zero    # If next 2 bits are zero, skip
    # Next 2 bits are not zero
    # Do nothing
    j clz_check_high1

clz_high2_zero:
    addi t0, t0, 2             # t0 += 2
    slli  a0, a0, 2             # a0 <<= 2

clz_check_high1:
    li   t1, 0x80000000        # t1 = 0x80000000
    and  t2, a0, t1            # t2 = a0 & 0x80000000
    beqz t2, clz_high1_zero    # If highest bit is zero, skip
    # Highest bit is not zero
    # Do nothing
    j clz_done

clz_high1_zero:
    addi t0, t0, 1             # t0 += 1
    slli  a0, a0, 1             # a0 <<= 1

clz_done:
    mv   a0, t0                # Move result to a0
    jr   ra                    # Return to caller

clz_zero:
    li   a0, 32                # Leading zeros for zero input is 32
    jr   ra

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

    ret                       # Return to the caller
