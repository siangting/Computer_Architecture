# fabsf_test.asm
# This program tests the fabsf function, which calculates the absolute value of a floating-point number and displays the result.

.data
fabsf_output:     .string "fabsf result: "  # String to display the fabsf result

.text
.globl main

main:
    # Test fabsf
    li a0, 0xBF800000        # Load -1.0's bit pattern (0xBF800000) into a0
    jal ra, fabsf            # Call the fabsf function
    la a1, fabsf_output      # Load the address of fabsf_output string into a1
    jal ra, print_result     # Call the print_result function to display the result

    # Exit the program
    li a7, 93                # System call number 93 for exit
    ecall

# fabsf function: Calculates the absolute value of a floating-point number
# Input: a0 - float32 value as an integer (bit representation)
# Output: a0 - absolute value as an integer (bit representation)
fabsf:
    li  t1, 0x7FFFFFFF       # Load mask 0x7FFFFFFF to clear the sign bit
    and a0, a0, t1           # a0 = a0 & 0x7FFFFFFF, clearing the sign bit
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