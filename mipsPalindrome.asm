## $t1 - A
## $t2 - B
## $t3 - the character at address A.
## $t4 - the character at address B.
## $v0 - syscall parameter / return values
## $a0 - Syscall parameters
## $a1 - syscall parameters

.text
main:
    la $a0, startPrompt 	#ask the user for input. 
    li $v0, 4
    syscall
    				#read the string S:
    la $a0, string_space 	
    li $a1, 1024
    li $v0, 8			#load "read_string" code into $v0
    syscall 			
			
    la $t1, string_space		#A=S
    la $t2, string_space		#B
    					#we need to move B to the end of the string
length_loop:
        lb $t3, ($a0)			#load the next bite of the string (B) into $t3 for testing characters
        beqz $t3, end_length_loop	#end loop if no more charicters
        
        				##tests to get rid of characters by decimal codes.
        bgt $t3, 47, test1		#test if the charicter is within the range of acceptible Ascii codes (0 = 48)
        b notToString			#else if less than 48 dont add to string
        			
        			
test1: 
	blt $t3, 58, addToString 	#tests if the charicter is within the Ascii numbers (0-9) codes (9 = 57)
        bgt $t3, 64, test2		#tests if the charicter is within the Ascii uppercase letters (A = 65)
        b notToString			#else if between 58 and 64  dont add to string
        
test2: 
	blt $t3, 91, addToString  	#tests if the charicter is within the Ascii uppercase letters (Z = 90)
        bgt $t3, 96, test3		#tests if the charicter is within the Ascii lowercase letters (a = 97)
        b notToString			#else between 91 and 96 dont add to string
        
test3: 
	blt $t3, 123, addToString	#test if the charicter is within the range of acceptible Ascii codes (z = 122)
        b notToString			#else greater than 122 dont add to string
    
addToString: 				#add the charicter back to the new string $t3
        blt $t3, 96, makeLower		#if the charicter is not 
        b notLower
        
notToString: 				#do not add charicter to new string
        addi $a0, $a0, 1 		#increment user string input 
        b length_loop			#check next charicter
        
makeLower: 
	addi $t3, $t3, +32 		#this is to make our sting case-insensitive by adding 32
        
notLower:
        sb $t3, ($t2)	
        addi $a0, $a0, 1 		#increment each memory location
        addi $t2, $t2, 1
        b length_loop			#check next charicter

end_length_loop:    
    	subu $t2, $t2, 1   		#decrement from end of $t2 to move back past 0
    
test_loop:          			#they are the same string. Just starting from both ends
        bge $t1, $t2, is_palin		#if A >= B, it's a palindrome because you have reached the center of the string
        lb $t3, ($t1)   		#load the byte at addr A into $t3
        lb $t4, ($t2)      		#load the byte at addr B into $t4
        bne $t3, $t4, not_palin 	#if the byte at $t3 != $t4 byte then its not a palindrome

        addu $t1, $t1, 1 		#incrememnt A closer to middle
        subu $t2, $t2, 1 		#decrememnt B closer to middle going reverse
        b test_loop   			#and repeat the loop

is_palin:
        la $a0, is_palin_msg		#print message that its a palin and exit
        li $v0, 4   		
        syscall
        b exit

not_palin:
        la $a0, not_palin_msg 		#print message that its not a palin and exit
        li $v0, 4
        syscall
        b exit 			

exit:
    	li $v0, 10			#exit program
    	syscall

##data storage
	.data 
string_space: .space 1024 		#reserve 1024 bytes for the string
is_palin_msg: .asciiz "The string is a palindrome.\n"
not_palin_msg: .asciiz "The string is not a palindrome.\n"
goAgainInput: .space 4
startPrompt: .asciiz "\nEnter a string to see if it is a palindrome: "
