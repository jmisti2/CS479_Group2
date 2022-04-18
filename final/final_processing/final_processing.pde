//lab 3

import processing.serial.*;
import grafica.*;

Serial myPort;
String val;

int acx, acy, acz, xang, yang, zang, bpm, fsr;

int punchCount;
int punchSpeed;
boolean punchDetected;

ArrayList<Integer> acxList = new ArrayList<Integer>();
ArrayList<Integer> acyList = new ArrayList<Integer>();
ArrayList<Integer> aczList = new ArrayList<Integer>();
ArrayList<Integer> xangList = new ArrayList<Integer>();
ArrayList<Integer> yangList = new ArrayList<Integer>();
ArrayList<Integer> zangList = new ArrayList<Integer>();
ArrayList<String> angleList = new ArrayList<String>();

void setup() {
    size(500, 500); // window size
    // List all the available serial ports
    String portName = Serial.list()[2];
    myPort = new Serial(this, portName, 115200);
}

void draw() {
    background(0);
    fill(255,255,255);
    textSize(30);
    
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
          print(acx);
          print(",");
          print(acy);
          print(",");
          print(acz);
          println();
        }
      }
    }
    
    //storing last 30 angle points
    if(xangList.size() == 30){
      xangList.remove(0);
    }
    xangList.add(xang);
    
    if(yangList.size() == 30){
      yangList.remove(0);
    }
    yangList.add(yang);
    
    if(zangList.size() == 30){
      zangList.remove(0);
    }
    zangList.add(zang);
    
    //storing last 30 acx points
    if(acxList.size() == 30){
      acxList.remove(0);
    }
    acxList.add(acx);
    
    //detects punch
    if(acx > 1000){
      fill(255,0,0);
      text("Punched", 50, 150);
      punchDetected = true;
      
    }
    else{
      if(punchDetected){
        println(xangList);
        println(yangList);
        println(zangList);
        for(int i = 0; i < 30; i++){
          angleList.add(detectAngle(xangList.get(i),yangList.get(i),zangList.get(i)));
        }
        println(angleList);
        angleList = new ArrayList<String>();
        
        punchSpeed = findMax(acxList);
        punchCount++;
      }
      punchDetected = false;
    }
    
    text("Punch Count: " + punchCount, 50, 50);
    text("Punch Speed: " + punchSpeed, 50, 100);
    
}

String detectAngle(int x, int y, int z){
  
  if(x > 20 && y > 300 && z > 150 && z < 200){
    return "Left";
  }
  else if(x > 10 && x < 40 && y < 340 && z < 130){
    return "Right";
  }
  else if(x > 40 && x < 70 && z < 120){
    return "Forward";
  }
  
  else if(x > 300 && y < 20 && z > 200){
    return "Backward";
  }
  else{
    return "Flat";
  }
}
int findMax(ArrayList<Integer> arr){
  int max = arr.get(0);
  for(int i = 1; i < arr.size(); i++){
    if (arr.get(i) > max){
      max = arr.get(i);
    }
  }
  return max;
}
