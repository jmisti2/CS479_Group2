#include<Wire.h>
/*
A0 - LF
A1 - HEEL
A2 - MM
A3 - MF
*/
int LF, HEEL, MM, MF = 0;
const int MPU=0x68; 
int16_t AcX,AcY,AcZ;


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
  Serial.println("FSR");
  Serial.print("LF : ");
  Serial.print(analogRead(A0));

  Serial.print(", HEEL : ");
  Serial.print(analogRead(A1));

  Serial.print(", MM : ");
  Serial.print(analogRead(A2));

  Serial.print(", MF : ");
  Serial.println(analogRead(A3));

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

  delay(1100);
}
