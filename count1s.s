	.text 
	.global _start
_start:
	LDR R4, =TEST_NUM
    MOV R5, #0
MAIN:
	LDR R1, [R4]
    CMP R1, #0
    BEQ END
	BL ONES
    CMP R0, R5
    MOVGT R5, R0
    ADD R4, #4
    B MAIN
ONES:
	MOV R0, #0 
LOOP: CMP R1, #0 // loop until the data contains no more 1’s 
	BEQ E_ONES
	LSR R2, R1, #1 // perform SHIFT, followed by AND 
	AND R1, R1, R2
	ADD R0, #1 // count the string lengths so far 
	B LOOP
E_ONES: MOV pc,lr
END: B END

TEST_NUM: .word 0x605593ba, 0x2f80b73e, 0x3761cfe3, 0x33a6657e, 0x1e4d0780,
		  .word 0x4ad6bd02, 0x7aed5831, 0x7d22e9c4, 0x4cf878c5, 0
// Number of consecutive 1s in order: 3, 5, 7, 6, 4, 4, 4, 5, 5, 0
.end