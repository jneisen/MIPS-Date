.data
message: .asciiz "Hello, world"

.text
.globl main
main:	la $a0, message
	li $v0, 4 		# this should load print_string
	syscall
	jr $ra			#return to caller
