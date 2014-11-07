###################################################################################################
.data
	arr: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
###################################################################################################
.globl main
.text
	main:
		la $a0, arr		#address of the array
		li $a1, 4		#number of rows
		li $a2, 4		#number of columns
		li $a3, 4		#size of elemnt in byte
		
		mul $t1, $a1, $a2	#calculate number of elemnt of the array
		mul $t1, $t1, $a3	#calculate size of the array
		add $t1, $a0, $t1	#calculate address of the last element in the array
		li $t2, 1		#array content type
		addi $sp, $sp, -8	#increase stack size by 8 byte
		sw $t1, 0($sp)		#stor address of the last element in the array in stack
		sw $t2, 4($sp)		#stor type of content of the array in stack
		jal PrintA
		
		li $t1, 0
		li $t2, 1
		addi $sp, $sp, -8	#increase stack size by 8 byte
		sw $t1, 0($sp)		#stor first rwo to be exchanged in stack
		sw $t2, 4($sp)		#stor second rwo to be exchanged in stack
		jal ExchangeR
		
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
#Method Name: PrintA
#Input:	$a0 = pointer on the array,		$a1 = number of rows
#	$a2 = number of columns,		$a3 = size of elemnt in byte
#	0($sp) = last elemnt in the array,	4($sp) = type of the array's content(1 = int, 11 = char) 
#Output:void
##################################################################################################
	PrintA:
		move $fp, $sp		#initialize frame poiter
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
			
			li $v0, 11			#prepare to print		
			li $a0, '\t'			#load '\t'
			syscall				#print tap
			
			addi $t0, $t0, 4		#increment p to next elemnt
			addi $t2, $t2, 1		#increment i by one
			beq $t2, $a1, print_line	#if i = size of row: print new line, else continue	
			return:
			blt $t0, $t1, for		#if p is less than the last elemnt loop back
			
		lw $a0, -4($fp)		#restore value of $a0
		addi $sp, $sp, -12	#free stack
		jr $ra			#return
		
		print_line:
			li $v0, 11	#prepare to print char
			li $a0, '\n'	#load '\n' to print
			syscall		#print
			li $t2, 0	#reset i to 0
			j return	#jump to return label
			
##################################################################################################
#Method Name: ExchangeR
#Input:	$a0 = pointer on the array,		$a1 = number of rows
#	$a2 = number of columns,		$a3 = size of elemnt in byte
#	0($sp) = fist rwo to be exchanged (r1),	4($sp) = second rwo to be exchanged (r2)
#Output:void
##################################################################################################
	ExchangeR:
		move $fp, $sp		#initialize frame poiter
		
		lw $t0, 0($fp)		#load r1
		lw $t1, 4($fp)		#load r2
		
		mul $t0, $t0, $a2	#initialize poiter p = address of first elemnt in r1 where
		mul $t0, $t0, $a3	# p = (row number) * (number of columns) * (size of elemnt)
		add $t0, $t0, $a0
		
		mul $t1, $t1, $a2	#initialize poiter q = address of second elemnt in r2 where
		mul $t1, $t1, $a3	# q = (row number) * (number of columns) * (size of elemnt)
		add $t1, $t1, $a0
		
		mul $t2, $a2, $a3	#calculate address of last elemnt in r1
		addu $t2, $t2, $t0
		sub $t2, $t2, 4
		
		loop:
			lw $t3, 0($t0)		#load elemnt from r1
			lw $t4, 0($t1)		#load elemnt from r2
			sw $t3, 0($t1)		#store elemnt from r1 into r2
			sw $t4, 0($t0)		#store elemnt from r2 into r1
			
			addiu $t0, $t0, 4	#increment p to next elemnt
			addiu $t1, $t1, 4	#increment q to next elemnt
			ble $t0, $t2, loop	#if p <= last elemnt in r1 then loop back
		jr $ra

##################################################################################################
#Method Name: ExchangeC
#Input:	$a0 = pointer on the array,		$a1 = number of rows
#	$a2 = number of columns,		$a3 = size of elemnt in byte
#	0($sp) = fist column to be exchanged (c1),	4($sp) = second column to be exchanged (c2)
#Output:void
##################################################################################################
	ExchangeC:
		move $fp, $sp		#initialize frame poiter
		
		lw $s0, 0($fp)		#load c1
		lw $s1, 4($fp)		#load c2
		
		li $t5, 0		#initialize row = 0
		
		while:			
			mul $t0, $a1, $t5	#elemnt address[i][j] = (array address) + (szie of elemnt) 
						# * [(number of rows) * (i) + (j)]
			add $t0, $t0, $s0
			mul $t0, $t0, 4
			add $t0, $t0, $a0
		
			mul $t1, $a1, $t5
			add $t1, $t1, $s1
			mul $t1, $t1, 4
			add $t1, $t1, $a0
			
			lw $t3, 0($t0)		#load elemnt from c1
			lw $t4, 0($t1)		#load elemnt from c2
			sw $t3, 0($t1)		#store elemnt from c1 into c2
			sw $t4, 0($t0)		#store elemnt from c2 into c1
			
			add $t5, $t5, 1
			ble $t5, $a1, while	#if i <= last number of rows then loop back
		jr $ra
		
