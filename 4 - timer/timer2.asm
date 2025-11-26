ORG 0
	AJMP START

ORG 0BH ; adres obs³ugi przerwania timera
	SETB F0
	MOV TH0, #226
	RETI ; RETurn from Interrupt

ORG 40H
START:
	SETB ET0 ; w³¹cza przerwanie od timer0
	SETB EA ; globalna zgoda na przerwania

	MOV TMOD, #01110000B ; ustawienia timera: timer1 OFF, timer2 -> TRYB 2
	MOV TH0, #226
	SETB TR0 ; start licznika/timera 0
	
	MOV R4, #4
	MOV R3, #240
PETLA:
	JNB F0, PETLA ; je¿eli F0
	CLR F0
	DJNZ R3, PETLA
	DJNZ R4, PETLA

	CPL P1.7
	MOV R4, #4
	MOV R3, #240

	SJMP PETLA
END