;******************************************************
;   BlinkLEDwTimer.asm
;   EEL 4935-006 Embedded Systems
;   Author: Mushfiq Mahmud
;   Modified from class example
;******************************************************

#include <p18F4550.inc> 
;include the controller library to use all the predefined definitions

CONFIG WDT    = OFF       ;Turn watchdog timer off
CONFIG MCLRE  = ON        ;Turn on the master clear pin
CONFIG DEBUG  = ON        ;Turn debug on
CONFIG LVP    = OFF       ;Turn low voltage power off
CONFIG FOSC   = INTOSC_EC ;Turn internal oscillator on since we are not using external

org 0
BCF TRISD,1;    PD1 as an output
 
MOVLW 0x06;    Timer 16-bit int 
  MOVWF T0CON;     load T0CON reg

HERE MOVLW 0xE1;    TMROH=E1
  MOVWF TMR0H;     load Timer0 high byte
  MOVLW 0x7B;      TIMER=7B
  MOVWF TMR0L;   load Timer0 low byte
  BCF INTCON, TMR0IF;    clear timer interrupt flag bit
  BTG PORTD,1;   
  BSF T0CON, TMR0ON;   start Timer0

AGAIN BTFSS INTCON, TMR0IF;   monitor Timer0 flag until
  BRA AGAIN;              it rolls over 
  BCF T0CON, TMR0ON;    stop Timer0
  BRA HERE;       load TH TL again

end