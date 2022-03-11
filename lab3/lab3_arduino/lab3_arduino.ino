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
int red_timer, yellow_timer, green_timer, blue_timer = 0;

#define red_pin 3
#define yellow_pin 5
#define green_pin 9
#define blue_pin 11


void setup() {
  // put your setup code here, to run once:
  Wire.begin();
  Wire.beginTransmission(MPU);
  Wire.write(0x6B); 
  Wire.write(0);    
  Wire.endTransmission(true);
  Serial.begin(115200);
}

void loop() {
  //FSR readings
  //!!Modify according to your own wiring!!

  LF = analogRead(A3);
  Serial.print(LF);
  Serial.print(",");

  HEEL = analogRead(A2);
  Serial.print(HEEL);
  Serial.print(",");

  MM = analogRead(A0);
  Serial.print(MM);
  Serial.print(",");

  MF = analogRead(A1);
  Serial.print(MF);
  Serial.print(",");
  
  //If LF is activated turn the red LED on
  if(LF > 100) {
    digitalWrite(red_pin, HIGH);
  }else{
    digitalWrite(red_pin, LOW);
  }
  //If HEEL is activated turn the yellow LED on
  if(HEEL > 100) {
    digitalWrite(yellow_pin, HIGH);
  }else{
    digitalWrite(yellow_pin, LOW);
  }
  //If MM is activated turn the green LED on
  if(MM > 100) {
    digitalWrite(green_pin, HIGH);
  }else{
    digitalWrite(green_pin, LOW);
  }
  //If MF is activated turn the blue LED on
  if(MF > 100) {
    digitalWrite(blue_pin, HIGH);
  }else{
    digitalWrite(blue_pin, LOW);
  }

  //Acelerometer
  Wire.beginTransmission(MPU);
  Wire.write(0x3B);  
  Wire.endTransmission(false);
  Wire.requestFrom(MPU,12,true);  
  AcX=Wire.read()<<8|Wire.read();    
  AcY=Wire.read()<<8|Wire.read();  
  AcZ=Wire.read()<<8|Wire.read();
  Serial.print(AcX);
  Serial.print(",");
  Serial.print(AcY);
  Serial.print(","); 
  Serial.print(AcZ);  
  Serial.println(","); 
  
  delay(100);
}
