# MIPS Assembly Language Program to count the number of integers in m to n that 
# are divisible by a given integer factor.


.data
n:          .word 0  #global variables
m:          .word 0
factor:     .word 0 
result:     .word -1 #initializing result to -1
result_str: .asciiz "Result: " #string to print before result
newline:    .asciiz "\n" #string to print after result

.text
main:       li $v0, 5 #read m
            syscall
            sw $v0, m

            li $v0, 5 #read n
            syscall
            sw $v0, n

            li $v0, 5 #read factor
            syscall
            sw $v0, factor
            
            lw $t0 factor #load factor
            beqz $t0, endwhile #if factor == 0, exit

            li $t0, 0 #initialize result
            sw $t0, result

            lw $t1, m #load m
            lw $t2, n #load n
            lw $t3, factor #load factor

loop:       bgt $t1, $t2, endwhile #if m > n, exit
            rem $t4, $t1, $t3 #remainder of m div factor
            bnez $t4, skip_incr #if remainder != 0, skip incrementing result

            lw $t0, result #load result
            addi $t0, $t0, 1 #increment result
            sw $t0, result #store result

skip_incr:  addi $t1, $t1, 1 #increment m
            j loop

endwhile:   la $a0, result_str #print result_str
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

            