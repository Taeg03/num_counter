# MIPS Assembly Language Program to count the number of integers in m to n that 
# are divisible by a given integer factor. The program uses a recursive function
# to perform the calculation and returns the result to the main program. The 
# program uses the stack to pass parameters and return values between the main
# program and the function. 

.data
n:          .word 0  #global variables
m:          .word 0
factor:     .word 0 
temp:       .word 0
result_str: .asciiz "Result: " #string to print before result
newline:    .asciiz "\n" #string to print after result

.text
main:           li $sp, 0x7ffffffc  # set up stack ptr

                li $v0, 5 #read m
                syscall
                sw $v0, m
                sw $v0, ($sp) #push m onto stack
                sub $sp, $sp, 4

                li $v0, 5 #read n
                syscall
                sw $v0, n
                sw $v0, ($sp) #push n onto stack
                sub $sp, $sp, 4

                li $v0, 5 #read factor
                syscall
                sw $v0, factor
                sw $v0, ($sp) #push factor onto stack
                sub $sp, $sp, 4

                jal num_mult #call num_mult function
                add $sp, $sp, 12 #pop 3 values off stack
                sw $v0, temp #store result in temp

                la $a0, result_str #print result_str
                li $v0, 4
                syscall
                
                move $a0, $t0 #move result to $a0
                li $v0, 1 #print result
                syscall

                la $a0, newline #print newline
                li $v0, 4
                syscall

                li $v0, 10 #exit
                syscall


num_mult:       sub $sp, $sp, 8     # set new stack ptr
                sw $ra, 8($sp)     # save ret addr in stack
                sw $fp, 4($sp)      # save old frame ptr in stack
                add $fp, $sp, 8     # set new frame ptr

                lw $t0 12($fp) #load value1(m)
                sw $t0 ($sp) #push value1 onto stack (parameter)
                sub $sp, $sp, 4

                lw $t0 8($fp) #load value2(n)
                sw $t0 ($sp) #push value2 onto stack (parameter)
                sub $sp, $sp, 4

                lw $t0 4($fp) #load number(factor)
                sw $t0 ($sp) #push number onto stack (parameter)
                sub $sp, $sp, 4

                li $t0, 0 #push result onto stack
                sw $t0, ($sp) 
                sub $sp, $sp, 4

                jal num_mult_helper #call helper function

                add $sp, $sp, 16 #pop 4 values off stack

                # epilogue
                lw      $ra, 8($sp)     # load ret addr from stack
                lw      $fp, 4($sp )     # restore old frame ptr from stack
                add     $sp, $sp, 8     # reset stack ptr
                jr      $ra              # ret to caller using saved ret addr

                                    #prologue
num_mult_helper:sub $sp, $sp, 16     # set new stack ptr
                sw $ra, 16($sp)     # save ret addr in stack
                sw $fp, 12($sp)      # save old frame ptr in stack
                add $fp, $sp, 16     # set new frame ptr

                lw $t1, 16($fp) #load val1
                lw $t2, 12($fp) #load val2

                lw $t3, 8($fp) #load num
                lw $t4, 4($fp) #load cur_result

                li $t0, -1 #initialize result
                sw $t0, 8($sp) #push result (local variable) onto stack

                beqz $t3, endif #if number == 0, exit

                bge $t2, $t1, else #if value2 >= value1, go to else
                lw $t0, 4($fp) #result = cur_result
                sw $t0, 8($sp) #update result in stack
                j endif #exit

else:           add $t5, $t1, 1 #declare next_val = value1 + 1
                sw $t5, 4($fp) #store value1

                sw $t5, ($sp) #push next_val onto stack
                sub $sp, $sp, 4

                sw $t2, ($sp) #push value2 onto stack
                sub $sp, $sp, 4

                sw $t3, ($sp) #push num onto stack
                sub $sp, $sp, 4

                sw $t4, ($sp) #push cur_result onto stack
                sub $sp, $sp, 4

                jal num_mult_helper #call helper function

                add $sp, $sp, 16 #pop 4 values off stack

                lw $t1, 4($fp) #load val1(next_val)
                lw $t2, 12($fp) #load val2
                lw $t3, 8($fp) #load num 
                lw $t4, 4($fp) #load cur_result
                lw $t0, 8($sp) #load result from stack

                move $t0, $v0 #load result to $t0

                rem $t6, $t1, $t3 #declare remainder = next_val % num
                bnez $t6, endif #if remainder != 0, go to endif

                add $t0, $t0, 1 #update result
                sw $t0, 8($sp) #push result onto stack

endif:          move $v0, $t0 #move result to $v0

                # epilogue
                lw      $ra, 16($sp)     # load ret addr from stack
                lw      $fp, 12($sp )     # restore old frame ptr from stack
                add     $sp, $sp, 16     # reset stack ptr
                jr      $ra              # ret to caller using saved ret addr