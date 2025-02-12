# date project : goal is to be able to add days to the current date
.data
month_array:	.word	31, 28, 31, 30, 31, 30, 31, 31, 30, 31
		.word 	30, 31
# data doesn't need to be stored in longs necessarily

start_date:	.word	2, 12, 2025
num_days:	.word	50

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
	la $s2 num_days			# s2: num_days
	lw $s3 0($s0)			# s3: month tracker

	lw $t0, 4($s0)			# start_date day to $t0
	
	addi $t1, $s0, -1		# subtract one from month
	sll $t1, $t1, 2			# shift left 2, (mult by 4)
	add $t1, $t1, $s1		
	lw $t2, ($t1)			# loads the current month into $t2
	
	sub $t0, $t2, $t0		# days left in current month
	sub $t3, $s2, $t0		# num days - days left	

	ble $t3, $0, print 		# if(num_days would be <= 0): print
	move $s2, $t3
	addi $s3, $s3, 1		# went through one month

loop:	

print:	move $a0, $s2			# test print
	li $v0, 1
	syscall				
	li $v0, 10
	syscall

.end main
