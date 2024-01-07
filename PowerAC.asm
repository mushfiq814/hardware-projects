;******************************************************
;   PowerAC.asm
;   EEL 4935-006 Embedded Systems
;   Author: Mushfiq Mahmud
;   Modified from class example
;******************************************************

#include <P18F4550.inc>
 
  CONFIG MCLRE = ON          ; MCLR Pin Enable bit
  CONFIG DEBUG = ON          ; Enable Debug Mode
  CONFIG PBADEN = OFF        ; PORTB PINS 0-4 are digital I/O on POR
  CONFIG WDT = OFF           ; Watchdog Timer Enable bit
  CONFIG LVP = OFF           ; Low voltage programming disabled
  CONFIG FOSC = INTOSCIO_EC  ; Internal Oscilator used as clock source

  org 0   ; start code at 0
 
Start:
  CLRF PORTD ; initialize PORTD
  CLRF TRISD ; ALL PINS OF PORTD ARE OUTPUT
  CLRF PORTB
  SETF TRISB ; PORTB IS INPUT
   
goto main
 
pwron:
  BSF PORTD, 0 ; RD0 PIN IS low
  goto main
 
switchoff:
  BCF PORTD, 0
  GOTO main
               
 main:
  BTFSS PORTB,0  ; check for high at push button(RB0)
  call switchoff
  call pwron
   
 END
