#include <8051.h>

/*
7seg-4.asm może być wzorem
*/

#define true 1
#define false 0

__xdata unsigned char* csds = (__xdata unsigned char*) 0xFF30;
__xdata unsigned char* csdb = (__xdata unsigned char*) 0xFF38;

#define DISP P1_6
#define DIGITS 6 // liczba wyświetlaczy

const unsigned char DIG_SELECT[DIGITS] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20};
const unsigned char SEG_PATH[6] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20};

//wzory liczb
#define NUM_0 0b00111111
#define NUM_1 0b00000110
#define NUM_2 0b01011011
#define NUM_3 0b01001111
#define NUM_4 0b01100110
#define NUM_5 0b01101101
#define NUM_6 0b01111101
#define NUM_7 0b00000111
#define NUM_8 0b01111111
#define NUM_9 0b01101111

//tablica liczb do łatwego wybierania
const unsigned char NUMBERS[10] = {NUM_0, NUM_1, NUM_2, NUM_3, NUM_4, NUM_5, NUM_6, NUM_7, NUM_8, NUM_9};

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
        while(!timer_flag); // czekamy az poprzez przerwanie flaga ustawi się na 1
    }
}

void main() {

    signed char seg_index = 0;
    unsigned char iter;
    DISP = 0;
    timer0_init();

    while (true) {
        for (iter = 0; iter < DIGITS; iter++) {
            *csds = DIG_SELECT[iter]; // wybieramy wyświetlacz
            *csdb = NUMBERS[iter]; // wprowadzamy dane
            delay_timer(100);
        }
    }
}