# Title: Q3 maman 12
# Author: Avi Fenesh      Date:6/8/2022

######## Data segment ######## 
.data
CharStr: .asciiz "AAAGGCCEDGJFKGXHFHATHYJAAAAAFFRRRTHGBVDVDVFGJ"
ResultArray: .word 0:26
ascii_code_message: .asciiz "\nthis is the ascii code of the char that return the most: "
repeat_message: .asciiz "\nand this is the reapets number: "
new_line: .asciiz "\n"
ask_if_again_message: .asciiz "/nDo you want to do it again?"
######## Data segment ######## 

.text
.globl main
main: ## bring the data from the memory
la $a0, CharStr
la $a1, ResultArray
j occurrences_char




occurrences_char: ## count the occurrences of every char at the str 
add $t0, $zero, $zero
occurrences_char_loop: ## itrate throgh the charStr, for every apperance of char increase by 1 the number in the cell with the index equal to the ascii code of the char -65 
add $t1, $a0, $t0
lb $t1, ($t1)
blez $t1, find_biggest ## if we finishid iterate throgh the charStr well go to find the biggest
addi $t1,$t1,-65
add $t1, $a1, $t1
lb $t3, ($t1)
addi $t3, $t3, 1
sb $t3, ($t1)
addi $t0, $t0, 1
j occurrences_char_loop

find_biggest: ## iterate throgh the Result array and find the biggest number, represnting the number of apprencces
addi $t2, $a1, 26
add $t3, $zero, $zero
move $t1, $a1

find_biggest_loop:
lb $t0, ($t1)
blt $t0, $t3, next ## if less then the biggest go to the next itrate, else save it
move $t3, $t0
sub $t4, $t1, $a1
next:
addi $t1, $t1, 1
bne $t1, $t2, find_biggest_loop
li $t0, 1
addi $t4, $t4, 65

print_biggest:
addi $sp, $sp, -12
move $v0, $t4
sw $a0, 0($sp) 
sw $v0, 4($sp) 
sw $v1, 8($sp) 
move $v0, $t4
move $v1, $t3

li $v0, 4 ## print the char
la $a0, ascii_code_message 
syscall

li $v0, 1
move $a0, $t4
syscall

li $v0, 4
la $a0, repeat_message
syscall

li $v0, 1 ## print the number of apprances
move $a0, $t3
syscall
lw $a0, 0($sp)
lw $v0, 4($sp)
lw $v1 , 8($sp)
addi $sp, $sp, 12
j occurrences_by_Char_print

occurrences_by_Char_print: ## loop throgh the array, for each cell, print the char represent by index+65 * value in the cell
addi $sp,$sp, -8
sw $a0, 0($sp) 
sw $v0, 4($sp) 
add $t0, $zero, $zero
occurrences_by_Char_print_loop:
bgt $t0, 25, end_occurrences 
add $t1, $a1, $t0
lb $t2, ($t1)
beqz $t2, next_cell ## if empty cell
li $v0, 4
la $a0, new_line
syscall
inside_print_loop: ## iterate x time, x is the value in the cell
beqz $t2, next_cell
addi $t3, $t0,65
li $v0, 11
move $a0, $t3
syscall
addi $t2, $t2, -1
j inside_print_loop
next_cell:
addi $t0, $t0, 1
j occurrences_by_Char_print_loop

end_occurrences:
lw $a0, 0($sp) 
lw $v0, 4($sp) 
sw $a0, 0($sp)
sw $a1, 4($sp)
addi $a1, $v0, 65
j delete

delete:
add $t0, $a0, $zero

delete_loop: ## check if found the char that apperance the most, if found call to reduction
move $a0, $t0
lb $t1, 0($t0)
beqz $t1, end_delete
beq $t1,$t4, reduction
addi $t0, $t0, 1
j delete_loop


reduction: ## move all the cells one left, that way overide the most apperance char
lb $t2, 0($a0)
beqz $t2, end_reduction
lb $t3, 1($a0)
sb $t3, 0($a0)
addi $a0, $a0, 1
j reduction
end_reduction:
lb $t3, 1($a0)
sb $t3, 0($a0)
j delete_loop

end_delete:
lw $a0, 0($sp)
lw $a1, 4($sp)
addi $sp, $sp, 8
j ask_user

ask_user: ## ask the user if start again, if yes, make sure thet all of the reg with important values are set back to zero and start again
lb $t0, ($a0)
beqz $t0, end_program
addi $sp, $sp, -8
sw $a0, 0($sp) 
sw $v0, 4($sp) 
li $v0, 50
la $a0, ask_if_again_message
syscall
beqz $a0, run_again
j end_program
run_again:
lw $a0, 0($sp) 
lw $v0, 4($sp) 
addi $sp, $sp, 8
addi $t0, $a1, 26
while: ## overide the array with zeros
blt $t0, $a1,end_while
sb $zero, 0($t0)
addi $t0, $t0, -1
j while
end_while:
move $v1, $zero
move $v0, $zero 
move $a1, $zero
move $a0, $zero
j main


end_program:
li $v0, 10
syscall


