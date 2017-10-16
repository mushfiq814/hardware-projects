/****************************************
Title: IR/LCD sketch for Digital Chord Chart 
Original Sketch: Rudy Schalf
Modified by: Mushfiq Mahmud for the Make Course
Date: 11/11/2014
****************************************/

#include <IRremote.h>
#include <Wire.h> 
#include <LiquidCrystal_I2C.h>
#include <Servo.h>
#include <TimerOne.h>
#include <string.h>

#define servopin 14
Servo myservo;
int lcdStatus = 0;

/*******************
IR & Remote data:
*******************/
#define Power 16753245 //define the IR remote command codes for each button
#define Previous 16720605
#define Next 16712445
#define Play 16761405
#define Return 16756815
#define Num1 16724175
#define Num2 16718055
#define Mode 16736925

int menu; //menu position flag
int RECV_PIN = 11; //IR out pin
#define button results.value //set result.value as the term "button" to easily recall

IRrecv irrecv(RECV_PIN);//instantiate a IR receiver object
decode_results results;//instantiate a decode_results object. This object is separate from the IR receiver.
LiquidCrystal_I2C lcd(0x27,16,2);//instantiate a 16x2 I2C LCD display with address 0x27

/*******************
LED Matrix data:
*******************/
int blinkRate = 100; //blink rate integer for LEDs
const int col[6] = {7,6,5,4,3,2}; //create two arrays that contain the column and row Arduino pins for the LED matrix
const int row[5] = {8,9,10,12,13};
volatile byte c,r,flag,counter;
#define pattern0 { \
  {0,0,0,0,0,0}, \
  {0,0,0,0,0,0}, \
  {0,0,0,0,0,0}, \
  {0,0,0,0,0,0}, \
  {0,0,0,0,0,0}  \
}

#define pattern11 { \
  {0,0,0,0,1,0}, \
  {0,0,1,0,0,0}, \
  {0,1,0,0,0,0}, \
  {0,0,0,0,0,0}, \
  {0,0,0,0,0,0}  \
}

#define pattern12 { \
  {0,0,0,0,1,0}, \
  {0,0,1,1,0,0}, \
  {0,0,0,0,0,0}, \
  {0,0,0,0,0,0}, \
  {0,0,0,0,0,0}  \
}

#define pattern13 { \
  {0,0,0,0,0,0}, \
  {0,1,1,0,0,0}, \
  {0,0,0,0,0,0}, \
  {0,0,0,0,0,0}, \
  {0,0,0,0,0,0}  \
}

#define pattern14 { \
  {0,0,0,0,0,0}, \
  {0,1,0,0,0,0}, \
  {1,0,0,0,1,1}, \
  {0,0,0,0,0,0}, \
  {0,0,0,0,0,0}  \
}

#define pattern15 { \
  {1,0,0,0,1,1}, \
  {0,0,0,1,0,0}, \
  {0,1,1,0,0,0}, \
  {0,0,0,0,0,0}, \
  {0,0,0,0,0,0}  \
}

#define pattern16 { \
  {0,0,0,0,0,0}, \
  {0,0,0,1,0,1}, \
  {0,0,0,0,1,0}, \
  {0,0,0,0,0,0}, \
  {0,0,0,0,0,0}  \
}

#define pattern17 { \
  {0,0,0,0,0,1}, \
  {0,0,0,1,0,0}, \
  {0,0,0,0,1,0}, \
  {0,0,0,0,0,0}, \
  {0,0,0,0,0,0}  \
}

#define pattern18 { \
  {0,0,0,0,0,0}, \
  {0,0,1,1,1,0}, \
  {0,0,0,0,0,0}, \
  {0,0,0,0,0,0}, \
  {0,0,0,0,0,0}  \
}

#define pattern19 { \
  {0,0,0,1,0,0}, \
  {0,1,1,0,0,0}, \
  {0,0,0,0,0,0}, \
  {0,0,0,0,0,0}, \
  {0,0,0,0,0,0}  \
}

#define pattern21 { \
  {0,1,1,1,0,1}, \
  {1,1,0,0,1,1}, \
  {0,0,1,1,0,0}, \
  {1,1,1,1,1,0}, \
  {0,0,0,0,0,0}  \
}

#define pattern22 { \
  {0,0,0,1,0,0}, \
  {1,1,1,1,1,1}, \
  {0,0,0,0,1,0}, \
  {1,1,1,1,0,0}, \
  {1,1,0,0,1,0}  \
}

#define pattern23 { \
  {0,0,0,1,0,1}, \
  {1,1,0,1,1,1}, \
  {0,0,1,0,1,0}, \
  {1,1,1,1,0,0}, \
  {1,1,0,0,0,0}  \
}

#define pattern24 { \
  {0,0,0,0,0,0}, \
  {1,1,1,1,1,1}, \
  {0,0,0,0,0,0}, \
  {0,1,1,1,0,0}, \
  {1,0,0,0,1,1}  \
}

#define pattern25 { \
  {1,0,0,1,0,1}, \
  {0,1,0,0,0,0}, \
  {0,0,1,0,1,0}, \
  {1,0,0,1,0,1}, \
  {0,1,0,0,0,0}  \
}

byte matrix[5][6] = pattern0;
byte pattern_1[5][6] = pattern0;
byte pattern_11[5][6] = pattern11;
byte pattern_12[5][6] = pattern12;
byte pattern_13[5][6] = pattern13;
byte pattern_14[5][6] = pattern14;
byte pattern_15[5][6] = pattern15;
byte pattern_16[5][6] = pattern16;
byte pattern_17[5][6] = pattern17;
byte pattern_18[5][6] = pattern18;
byte pattern_19[5][6] = pattern19;
byte pattern_21[5][6] = pattern21;
byte pattern_22[5][6] = pattern22;
byte pattern_23[5][6] = pattern23;
byte pattern_24[5][6] = pattern24;
byte pattern_25[5][6] = pattern25;


/***************************************************************
setup function
***************************************************************/
void setup() {
  Serial.begin(9600); //begin serial communication
  lcd.init(); //initialize the lcd 
  lcd.backlight();
  irrecv.enableIRIn(); //Start the receiver
  setupLED(); //set LED pins as output and turn them off
  Timer1.initialize(100);
  Timer1.attachInterrupt(refreshScreen);
  myservo.attach(servopin);
  myservo.write(0);
}

/***************************************************************
loop function
***************************************************************/

void loop() {
  if (irrecv.decode(&results)) { //has a transmission been received?
    //Serial.println(button); //If yes: interpret the received commands. This is not necessary. I used this to find the command codes for the buttons of the remote I am using.
    if (menu == 1)  { memcpy(matrix,pattern_1,30); }  
    if (menu == 11) { memcpy(matrix,pattern_11,30); }
    if (menu == 12) { memcpy(matrix,pattern_12,30); }
    if (menu == 13) { memcpy(matrix,pattern_13,30); }
    if (menu == 14) { memcpy(matrix,pattern_14,30); }
    if (menu == 15) { memcpy(matrix,pattern_15,30); }
    if (menu == 16) { memcpy(matrix,pattern_16,30); }
    if (menu == 17) { memcpy(matrix,pattern_17,30); }
    if (menu == 18) { memcpy(matrix,pattern_18,30); }
    if (menu == 19) { memcpy(matrix,pattern_19,30); }
    if (menu == 21) { memcpy(matrix,pattern_21,30); }
    if (menu == 22) { memcpy(matrix,pattern_22,30); }
    if (menu == 23) { memcpy(matrix,pattern_23,30); }
    if (menu == 24) { memcpy(matrix,pattern_24,30); }
    if (menu == 25) { memcpy(matrix,pattern_25,30); }
    
    if (lcdStatus == 0 && button == Power ){ //"Power" button is pressed
      turnonLCD(); //show the welcome screen
      myservo.write(180);
    }
         
    if (lcdStatus == 1 && button == Mode ) {
      turnoffLCD();
      memcpy(matrix,pattern_1,30);
      myservo.write(0);
    }
    
    if (lcdStatus == 0) {
      memcpy(matrix,pattern_1,30);
    }
                                          
    switch (menu) { //create a switch/case context with variable as "menu"
      case 1: //when menu is 1 (when welcome screen is being viewed)
        switch(button) { //create another switch/case context with variable as "button" which is actually "results.value"
          case Num1:
            submenuPrint(1,1); //go to menu 1, submenu 1
            break;
          case Num2:
            submenuPrint(2,1); //go to menu 2, submenu 1
            break;
        }
        break;
              
      case 11:
        switch(button) {
          case Next:
            submenuPrint(1,2); 
            break;
          case Return:
            returnFromSub();
            break;
        }
        break;
            
      case 12:
        switch(button) {
          case Next:
            submenuPrint(1,3);  
            break;
          case Previous:
            submenuPrint(1,1);
            break;
          case Return:
            returnFromSub();
            break;
        }
        break;
        
      case 13:
        switch(button) {
          case Next:
            submenuPrint(1,4);  
            break;
          case Previous:
            submenuPrint(1,2);
            break;
          case Return:
            returnFromSub();
            break;
        }
        break;
        
      case 14:
        switch(button) {
          case Next:
            submenuPrint(1,5);  
            break;
          case Previous:
            submenuPrint(1,3);
            break;
          case Return:
            returnFromSub();
            break;
        }
        break;
        
      case 15:
        switch(button) {
          case Next:
            submenuPrint(1,6);  
            break;
          case Previous:
            submenuPrint(1,4);
            break;
          case Return:
            returnFromSub();
            break;
        }
        break;
        
      case 16:
        switch(button) {
          case Next:
            submenuPrint(1,7);  
            break;
          case Previous:
            submenuPrint(1,5);
            break;
          case Return:
            returnFromSub();
            break;
        }
        break;
        
      case 17:
        switch(button) {
          case Next:
            submenuPrint(1,8);  
            break;
          case Previous:
            submenuPrint(1,6);
            break;
          case Return:
            returnFromSub();
            break;
        }
        break;
        
      case 18:
        switch(button) {
          case Next:
            submenuPrint(1,9);  
            break;
          case Previous:
            submenuPrint(1,7);
            break;
          case Return:
            returnFromSub();
            break;
        }
        break;
        
      case 19:
        switch(button) {
          case Previous:
            submenuPrint(1,8);
            break;
          case Return:
            returnFromSub();
            break;
        }
        break;
             
      case 21:
        switch(button) {
          case Next:
            submenuPrint(2,2);
            break;
          case Return:
            returnFromSub();
            break;
        }
        break;
           
      case 22:
        switch(button) {
          case Next:
            submenuPrint(2,3);  
            break;
          case Previous:
            submenuPrint(2,1);
            break;
          case Return:
            returnFromSub();
            break;
        }
        break;
        
      case 23:
        switch(button) {
          case Next:
            submenuPrint(2,4);  
            break;
          case Previous:
            submenuPrint(2,2);
            break;
          case Return:
            returnFromSub();
            break;
        }
        break;
        
      case 24:
        switch(button) {
          case Next:
            submenuPrint(2,5);  
            break;
          case Previous:
            submenuPrint(2,3);
            break;
          case Return:
            returnFromSub();
            break;
        }
        break;
        
      case 25:
        switch(button) {
          case Previous:
            submenuPrint(2,4);
            break;
          case Return:
            returnFromSub();
            break;
        }
        break;
    }
    
    irrecv.resume(); // Receive the next value
  }
}
