;******************************************************
;   ADCDisplay.asm
;   EEL 4935-006 Embedded Systems
;   Author: Mushfiq Mahmud
;   Modified from class example
;******************************************************

#include <p18F4550.inc>

	CONFIG WDT	= OFF; disable watchdog timer
	CONFIG MCLRE	= ON; MCLEAR Pin on
	CONFIG DEBUG	= ON; Enable Debug Mode
	CONFIG LVP	= OFF; Low-Voltage programming disabled (necessary for debugging)
	CONFIG FOSC	= INTOSCIO_EC; Internal oscillator, port function on RA6

	org 0; start code at 0

Start:
  ;set portD
  CLRF PORTD
  CLRF TRISD

  ;initialize ADCON registers
  MOVLW B'00000001'; AN0 selected
  MOVWF ADCON0
  MOVLW B'00001010'
  MOVWF ADCON1
  MOVLW B'10100111'
  MOVWF ADCON2
  
  ;initialize analog pins as input
  BSF TRISE,AN0
  BSF TRISE,AN1
  BSF TRISE,AN2
  
  ;initialize T0CON registers
  MOVLW 0x07; B'00000111' 1:256 Prescalar
  MOVWF T0CON

  ;Equate/ allocate registers for ADC values
  SAVEDH EQU 0x05
  SAVEDL EQU 0x06
  MOVLW 0xFF
  MOVWF SAVEDH
  MOVLW 0xAA
  MOVWF SAVEDL
  
MainLoop:
  CALL Delay ;very short delay 
  
  BCF PORTB,RB1 ;PORTB setup 
  BCF PORTB,RB2
  ;Wait for ADC converter
  BSF ADCON0,GO_DONE
  AGAIN BTFSC ADCON0,GO_DONE
  BRA AGAIN
  
  MOVFF ADRESH,SAVEDH ;Pass ADC values to registers
  MOVFF ADRESL,SAVEDL
  
  GOTO LookupFunct ;lookup funct
  
  GOTO MainLoop
  
Delay:
  MOVLW 0xFF   ; Set Timer
  MOVWF TMR0H
  MOVLW 0xAF
  MOVWF TMR0L
  BCF INTCON,TMR0IF ;clear counter done
  BSF T0CON, TMR0ON ;enable counter
  
  ;branch decrementing counter 
  AGAIN3 BTFSS INTCON, TMR0IF
  BRA AGAIN3
  BCF T0CON, TMR0ON ;clear timer done
  Return
  
Function99:
  ;set rd6 rd3 rd1 rd4 rd0 rb1 rb2
  MOVLW b'01011011'
  XORLW 0xFF
  MOVWF PORTD
  GOTO MainLoop
  
Function88: 
  ;set rd6 rd3 rd1 rd0 rd5 rd7 rd4
  MOVLW b'11111011'
  XORLW 0xFF
  MOVWF PORTD
  GOTO MainLoop
      
Function77:
  ;set  rd3 rd1 rd0 
  MOVLW b'00001011'
  XORLW 0xFF
  MOVWF PORTD
  GOTO MainLoop
  
Function66:
  ;set  rd6 rd7 rd5 rd0 rd4 
  MOVLW b'11110001'
  XORLW 0xFF
  MOVWF PORTD
  GOTO MainLoop
  
Function55:
  ;set  rd6 rd3 rd5 rd0 rd4 
  MOVLW b'01111001'
  XORLW 0xFF
  MOVWF PORTD
  GOTO MainLoop
  
Function44:
  ;set  rd6   rd0 rd4 RD1
  MOVLW b'01010011'
  XORLW 0xFF
  MOVWF PORTD
  GOTO MainLoop
  
Function33:
  ;set  rd3   rd0 rd4 RD1 rd5
  MOVLW b'00111011'
  XORLW 0xFF
  MOVWF PORTD
  GOTO MainLoop
  
Function22:
  ;set rd3 rd7 rd4 RD1 rd5
  MOVLW b'10111010'
  XORLW 0xFF
  MOVWF PORTD
  GOTO MainLoop
  
Function11:
  ;set  RD1 rd0
  MOVLW b'00000011'
  XORLW 0xFF
  MOVWF PORTD
  GOTO MainLoop
  
Function00:
  ;set  RD1 rd0 rd5 rd7 rd6 rd3
  MOVLW b'11101011'
  XORLW 0xFF
  MOVWF PORTD
  GOTO MainLoop
  
  
LookupFunct:
  MOVLW 0x00
  MOVWF PORTD
  
  MOVLW 0xFA
  ;compare W and 250 skip is less than
  CPFSLT SAVEDL
  GOTO Function99
    
  ;compare W and 244 skip is less than
  MOVLW 0xF4
  CPFSLT SAVEDL
  GOTO Function88
      
  ;compare W and 192 L skip is W<L
  MOVLW 0xC0
  CPFSLT SAVEDL
  GOTO Function77
  
  ;compare W and 160 L skip is W<L
  MOVLW 0xA0
  CPFSLT SAVEDL
  GOTO Function66
  
  ;compare W and 137 L skip is W<L
  MOVLW 0x89
  CPFSLT SAVEDL
  GOTO Function55
  
  ;compare W and 120 L skip is W<L
  MOVLW 0x78
  CPFSLT SAVEDL
  GOTO Function44
  
  ;compare W and 100 L skip is W<L
  MOVLW 0x64
  CPFSLT SAVEDL
  GOTO Function33

  ;compare W and 80 L skip is W<L
  MOVLW 0x50
  CPFSLT SAVEDL
  GOTO Function22

  ;compare W and 40 L skip is W<L
  MOVLW 0x28
  CPFSLT SAVEDL
  GOTO Function11
  
  GOTO Function00
  GOTO MainLoop
  
  end