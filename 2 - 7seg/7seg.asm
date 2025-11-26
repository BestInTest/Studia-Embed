CSDS EQU 30H; bufor wyboru wskaŸnika 7-segmentowego
CSDB EQU 38H; bufor danych wskaŸnika 7-segmentowego

ORG 0
	LJMP START

ORG 40H
START:
	MOV R7, #00000001B ; Rejestr przechowuj¹cy aktualnie wybrany wyœwietlacz
	MOV DPTR, #WZORY ; Zapis adresów wzorów do DPTR
	MOV R4, #0 ; Aktualnie wyœwietlany symbol

PETLA:
	CLR P1.6 ; W³¹czenie wyœwitlacza
	MOV R0, #CSDB ; Przenieœ do R0 adres CSDB
	MOV A, R4 ; Przenieœ do akumulatora aktualnie wybrany symbol
	INC R4
	MOVC A, @A+DPTR ; Pobranie wzoru dla segmentu
	MOVX @R0, A ; Wysy³amy wzór symbolu do CSDB

	MOV R0, #CSDS ; Przenieœ do R0 adres CSDS
	MOV A, R7 ; Przenieœ do akumulatora wybrane wyœwietlacze
	MOVX @R0, A ; Wysy³amy wybór do CSDS

	RL A ; Przesuniêcie (rotacja) w lewo aktualnego wyœwietlacza

	; Sprawdzamy siódmy bit w ACC, jeœli nie jest ustawiony to skaczemy do NOACC7
	JNB ACC.7, NOACC7
	MOV R4, #0
	MOV A, #00000001B
NOACC7:
	MOV R7, A ; Zapis wybranego wyœwietlacza po rotacji

DELAY:
	;DJNZ R6, DELAY
	DJNZ R5, DELAY

	SJMP PETLA

WZORY:
DB 00111111B, 00000110B, 01011011B, 01001111B ; od 0 do 3
DB 01100110B, 01101101B, 01111101B, 00000111B ; od 4 do 7
DB 01111111B, 01101111B, 01110111B, 01111100B ; od 8 do B
DB 01011000B, 01011110B, 01111001B, 01110001B ; od C do F

END