# MIPS Assembly Language Program to  count the number of integers in m to n that 
# are divisible by a given integer factor. The program uses a function to 
# implement the algorithm. The function is called from the main program.

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

                jal num_multiples #call num_multiples
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
                                    #prologue
num_multiples:  sub $sp, $sp, 12     # set new stack ptr
                sw $ra, 12($sp)     # save ret addr in stack
                sw $fp, 8($sp)      # save old frame ptr in stack
                add $fp, $sp, 12     # set new frame ptr

                lw $t1, 12($fp) #load value1(m)
                lw $t2, 8($fp) #load value2(n)
                lw $t3, 4($fp) #load number(factor)

                li $t0, -1 #initialize result
                sw $t0, 4($sp) #push result (local variable) onto stack

                beqz $t3, endwhile #if number == 0, exit
                li $t0, 0 #initialize result
                sw $t0, 4($sp) #update result in stack

loop:           bgt $t1, $t2, endwhile #if value1 > value2, exit
                rem $t4, $t1, $t3 #remainder of value1 / number
                bnez $t4, skip_incr #if remainder != 0, skip incrementing result

                addi $t0, $t0, 1 #increment result
                sw $t0, 4($sp) #store result

skip_incr:      addi $t1, $t1, 1 #increment m
                sw $t1, 12($fp) #store m
                j loop

endwhile:       # epilogue
                lw      $ra, 12($sp)     # load ret addr from stack
                lw      $fp, 8($sp )     # restore old frame ptr from stack
                add     $sp, $sp, 12     # reset stack ptr
                jr      $ra              # ret to caller using saved ret addr