#include <8051.h>

__xdata unsigned char* csds = (__xdata unsigned char*) 0xFF30;
__xdata unsigned char* csdb = (__xdata unsigned char*) 0xFF38;

#define DISP P1_6

#define DIGITS 6 // liczba wyœwietlaczy

const unsigned char DIG_SELECT[DIGITS] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20};
const unsigned char SEG_PATH[6] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20}; // "6" w tym przypadku to liczba animacji/przejœæ?

void delay(unsigned int x) {
	unsigned int i;
	while (x--) {
		for (i = 0; i < 200; i++); // delay poprzez zwiêkszanie 'i'
	}
}

void main(void) {
	unsigned char seg_index = 0;
	unsigned char iterator;
	DISP = 0;
	
	while (1) {
		unsigned char seg = SEG_PATH[seg_index];
		for (iterator = 0; iterator < DIGITS; iterator++) {
			*csdb = seg;
			*csds = DIG_SELECT[iterator];
			
			delay(1);
		}
		
		seg_index++;
		if (seg_index >= 6) {
			seg_index = 0;
		}
	}
}
