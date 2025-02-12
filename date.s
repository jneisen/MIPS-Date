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

	lw $t0, 0($s0)			# start_date day to t0
	lw $t1, 4($s0)			# start_date month to t1
	
	subi $t1, $t1, 1		# subtract one from month
	sll $t2, $t1, 2			# shift left 2, (mult by 4)
	lw $t3, $t2($s1)		# loads the current month into $t3
	
	
