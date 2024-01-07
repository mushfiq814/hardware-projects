;******************************************************
;   HelloWorld.asm
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

org 0; start programing at 0

Delay1 res 2 ;Save 2 bytes for the two delay variables since we want
Delay2 res 2 ;the delays to be longer

START:
  CLRF PORTD ;make port d an output
  CLRF TRISD ;make tristate port d an output

  CLRF Delay1 ;clear the variable regs and make output
  CLRF Delay2

MAIN:
  BTG PORTD,RD0 ;Toggle the D0 pin where the LED is connected
  GOTO DELAY ;Loop to delay section

DELAY:
  DECFSZ Delay1,1 ;Decrement the value of Delay1 and store it in file instead of W reg until the value is 0 and skip next line whe output is 0
  GOTO DELAY      ;Unless 0 is reached, keep decrementing
  DECFSZ Delay2,2 ;Do the same for Delay2
  GOTO DELAY

  GOTO MAIN ;loop over to min loop again

  END