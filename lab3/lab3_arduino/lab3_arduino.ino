
/*
A0 - LF
A1 - HEEL
A2 - MM
A3 - MF
*/
int LF, HEEL, MM, MF = 0;
void setup() {
  // put your setup code here, to run once:
    Serial.begin(115200);
}

void loop() {
  //!!Modify according to your own wiring!!
  Serial.print("LF : ");
  Serial.println(analogRead(A0));

  Serial.print("HEEL : ");
  Serial.println(analogRead(A1));

  Serial.print("MM : ");
  Serial.println(analogRead(A2));

  Serial.print("MF : ");
  Serial.println(analogRead(A3));

  delay(1100);
}
