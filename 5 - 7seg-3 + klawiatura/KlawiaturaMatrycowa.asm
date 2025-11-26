CSKB0 EQU 21H ; klawiatura matrycowa: klawisze 0Ö7
CSKB1 EQU 22H ; klawiatura matrycowa: klawisze 8Ö
CSDS EQU 30H ; bufor wyboru wskaünika 7-segmentowego
CSDB EQU 38H ; CSDB bufor danych wskaünika 7-segmentowego

ORG 0
	AJMP START

ORG 40H
START:
	CLR P1.6
	
	MOV R0, #CSDS
	MOV A, #255
	MOVX @R0, A
	
	MOV R0, #CSDB
	MOV A, #255
	MOVX @R0, A

	MOV R1, #CSKB1


PETLA:
	MOVX A, @R1
	MOVX @R0, A

	SJMP PETLA
END