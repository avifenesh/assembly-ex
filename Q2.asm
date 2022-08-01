.data ##inserting data for example
num1: .word -8 , num3
num2: .word 1988 , 0
num3: .word -9034 , num5
num4: .word -100 , num2
num5: .word 1972 , num4
.text 

## taking the first node and starting a loop over the linked list
la $t0, num1

## each itration check if we got to zero that sighn for end of the list, otherwise, keep adding
## after adding get the next node from the adress the current node has in the second half word
printSum:
beqz $t0, EXITSum
lh $t2, ($t0)
add $t1,$t1,$t2
lw $t0, 4($t0)
j printSum


## print the value we end with and a space
EXITSum:
li  $v0, 1           
add $a0, $t1, $zero 
syscall
li $a0, 32
li $v0, 11  
syscall



addi $t1, $zero, 4 ## for used as modolo
add $t2, $zero, $zero ## make sure were good to go
la $t0, num1 ## bring the first node
## the loop check if we got to zero that sighn for end of the list,
## we check if the value of the node is positive
## we divide by 4 and take the HI, if HI = 0 that mean that the value is divided by 4
printMod4:
beqz $t0, EXITMod4 
add $t3, $zero, $zero
lh $t4, ($t0)
slt $t5, $zero, $t4
beqz $t5 next
div $t4, $t1
mfhi $t3
lw $t0, 4($t0)
beqz $t3, connect

## loading the next node
next:
lw $t0, 4($t0)
j printMod4

## add the result
connect:
add $t2, $t2, $t4
j printMod4

## print the result with a space after
EXITMod4:
li  $v0, 1           
add $a0, $t2, $zero 
syscall

## bringing the first node
la $t0, num1
## in the procecces we check if we got to zero what mean that we end with the list
## we check if the val is less then zero, then we print - and flip the sighn of the val
## we get rid of the zero's at the most valuable bits
## we get the most significant bits of the num, and print them as num of two digits, 
## by using mask of 49152 and moving the value we get 14 bits to the right
## then we shift the number by to bits left and keep going till we go over all the 16 bits of the half word
printBase4:
li $a0, 32
li $v0, 11  
syscall
beqz $t0, EXITBase4
lh $t1, ($t0)
bltz $t1, printMinus
add $t3, $zero, $zero
j getRidZeroLoop
printLoop:
bge $t3, 16, nextNum
andi $t2, $t1, 49152
srl $t2, $t2, 14
add $t3, $t3, 2
sll $t1, $t1, 2

print:
li  $v0, 1           
add $a0, $t2, $zero 
syscall
j printLoop

nextNum:
lw $t0, 4($t0)
j printBase4

printMinus:
li $a0, 45
li $v1, 11
syscall
subu $t1, $zero, $t1
add $t3, $zero, $zero
j getRidZeroLoop


getRidZeroLoop:
bge $t3, 16, nextNum
andi $t2, $t1, 49152
bgtu $t2, $zero, printLoop
sll $t1, $t1, 2
addi $t3, $t3, 2
j getRidZeroLoop



EXITBase4:





