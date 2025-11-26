CSDS EQU 30H; bufor wyboru wskaŸnika 7-segmentowego
CSDB EQU 38H; bufor danych wskaŸnika 7-segmentowego
CZAS EQU 079H; Tablica wyœwietlanego czasu
SS EQU 078H
MM EQU 077H
HH EQU 076H

ORG 0
	LJMP START

ORG 40H
START:
	MOV R7, #00000001B ; Rejestr przechowuj¹cy aktualnie wybrany wyœwietlacz
	MOV DPTR, #WZORY ; Zapis adresów wzorów do DPTR
	MOV R4, #0 ; Aktualnie wyœwietlany symbol

	MOV CZAS+6, #6 ; sekundy (+6 bo 6 segmentów wyœwietlacza)
	MOV CZAS+5, #4 ; 10x sekundy
	MOV CZAS+4, #0 ; minuty
	MOV CZAS+3, #3 ; 10x minuty
	MOV CZAS+2, #2 ; godziny
	MOV CZAS+1, #1 ; 10x godziny
	
	MOV CZAS+0, #8 ; Ledy

	MOV SS, #46
	MOV MM, #30
	MOV HH, #12
	
	MOV R1, #CZAS+6

PETLA:
	;CLR P1.6 ; W³¹czenie wyœwitlacza
	MOV R0, #CSDB ; Przenieœ do R0 adres CSDB
	MOV A, @R1 ; Przenieœ do akumulatora aktualnie wybrany symbol
	DEC R1

	SETB P1.6 ; Wy³¹czenie wyœwietlacza na czas aktualizacji

	;MOVC A, @A+DPTR ; Pobranie wzoru dla segmentu
	MOVX @R0, A ; Wysy³amy wzór symbolu do CSDB
	MOV R0, #CSDS ; Przenieœ do R0 adres CSDS
	MOV A, R7 ; Przenieœ do akumulatora wybrane wyœwietlacze
	MOVX @R0, A ; Wysy³amy wybór do CSDS

	CLR P1.6 ; Ponowne w³¹czenie wyœwietlacza
	RL A ; Przesuniêcie (rotacja) w lewo aktualnego wyœwietlacza

	; Sprawdzamy siódmy bit w ACC, jeœli nie jest ustawiony to skaczemy do NOACC7
	JNB ACC.7, NOACC7
	MOV R1, #CZAS+6

	INC SS ; zwiêkszanie licznika sekund
	MOV A, SS
	CJNE A, #60, ACCNIE60 ; skoczenie do procedury tylko jeœli SS nie bêdzie równe 60 (aby nie wyjœæ poza zakres 60 sekund)
	MOV SS, #0

	INC MM
	MOV A, MM
	CJNE A, #60, ACCNIE60
	MOV MM, #0

	INC HH
	MOV A, HH
	CJNE A, #24, ACCNIE60
	MOV HH, #0
ACCNIE60:
	ACALL PRZELICZ ; wywo³anie procedury
	MOV A, #00000001B
NOACC7:
	MOV R7, A ; Zapis wybranego wyœwietlacza po rotacji
	MOV R5, #4

DELAY:
	;DJNZ R6, DELAY
	;DJNZ R5, DELAY

	SJMP PETLA

PRZELICZ:
	MOV A, SS
	MOV B, #10
	DIV AB ; dzielenie
	
	; Aktualizacja segmentów do wyœwietlania
	MOVC A, @A+DPTR ;
	MOV CZAS+5, A
	MOV A, B
	MOVC A, @A+DPTR
	MOV CZAS+6, A

	MOV A, MM
	MOV B, #10
	DIV AB ; dzielenie
	MOVC A, @A+DPTR ;
	MOV CZAS+3, A
	MOV A, B
	MOVC A, @A+DPTR
	MOV CZAS+4, A

	MOV A, HH
	MOV B, #10
	DIV AB ; dzielenie
	MOVC A, @A+DPTR ;
	MOV CZAS+1, A
	MOV A, B
	MOVC A, @A+DPTR
	MOV CZAS+2, A

	MOV CZAS+0, #255 ; œwiecenie ledów
	RET

WZORY:
DB 00111111B, 00000110B, 01011011B, 01001111B ; od 0 do 3
DB 01100110B, 01101101B, 01111101B, 00000111B ; od 4 do 7
DB 01111111B, 01101111B, 01110111B, 01111100B ; od 8 do B
DB 01011000B, 01011110B, 01111001B, 01110001B ; od C do F

END