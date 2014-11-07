###################################################################################################
.data
	arr: .word 1, 2, 3, 4, 5, 6, 7, 8, 9
###################################################################################################
.globl main
.text
	main:
		la $a0, arr		#address of the array
		li $a1, 3		#number of rows
		li $a2, 3		#number of columns
		li $a3, 4		#size of elemnt in byte
		
		mul $t1, $a1, $a2	#calculate number of elemnt of the array
		mul $t1, $t1, $a3	#calculate size of the array
		add $t1, $a0, $t1	#calculate address of the last element in the array
		
		li $t2, 1		#array content type
		
		addi $sp, $sp, -8	#increase stack size by 8 byte
		sw $t1, 0($sp)		#stor address of the last element in the array in stack
		sw $t2, 4($sp)		#stor type of content of the array in stack
		jal PrintA
		
	li $v0, 10
	syscall
##################################################################################################
#Input:	$a0 = pointer on the array,		$a1 = number of rows
#	$a2 = number of columns,		$a3 = size of elemnt in byte
#	0($sp) = last elemnt in the array,	4($sp) = type of the array's content
#output:array is printed on the screen
##################################################################################################
	PrintA:
		addi $fp, $sp, 0	#initialize fram poiter
		addi $sp, $sp, -4	#allocate a word on the stack 
		sw $a0, 0($sp)		#save value of a0 in stack
		
		move $t0, $a0		#initialize pointer p on the array
		lw $t1, 0($fp)		#load address of the last element in the array
		li $t2, 0		#initialize an index i = 0
		lw $t3, 4($fp)		#load type of array content
		for:
			move $v0, $t3			#prepare to print		
			lw $a0, 0($t0)			#load elemnt to print
			syscall				#print
			addi $t0, $t0, 4		#increment p to next elemnt
			addi $t2, $t2, 1		#increment i by one
			beq $t2, $a1, print_line	#if i = size of row: print new line, else continue	
			return:
			blt $t0, $t1, for		#if p is less than the last elemnt loop back
			
		lw $a0, -4($fp)		#restore value of $a0
		jr $ra			#return
		
		print_line:
			li $v0, 11	#prepare to print char
			li $a0, '\n'	#load '\n' to print
			syscall		#print
			li $t2, 0	#reset i to 0
			j return	#jump to return label
##################################################################################################
			
