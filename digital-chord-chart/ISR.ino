void refreshScreen() {
  if (matrix[r][c]==1 && flag == 0) {
    digitalWrite(row[r], LOW); //turn pixel on
    digitalWrite(col[c], HIGH);
  }
  else {
    digitalWrite(row[r], HIGH); //turn pixel off
    digitalWrite(col[c], LOW);
  }
  
  counter++;
  flag = 0b00000001 & counter; 
  
  r = (0b00001110 & counter)>>1;
  if (r > 4) {
    r = 0;
  }
  
  c = (0b01110000 & counter)>>4;
  if (c > 5) {
    c = 0;
  }
}
