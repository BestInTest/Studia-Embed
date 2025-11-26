#include <8051.h>

__xdata unsigned char* csds = (__xdata unsigned char*) 0xFF30;
__xdata unsigned char* csdb = (__xdata unsigned char*) 0xFF38;

#define DISP P1_6

#define DIGITS 6 // liczba wyœwietlaczy

const unsigned char DIG_SELECT[DIGITS] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20};
const unsigned char SEG_PATH[6] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20}; // "6" w tym przypadku to liczba animacji/przejœæ?

volatile bit timer_flag = 0;

void timer0_init(void) {
    TMOD &= 0xF0;
    TMOD |= 0x01;
    
    TH0 = 0xFC;
    TL0 = 0x66;
    
    ET0 = 1;
    EA = 1;
    TR0 = 1;
}

void t0_int(void) __interrupt(1) {
    TH0 = 0xFC;
    TL0 = 0x66;
    timer_flag = 1;
}

//delay z uzyciem timera
void delay_timer(unsigned int x) {
    unsigned int i;
    for (i = 0; i < x; i++) {
        timer_flag = 0;
        while(!timer_flag); // czekamy az poprzez przerwanie flaga ustawi siê na 1
    }
}

//delay programowy
void delay(unsigned int x) {
	unsigned int i;
	while (x--) {
		for (i = 0; i < 200; i++); // delay poprzez zwiêkszanie 'i'
	}
}

void main(void) {
	signed char seg_index = 0;
	unsigned char iterator;
	signed char dir = 1;
	DISP = 0;
	timer0_init();

	while (1) {
		unsigned char seg = SEG_PATH[seg_index];
		for (iterator = 0; iterator < DIGITS; iterator++) {
			*csdb = seg;
			*csds = DIG_SELECT[iterator];

			delay_timer(3);

			if (P3_5 == 0) {
                dir = -dir; // odwrócenie znaku
                delay_timer(10);
            }
		}

		seg_index += dir; // bedzie dodawac/odejmowac w zaleznosci od tego jaki kierunek mamy wybrany
		if (seg_index >= 6) {
			seg_index = 0;
		}
		if (seg_index < 0) {
            seg_index = DIGITS - 1;
        }
	}
}
