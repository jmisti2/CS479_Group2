#include <SparkFun_Bio_Sensor_Hub_Library.h>
#include<Wire.h>
const int MPU=0x68; 
int16_t AcX,AcY,AcZ,Tmp,GyX,GyY,GyZ;

//acx,acy,acz,xang,yang,zang,bpm,fsr

// Reset pin, MFIO pin
int resPin = 4;
int mfioPin = 5;

int fsrRead;

int minVal=265;
int maxVal=402;

double x;
double y;
double z;

SparkFun_Bio_Sensor_Hub bioHub(resPin, mfioPin); 
bioData body;  

void setup() {
  // put your setup code here, to run once:
  Wire.begin();
  int result = bioHub.begin();
  int error = bioHub.configBpm(MODE_ONE); // Configuring just the BPM settings. 
  Wire.beginTransmission(MPU);
  Wire.write(0x6B); 
  Wire.write(0);    
  Wire.endTransmission(true);
  Serial.begin(115200);
}

void loop() {
  Wire.beginTransmission(MPU);
  Wire.write(0x3B);  
  Wire.endTransmission(false);
  Wire.requestFrom(MPU,12,true); 
  
  //Acelerometer
  AcX=Wire.read()<<8|Wire.read();    
  AcY=Wire.read()<<8|Wire.read();  
  AcZ=Wire.read()<<8|Wire.read();  
//  GyX=Wire.read()<<8|Wire.read();  
//  GyY=Wire.read()<<8|Wire.read();  
//  GyZ=Wire.read()<<8|Wire.read();  

  Serial.print(AcX);
  Serial.print(",");
  Serial.print(AcY);
  Serial.print(",");
  Serial.print(AcZ);
  Serial.print(",");

  int xAng = map(AcX,minVal,maxVal,-90,90);
  int yAng = map(AcY,minVal,maxVal,-90,90);
  int zAng = map(AcZ,minVal,maxVal,-90,90);
   
  x= RAD_TO_DEG * (atan2(-yAng, -zAng)+PI);
  y= RAD_TO_DEG * (atan2(-xAng, -zAng)+PI);
  z= RAD_TO_DEG * (atan2(-yAng, -xAng)+PI);

  //angle x
  Serial.print(x);
  Serial.print(",");
  //angle y
  Serial.print(y);
  Serial.print(",");
  //angle z
  Serial.print(z);
  Serial.print(",");

  body = bioHub.readBpm();
  Serial.print(body.heartRate); 
  Serial.print(",");

  fsrRead = analogRead(A0);
  Serial.print(fsrRead);
  Serial.print(",");
  Serial.println();
  
  delay(100);
}
