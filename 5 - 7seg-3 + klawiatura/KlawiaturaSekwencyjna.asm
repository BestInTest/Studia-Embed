CSDS EQU 30H ; bufor wyboru wskaünika 7-segmentowego
CSDB EQU 38H ; CSDB bufor danych wskaünika 7-segmentowego

ORG 0
	AJMP START

ORG 40H
START:
	CLR P1.6

	MOV R0, #CSDB
	MOV A, #255
	MOVX @R0, A
	
	MOV R0, #CSDS
	MOV R7, #00000001B

PETLA:
	MOV A, R7
	MOVX @R0, A
	
	MOV C, P3.5
	MOV P1.6, C
DELAY:
	DJNZ R6, DELAY

	RL A
	MOV R7, A

	SJMP PETLA
END