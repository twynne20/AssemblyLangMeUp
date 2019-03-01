############################################################
#  Description: define a recursive procedure/function and call it.
#            use syscall operations to display integers and strings on the console window
#            use syscall operations to read integers from the keyboard.
#############################################################

#data declarations: declare variable names used in program, storage allocated in RAM
	.data
promptMessage: .asciiz "Enter an integer:\n"
resultMessage: .asciiz "The solution is:\n"
intN:          .word  0
intAns:        .word  0

.text
	.globl main  # define a global function main

  # the program begins exectution at main()
main:

  # Print promptMessage to Console
	la $a0, promptMessage # $a0 = address of promptMessage
	li $v0, 4  # $v0 = 4  --- this is to call print_string()
	syscall # call print_string()

  ### Read an integer from a user input and store it in num2 ###
  # Read an integer from a user input
  li $v0, 5  # $v0 = 5 ----- this is to call read_int
  syscall   # call print_string()
  move $a0, $v0  # store the value from user input into intN

  # Call function1 jump and link
	# since you didn't create the space for memory you have to do this in
	# your callee.
  jal function1

  move $t1, $v1  # store the return value in $t1

  # Display the results
  la $a0, resultMessage # $a0 = address of resultMessage
  li $v0, 4  # $v0 = 4  --- this is to call print_string()
  syscall # call print_string()

  move $a0, $t1 # $a0 = address of resultMessage
  li $v0, 1  # $v0 = 4  --- this is to call print_string()
  syscall # call print_string()

  # Tell the OS that this is the end of the program (terminate the program)
	# if you would have created the stack and memory space in the main you would
	# have to use jr $ra
  li $v0, 10
  syscall

	############################################################################
	# Procedure/Function function1
	# Description: This is our recurvise function, you will carry out your else in This
	# and branch to your if for your case
	# parameters: $a0 = n (user input)
	# return value: $v2 = ans1
	# registers to be used: $s0, $s1, and $s2 will be used.
	############################################################################
function1:
  subu $sp, $sp, 16  # create the space in the stack (you will have to pop this)
	sw $ra, 0($sp)
  sw $s0, 4($sp)
	sw $s1, 8($sp)
  sw $s2, 12($sp)
	move $s0, $a0

	# Base Case: int ans1 = (2*n)+9
  ble $a0, 5, ifFunction  # branch to if Function if greater than or equal to 5

	# calling function1(n-2)
	subu $a0, $s0, 2
	jal function1  # Jump and link to function1(n-2)
	move $s1, $v1  # store the return of function1(n-2)

	# calling function1(n-3)
	subu $a0, $s0, 3 # Subract 3 from the n value.. the arguement
	jal function1  # Jump and link to function1(n-2)
	move $s2, $v1  # store the return of function1(n-3)

	#calculations for ans1
	mult $s0, $s2
	mflo $t1 #stores product in t1
	add $t1, $t1, $s1 #sums two arguments
	addi $t2, $zero, 2
	mult $t2, $s0  #n *2
	mflo $t2
	sub $v1, $t1, $t2 #subtracts sum with 2n

	j exit

	############################################################################
	# Procedure/Function ifFunction
	# Description: BASE CASE: This will be where you branch to if n <= 5..
	# creat the Arithimetic (2*n)+9
	# parameters: $s0 = n
	# return value: $v1 = ans1
	# registers to be used: $s0, $s1, and $s2 will be used.
	############################################################################
ifFunction: # int ans1 = (2*n)+9 BASE CASE
		li $t3, 2  # load 2 into $t3
		mult $t3, $s0 # Arithimetic: (2*n)
		mflo $t3 # Collects the second part
		addi $t3, $t3, 9  # Arithimetic: (2*n)+9
		move $v1, $t3 # You are returning the value recieved in $v1 to the main
		j exit # Jump to exit and restore the stack


		############################################################################
		# Procedure/Function exit
		# Description: Restore the stack
		# parameters: $s0 = n
		# return value: $v1 = ans1
		# registers to be used: $s0, $s1, and $s2 will be used.
		############################################################################
exit:
	# Restore the stack (pop the stack)
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra
