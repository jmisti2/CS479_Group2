#include<Wire.h>
/*
A0 - LF   -> D3  - RED
A1 - HEEL -> D6  - YELLOW
A2 - MM   -> D9  - GREEN
A3 - MF   -> D11 - BLUE
*/
int LF, HEEL, MM, MF = 0;
const int MPU=0x68; 
int16_t AcX,AcY,AcZ;
int red_timer, yellow_timer, green_timer, blue_timer;


void setup() {
  // put your setup code here, to run once:
  Wire.begin();
  Wire.beginTransmission(MPU);
  Wire.write(0x6B); 
  Wire.write(0);    
  Wire.endTransmission(true);
  Serial.begin(115200);
  red_timer, yellow_timer, green_timer, blue_timer = 0;
}

void loop() {
  //FSR readings
  //!!Modify according to your own wiring!!
  Serial.println("FSR");

  LF = analogRead(A0);
  Serial.print("LF : ");
  Serial.print(LF);

  HEEL = analogRead(A1);
  Serial.print(", HEEL : ");
  Serial.print(HEEL);

  MM = analogRead(A2);
  Serial.print(", MM : ");
  Serial.print(MM);

  MF = analogRead(A3);
  Serial.print(", MF : ");
  Serial.println(MF);
  
  //If LF is activated turn the red LED on
  if(LF > 11) {
    digitalWrite(3, HIGH);
    red_timer = millis();
  }
  //After .3 seconds of the red LED being on, turn it off
  if(millis() - red_timer > 250) {digitalWrite(3, LOW);}

  //If HEEL is activated turn the yellow LED on
  if(HEEL > 11) {
    digitalWrite(6, HIGH);
    yellow_timer = millis();
  }
  //After .3 seconds of the yellow LED being on, turn it off
  if(millis() - yellow_timer > 250) {digitalWrite(6, LOW);}

  //If MM is activated turn the green LED on
  if(MM > 11) {
    digitalWrite(9, HIGH);
    green_timer = millis();
  }
  //After .3 seconds of the green LED being on, turn it off
  if(millis() - green_timer > 250) {digitalWrite(9, LOW);}
  
  //If MF is activated turn the blue LED on
  if(MF > 11) {
    digitalWrite(11, HIGH);
    blue_timer = millis();
  }
  //After .3 seconds of the blue LED being on, turn it off
  if(millis() - blue_timer > 250) {digitalWrite(11, LOW);}
  

  //Acelerometer
  Wire.beginTransmission(MPU);
  Wire.write(0x3B);  
  Wire.endTransmission(false);
  Wire.requestFrom(MPU,12,true);  
  AcX=Wire.read()<<8|Wire.read();    
  AcY=Wire.read()<<8|Wire.read();  
  AcZ=Wire.read()<<8|Wire.read();
  Serial.print("Accelerometer: ");
  Serial.print("X = "); Serial.print(AcX);
  Serial.print(" | Y = "); Serial.print(AcY);
  Serial.print(" | Z = "); Serial.println(AcZ);  

  delay(300);
}
