;******************************************************
;   ADCDisplay_new.asm
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
  ;set portD as output
  CLRF PORTD
  CLRF TRISD

  ;initialize ADCON registers
  MOVLW B'00000001'; AN0 selected
  MOVWF ADCON0
  MOVLW B'00001110'; AN0 selected as analog
  MOVWF ADCON1
  MOVLW B'10100111'; Right justified, 8 TAD, FRC
  MOVWF ADCON2
  
  ;initialize analog pin as input
  BSF TRISE,AN0
  
  ;initialize T0CON registers
  MOVLW 0x07; B'00000111' 1:256 Prescalar, 16 bit selected
  MOVWF T0CON

  ;Equate/ allocate registers for ADC values
  SAVEDH EQU 0x05
  SAVEDL EQU 0x06
  MOVLW 0xFF; B'11111111'
  MOVWF SAVEDH
  MOVLW 0xAA; B'10101010'
  MOVWF SAVEDL
    
MainLoop:
  CALL Delay ;very short delay 
  
  ;Wait for ADC converter
  BSF ADCON0,GO_DONE
  AGAIN BTFSC ADCON0,GO_DONE
  BRA AGAIN
  
  MOVFF ADRESH,SAVEDH ;Pass ADC values to registers
  MOVFF ADRESL,SAVEDL
  
  GOTO CheckFunc ;check function
  
  GOTO MainLoop ;do it again
  
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

CheckFunc:
  MOVLW 0x03; decimal 3
  CPFSLT SAVEDH; compare ADRESL with 3, skip if ADRESL < 3
  GOTO FuncSet1; only values between decimal 768 and 1024 will pass
  
  MOVLW 0x02; decimal 2
  CPFSLT SAVEDH; compare ADRESL with 2, skip if ADRESL < 2
  GOTO FuncSet2; only values between decimal 512 and 768 will pass
  
  MOVLW 0x01; decimal 1
  CPFSLT SAVEDH; compare ADRESL with 1, skip if ADRESL < 1
  GOTO FuncSet3; only values between decimal 256 and 512 will pass
  
  MOVLW 0x00; decimal 0
  CPFSLT SAVEDH; compare ADRESL with 0, skip if ADRESL < 0
  GOTO FuncSet4; only values between decimal 0 and 256 will pass
  
FuncSet1:
  MOVLW 0x80; decimal 128
  CPFSLT SAVEDL; compare ADRESL with 128, skip if ADRESL < 128
  GOTO FuncSet11; only values between 896 and 1024 will pass
  GOTO FuncSet12; only values between 768 and 896 will pass
  
FuncSet2:
  MOVLW 0x80; decimal 128
  CPFSLT SAVEDL; compare ADRESL with 128, skip if ADRESL < 128
  GOTO FuncSet21; only values between 896 and 1024 will pass
  GOTO FuncSet22; only values between 768 and 896 will pass
  
FuncSet3:
  MOVLW 0x80; decimal 128
  CPFSLT SAVEDL; compare ADRESL with 128, skip if ADRESL < 128
  GOTO FuncSet31; only values between 896 and 1024 will pass
  GOTO FuncSet32; only values between 768 and 896 will pass
  
FuncSet4:
  MOVLW 0x80; decimal 128
  CPFSLT SAVEDL; compare ADRESL with 128, skip if ADRESL < 128
  GOTO FuncSet41; only values between 896 and 1024 will pass
  GOTO FuncSet42; only values between 768 and 896 will pass

FuncSet11:
  MOVLW b'11111111'
  MOVWF PORTD
  GOTO MainLoop
  
FuncSet12:
  MOVLW b'10000111'
  MOVWF PORTD
  GOTO MainLoop
  
FuncSet21:
  MOVLW b'11111101'
  MOVWF PORTD
  GOTO MainLoop
  
FuncSet22:
  MOVLW b'11101101'
  MOVWF PORTD
  GOTO MainLoop
  
FuncSet31:
  MOVLW b'11100110'
  MOVWF PORTD
  GOTO MainLoop
  
FuncSet32:
  MOVLW b'11001111'
  MOVWF PORTD
  GOTO MainLoop
  
FuncSet41:
  MOVLW b'11011011'
  MOVWF PORTD
  GOTO MainLoop
  
FuncSet42:
  MOVLW b'10000110'
  MOVWF PORTD
  GOTO MainLoop    
  
  end