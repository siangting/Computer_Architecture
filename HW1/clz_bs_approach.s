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

    # Test case 4 (Undefined behavior for 0)
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
    beqz a1, handle_zero      # If test data is 0, go to handle_zero
    mv a0, a1                 # Move test data to a0 for my_clz input
    jal ra, my_clz            # Call my_clz function
    mv t1, a0                 # Save the my_clz result (leading zero count) to t1
    mv a0, a1                 # Restore test data to a0
    mv a1, t1                 # Pass the leading zero count as a1
    jal ra, printResult       # Call printResult function
    j restore_stack           # Jump to restore stack

# Handle case where input is zero (undefined behavior)
handle_zero:
    mv t0, a1                 # t0 = 0
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

# my_clz function: Counts the number of leading zeros in an integer using Binary Search Approach
my_clz:
    li   t0, 0                 # Initialize counter t0 = 0
    li   t1, 0xFFFF0000        # t1 = 0xFFFF0000
    and  t2, a0, t1            # t2 = a0 & 0xFFFF0000
    beqz t2, clz_high16_zero   # If high 16 bits are zero, skip
    j clz_check_high8

clz_high16_zero:
    addi t0, t0, 16            # t0 += 16
    slli  a0, a0, 16           # a0 <<= 16

clz_check_high8:
    li   t1, 0xFF000000        # t1 = 0xFF000000
    and  t2, a0, t1            # t2 = a0 & 0xFF000000
    beqz t2, clz_high8_zero    # If next 8 bits are zero, skip
    j clz_check_high4

clz_high8_zero:
    addi t0, t0, 8             # t0 += 8
    slli  a0, a0, 8            # a0 <<= 8

clz_check_high4:
    li   t1, 0xF0000000        # t1 = 0xF0000000
    and  t2, a0, t1            # t2 = a0 & 0xF0000000
    beqz t2, clz_high4_zero    # If next 4 bits are zero, skip
    j clz_check_high2

clz_high4_zero:
    addi t0, t0, 4             # t0 += 4
    slli  a0, a0, 4            # a0 <<= 4

clz_check_high2:
    li   t1, 0xC0000000        # t1 = 0xC0000000
    and  t2, a0, t1            # t2 = a0 & 0xC0000000
    beqz t2, clz_high2_zero    # If next 2 bits are zero, skip
    j clz_check_high1

clz_high2_zero:
    addi t0, t0, 2             # t0 += 2
    slli  a0, a0, 2            # a0 <<= 2

clz_check_high1:
    li   t1, 0x80000000        # t1 = 0x80000000
    and  t2, a0, t1            # t2 = a0 & 0x80000000
    beqz t2, clz_high1_zero    # If highest bit is zero, skip
    j clz_done

clz_high1_zero:
    addi t0, t0, 1             # t0 += 1
    slli  a0, a0, 1            # a0 <<= 1

clz_done:
    mv   a0, t0                # Move result to a0
    jr   ra                    # Return to caller

# printResult function: Displays the result "The leading zero of <test_data> is <leading zero count>"
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
