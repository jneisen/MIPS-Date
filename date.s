# date project : goal is to be able to add days to the current date
.data
month_array:	.word	31, 28, 31, 30, 31, 30, 31, 31, 30, 31
		.word 	30, 31
ask_day:	.asciiz "What is day of the month is it today?\n"
ask_month:	.asciiz "What month are we in?\n"
ask_year:	.asciiz "What year is it?\n"
ask_num_days:	.asciiz "How many days forward?\n"

TWELVE = 12

# code time
# Approach:
#	-Loop through array
#		-Subtracting days + adding months
#		-If we get to a year, go back to the start
#	-Print out the end date

.text
.globl main

main:	
	li $v0, 4			# ask for the current day
	la $a0 ask_day
	syscall

	li $v0, 5
	syscall
	move $s1, $v0

	li $v0, 4			# ask for the current month
	la $a0 ask_month
	syscall

	li $v0, 5
	syscall
	move $s2, $v0

	li $v0, 4			#ask for the current year
	la $a0 ask_year
	syscall

	li $v0, 5
	syscall
	move $s3, $v0

	li $v0, 4			#ask for the amount of days
	la $a0 ask_num_days
	syscall

	li $v0, 5
	syscall
	move $s4, $v0
					# s1 = current day, s2 = current month, s3 = current year, s4 = num_days
	la $s0 month_array		# s0: month_array

	addi $t1, $s2, -1		# subtract one from month
	sll $t1, $t1, 2			# shift left 2, (mult by 4)
	add $t1, $t1, $s0		# add to beginning address
	
	lw $t2, ($t1)			# loads the current month into $t2
	jal february

	sub $s1, $t2, $s1		# days left in current month
	sub $t3, $s4, $s1		# num days - days left	

	ble $t3, $0, print 		# if(num_days would be <= 0): print
	
	move $s4, $t3
	addi $s2, $s2, 1
	addi $t1, $t1, 4

#------------------------------------------
loop:	
	lw $t2, ($t1)
	jal february
	
	sub $t3, $s4, $t2		# if this month is too much, print
	ble $t3, $0, print

	move $s4, $t3			# otherwise, continue to next month
	addi $s2, $s2, 1
	addi $t1, $t1, 4

	bgt $s2, TWELVE, reset
	j loop

#------------------------------------------
reset:
	li $s2, 1			# reset month
	move $t1, $s0			# reset month index
	addi $s3, $s3, 1		# increment year
	j loop

#------------------------------------------
february:				# this function checks if we are in february and in a leap year
	li $t9, 2
	bne $s2, $t9, return		# if not february, go back
	li $t9, 4
	div $s3, $t9			# if not divisible by 4, go back
	mfhi $t9
	bne $t9, $0, return

	addi $t2, $t2, 1		#if it is, add one to t2, and go back

return:
	jr $ra
#------------------------------------------
print:	li $v0, 1
	move $a0, $s2			# print month
	syscall

	li $v0, 11
	li $a0, 92			# print '/'
	syscall

	li $v0, 1
	move $a0, $s4			# print day
	syscall

	li $v0, 11			#print '/'
	li $a0, 92
	syscall

	li $v0, 1			#print year
	move $a0, $s3
	syscall

	li $v0, 10			#exit
	syscall

.end main
