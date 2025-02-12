# date project : goal is to be able to add days to the current date
.data
month_array:	.word	31, 28, 31, 30, 31, 30, 31, 31, 30, 31
		.word 	30, 31
start_date:	.word	2, 12, 2025
num_days:	.word	1145

# code time
# Approach:
#	-Loop through array
#		-Subtracting days + adding months
#		-If we get to a year, go back to the start
#	-Print out the end date

.text
.globl main

main:	la $s0 start_date		# s0: start_date
	la $s1 month_array		# s1: month_array
	la $s2 num_days			
	lw $s2, ($s2)			# s2: num_days
	lw $s3, ($s0)			# s3: month tracker
	li $s4, 12			# s4 = 12
	lw $s5, 8($s0)			# s5 will be the year tracker

	lw $t0, 4($s0)			# start_date day to $t0

	addi $t1, $s3, -1		# subtract one from month
	sll $t1, $t1, 2			# shift left 2, (mult by 4)
	add $t1, $t1, $s1		# add to beginning address
	
	lw $t2, ($t1)			# loads the current month into $t2
	jal february

	sub $t0, $t2, $t0		# days left in current month
	sub $t3, $s2, $t0		# num days - days left	

	ble $t3, $0, print 		# if(num_days would be <= 0): print
	
	move $s2, $t3
	addi $s3, $s3, 1
	addi $t1, $t1, 4

#------------------------------------------
loop:	
	lw $t2, ($t1)
	jal february
	
	sub $t3, $s2, $t2		# if this month is too much, print
	ble $t3, $0, print

	move $s2, $t3			# otherwise, continue to next month
	addi $s3, $s3, 1
	addi $t1, $t1, 4

	bgt $s3, $s4, reset
	j loop

#------------------------------------------
reset:
	li $s3, 1			# reset month
	move $t1, $s1			# reset month index
	addi $s5, $s5, 1		# increment year
	j loop

#------------------------------------------
february:				# this function checks if we are in february and in a leap year
	li $t9, 2
	bne $s3, $t9, return		# if not february, go back
	li $t9, 4
	div $s5, $t9			# if not divisible by 4, go back
	mfhi $t9
	bne $t9, $0, return

	addi $t2, $t2, 1		#if it is, add one to t2, and go back

return:
	jr $ra
#------------------------------------------
print:	li $v0, 1
	move $a0, $s3			# print day
	syscall

	li $v0, 11
	li $a0, 92			# print '/'
	syscall

	li $v0, 1
	move $a0, $s2			# print month
	syscall

	li $v0, 11			#print '/'
	li $a0, 92
	syscall

	li $v0, 1			#print year
	move $a0, $s5
	syscall

	li $v0, 10			#exit
	syscall

.end main
