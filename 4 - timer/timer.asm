ORG 0
	AJMP START

ORG 0BH ; adres obs³ugi przerwania timera
	CPL P1.7 ; prze³¹cz brzêczyk
	MOV TH0, #226
	RETI ; RETurn from Interrupt

ORG 40H
START:
	SETB ET0 ; w³¹cza przerwanie od timer0
	SETB EA ; globalna zgoda na przerwania

	MOV TMOD, #01110000B ; ustawienia timera: timer1 OFF, timer2 -> TRYB 2
	MOV TH0, #226
	SETB TR0 ; start licznika/timera 0


	SJMP $
END