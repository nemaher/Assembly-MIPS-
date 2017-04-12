.data
	prompt: .asciiz "Enter a number to find out its factors."
	message: .asciiz "after while loop is done"
	space: .asciiz " "
	primeNum: .asciiz "\nYour number only divides by 1 and itself so it's prime!"
.text 
	
main:	li $v0, 4	#prompt user to enter a number
	la $a0, prompt
	syscall

	li $v0, 5		#get the users number
	syscall

	move $t0, $v0		#store the users number in t0
	
	addi $t1, $zero, 0 	# make sure $t1(i) = 0 by adding 0 and 0
	
	while:
	bgt $t1, $t0, exit	#if $t1(i) is greater than $t0 exit
	addi $t1, $t1, 1	#adds 1 to $t0(i++)
	
	div $t0, $t1			#divides the current number $t0(i) by the users input $t1
	mfhi $s1			#stores the quotent in $s1
	beq $s1, $zero, printNumber	#if the quotent is 0 jump to printnumber
	
	j while			#jumps back to start of while loop
	
	exit:
	
	beq $t3, 1, prime	#if the counter $t3 = 1 then branch to prime
	beq $t3, 2, prime 	#if the counter $t3 = 2 then branch to prime
	
	li $v0, 10		#exit the program
	syscall 
	
	printNumber:
	
	li $v0, 1
	add $a0, $t1, $zero	#print the number by storing $t1 into $a0 (easly do this by adding zero and $t1)
	syscall
	
	li $v0, 4		#prints a space between the numbers
	la $a0, space
	syscall
	
	addi $t3, $t3, 1	#adds one to the counter $t3
	
	j while			#jump back go start of while loop
	
	prime:
	li $v0, 4		#prints if the number is prime
	la $a0, primeNum
	syscall
	
	li $v0, 10		#ends the program
	syscall 
