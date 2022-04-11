#include <SparkFun_Bio_Sensor_Hub_Library.h>
#include<Wire.h>
const int MPU=0x68; 
int16_t AcX,AcY,AcZ,Tmp,GyX,GyY,GyZ;

// Reset pin, MFIO pin
int resPin = 4;
int mfioPin = 5;

int fsrRead;

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
  GyX=Wire.read()<<8|Wire.read();  
  GyY=Wire.read()<<8|Wire.read();  
  GyZ=Wire.read()<<8|Wire.read();  
  
  Serial.print("Accelerometer: ");
  Serial.print("X = "); Serial.print(AcX);
  Serial.print(" | Y = "); Serial.print(AcY);
  Serial.print(" | Z = "); Serial.println(AcZ); 
  
  Serial.print("Gyroscope: ");
  Serial.print("X = "); Serial.print(GyX);
  Serial.print(" | Y = "); Serial.print(GyY);
  Serial.print(" | Z = "); Serial.println(GyZ);
  Serial.println(" ");

  body = bioHub.readBpm();
  Serial.print("Heartrate:");
  Serial.print(body.heartRate); 
  Serial.println();
  Serial.print("Confidence:");
  Serial.print(body.confidence); 
  Serial.println();
  Serial.print("Oxygen:");
  Serial.print(body.oxygen); 
  Serial.println();
  Serial.print("Status:");
  Serial.print(body.status);
  Serial.println();

  fsrRead = analogRead(A0);
  Serial.print(fsrRead);
  Serial.println();
  
  delay(333);
}
