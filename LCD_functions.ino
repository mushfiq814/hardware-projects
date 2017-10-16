/*******************************************************************************************************************
LCD menu info:
Note: menu screens are assigned as numbers to the integer "menu":
      menu = 1 denotes the welcome screen
      menu with two digits are as follows:
      * first digit shows the submenu number. 1 for 1st submenu, 2 for 2nd submenu, etc.
      * second digit shows the item number in the submenu. 1 for 1st item, 2 for second item, etc.
      * e.g. menu = 21 means 2nd submenu, 1st item
********************************************************************************************************************/

void turnonLCD() {
  lcdStatus = 1; 
  lcd.clear();
  lcd.print("Welcome!");
  delay(2000);
  lcd.clear();
  lcd.print("1. Chords");
  lcd.setCursor(0,1);
  lcd.print("2. Scales");
  menu = 1;
}

void turnoffLCD() {
  lcd.clear();
  lcdStatus = 0;  
}

void returnFromSub() {
  menu = 1;
  lcd.clear();
  lcd.print("1. Chords");
  lcd.setCursor(0,1);
  lcd.print("2. Scales");
}

int submenuPrint (int n, int l) {
  String submenuOne[] = {"C Major", "A Minor", "E Minor", "G Major", "F Major", "D Major", "D Minor", "A Major", "E Major"};
  String submenuTwo[] = {"Major", "Minor", "Harmonic Minor", "Pentatonic", "Diminished"};
  menu = 10 * n + l;
  lcd.clear();
  if (n == 1) {
    lcd.print(submenuOne[l-1]);
  }
  if (n == 2) {
    lcd.print(submenuTwo[l-1]);
  }
}

/*int casefunction ( int n, int l ) {
  switch (menu) {
    case (10 * n + l):
      switch(button) {
        case Next:
          submenuPrint(n,l+1);
          break;
        case Previous:
          submenuPrint(n,l-1);
          break;
        case Return:
          returnFromSub();
          break;
      }
      break
  }
}*/
