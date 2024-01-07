void setupLED() { //setup LEDs as output annd turn them off
  for (int pinC = 0; pinC <6; pinC++) {
    pinMode(col[pinC],OUTPUT); //these call data from the column array
    digitalWrite(col[pinC],LOW);
  }
  for (int pinR = 0; pinR <5; pinR++) {
    pinMode(row[pinR],OUTPUT); //these call data from the row array
    digitalWrite(row[pinR],HIGH);
  }
}
