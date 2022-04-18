//lab 3

import processing.serial.*;
import grafica.*;

Serial myPort;
String val;
int acx, acy, acz, xang, yang, zang, bpm, fsr;
String [] acxList;
String [] acyList;
String [] aczList;
String [] xangList;
String [] yangList;
String [] zangList;

void setup() {
    size(500, 500); // window size
    // List all the available serial ports
    String portName = Serial.list()[2];
    myPort = new Serial(this, portName, 115200);
}

void draw() {
    background(0);
    fill(255,255,255);
    
    if(myPort.available() > 0){
      val = myPort.readStringUntil('\n');
      if(val != null){
        String[] list = split(val, ',');
        if(list.length >= 8){
          acx = int(list[0]);
          acy = int(list[1]);
          acz = int(list[2]);
          xang = int(list[3]);
          yang = int(list[4]);
          zang = int(list[5]);
          bpm = int(list[6]);
          fsr = int(list[7]);
          print(xang);
          print(",");
          print(yang);
          print(",");
          print(zang);
          println();
        }
      }
    }
    
    if(xang > 20 && yang > 300 && zang > 150 && zang < 200){
      text("Tilt Left", 200, 100);
    }
    else{
      text("Resting",200,100);
    }
    
    if(xang > 10 && xang < 40 && yang < 340 && zang < 130){
      text("Tilt Right", 200, 200);
    }
    else{
      text("Resting", 200, 200);
    }
    
    if(xang > 40 && xang < 70 && zang < 120){
      text("Tilt Forward", 200, 300);
    }
    else{
      text("Resting", 200, 300);
    }
    
    if(xang > 300 && yang < 20 && zang > 200){
      text("Tilt Backward", 200, 400);
    }
    else{
      text("Resting", 200, 400);
    }
        
}
