###################################################################################################
.data
	arr: .word 1, 2, 3, 4, 5, 6, 7, 8, 9
###################################################################################################
.globl main
.text
	main:
		la $a0, arr
		li $a1, 3
		li $a2, 3
		li $a3, 4
		mul $t1, $a1, $a2	#calculate number of elemnt of the array
		mul $t1, $t1, $a3	#calculate size of the array
		add $t1, $a0, $t1	#calculate address of the last element in the array
		li $t2, 1
		
		addi $sp, $sp, -8
		sw $t1, 0($sp)		#stor address of the last element in the array in stack
		sw $t2, 4($sp)		#stor type of content of the array in stack
		jal PrintA
		
	li $v0, 10
	syscall
##################################################################################################	
	PrintA:
		addi $fp, $sp, 8
		addi $sp, $sp, -4 
		sw $a0, 8($fp)		#save value of a0 in stack
		
		move $t0, $a0		#create pointer on the array
		lw $t1, 0($fp)		#load address of the last element in the array in t1
		li $t2, 0		#initialize an index i = 0
		lw $t3, 4($fp)		#load type of array content
		for:
			move $v0, $t3	
			lw $a0, 0($t0)
			syscall
			addi $t0, $t0, 4
			addi $t2, $t2, 1
			beq $t2, $a1, print_line
			return:
			blt $t0, $t1, for
			
		lw $a0, 0($fp)
		addi $sp, $sp, -4
		jr $ra
		
		print_line:
			li $v0, 11
			li $a0, '\n'
			syscall
			li $t2, 0
			j return
##################################################################################################
			