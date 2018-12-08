.text
.global _start
_start:
	LDR R9, =LIST //R9 = LIST address
    LDR R8, [R9] //R8 = LIST[0] = n
    ADD R9, #4 //R9 = address of second word
    MOV R7, #1 //swapped = true
    B MAIN
RESTART:
	LDR R9, =LIST //R9 = LIST address
    LDR R8, [R9] //R8 = LIST[0] = n
    ADD R9, #4 //R9 = address of second word
    //just the same as _start, but this time don't want to init R7 = 1
MAIN:
	CMP R7, #0
    BEQ END //if swapped=false, done, end
    MOV R6, R8 //R6 = iterator i
    MOV R7, #0 //set swapped = false
LOOP:    
    MOV R0, R9 //R0 = R9 = address of 2nd word
    B SWAP //Takes in R0, returns swapped in R0, uses R0,1,2,3
    
AFTER_SWAP:
    ORR R7, R7, R0 //if swapped, R7 = 1
    SUB R6, #1 //completed one iteration
    ADD R9, #4 //look at next word, i = i + 4
    CMP R6, #1 //finished looping? 
    BEQ RESTART //if yes, start from the beginning
    B LOOP //if not, go on looping
	
SWAP: //Takes in R0, returns in R0
	LDR R2, [R0] //R2 = *R0 = lst[i]
    ADD R1, R0, #4 //R1 = address of word after R0 
    LDR R3, [R1] //R3 = *R1 = lst[i+1]
    CMP R2, R3
    BLGE NO_SWAP //If lst[i] >= lst[i+1], do not swap
    BLLT DO_SWAP //If lst[i] < lst[i+1], do swap
    B AFTER_SWAP 

NO_SWAP:
	MOV R0, #0 //swapped = false
    MOV pc, lr
    
DO_SWAP:
    STR R2, [R1] //lst[i+1] = R2 (= lst[i])
    STR R3, [R0] //lst[i] = R3 (=lst[i+1])
    MOV R0, #1 //swapped = true
    MOV pc, lr

END: 
	B END
LIST: .word 10, 6, 2, 4, 1, 9, 5, 2, 1, -2, 7

.end