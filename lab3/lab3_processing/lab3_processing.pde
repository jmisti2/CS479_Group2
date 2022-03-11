//lab 3

import processing.serial.*;
import grafica.*;

Serial myPort;
PImage img;

String val; 
int stepCount, nstepCount, cadence = 0;
boolean stepFlag = false;
int time;

int lf, heel, mm, mf, acx, acy, acz = 0;
ArrayList<Integer> lfList = new ArrayList<Integer>();
ArrayList<Integer> heelList = new ArrayList<Integer>();
ArrayList<Integer> mmList = new ArrayList<Integer>();
ArrayList<Integer> mfList = new ArrayList<Integer>();
ArrayList<Integer> cadenceList = new ArrayList<Integer>();

void setup() {
    size(1110, 600); // window size
    background(64, 64, 64);

    // List all the available serial ports
    String portName = Serial.list()[3];
    myPort = new Serial(this, portName, 115200);
    
    img = loadImage("foot.png");
    time = millis();
}

void draw() {
    background(230,230,230);
    fill(255, 255, 255);
    
    if(myPort.available() > 0){
      val = myPort.readStringUntil('\n');
      println(val);
      if(val != null){
        //heartrate, confidence, oxygen, status
        String[] list = split(val, ',');
        if(list.length >= 7){
          lf = int(list[0]);
          heel = int(list[1]);
          mm = int(list[2]);
          mf = int(list[3]);
          acx = int(list[4]);
          acy = int(list[5]);
          acz = int(list[6]);
          println(int(list[6]));
          lfList.add(heel);
        }
      }
    }
    
    //detects a step
    if(lfList.size() >= 2){
      //Checks for heel strike to count step
      if((lfList.get(lfList.size()-1) > 300) && (lfList.get(lfList.size()-2) < 100)){
        stepFlag = true;
      }
      
      if((lfList.get(lfList.size()-1) < 100) && (lfList.get(lfList.size()-2) > 300)){
        if(stepFlag){
          stepCount++;
          stepFlag = false;
        }
      }
    }
    
    if (millis() > time + 30000){
      cadence = stepCount - cadence;
      time = millis();
    }
    
    
    image(img, 0, 100, width/4 + 100, height/2 + 100);
    
    int white = 100;
    int orange = 900;
    int yellow = 500;
    int green = 300;
    
    //MF Circle
    if(mf <= white){
      fill(255,255,255);
    }
    else if(mf <= green){
      fill(0,255,0);
    }
    else if(mf <= yellow){
      fill(255,255,0);
    }
    else if(mf <= orange){
      fill(255,69,0);
    }
    else{
      fill(255,0,0);
    }
    circle(180, 180, 35);
    
    //MM Circle
    if(mm <= white){
      fill(255,255,255);
    }
    else if(mm <= green){
      fill(0,255,0);
    }
    else if(mm <= yellow){
      fill(255,255,0);
    }
    else if(mm <= orange){
      fill(255,69,0);
    }
    else{
      fill(255,0,0);
    }
    circle(160, 270, 35);
        
    //LF Circle
    if(lf <= white){
      fill(255,255,255);
    }
    else if(lf <= green){
      fill(0,255,0);
    }
    else if(lf <= yellow){
      fill(255,255,0);
    }
    else if(lf <= orange){
      fill(255,69,0);
    }
    else{
      fill(255,0,0);
    }
    circle(235, 240, 35);
    
    //Heel Circle
    if(heel <= white){
      fill(255,255,255);
    }
    else if(heel <= green){
      fill(0,255,0);
    }
    else if(heel <= yellow){
      fill(255,255,0);
    }
    else if(heel <= orange){
      fill(255,69,0);
    }
    else{
      fill(255,0,0);//red
    }
    circle(190, 420, 35);
    
    fill(0,0,0);
    textSize(40);
    text(millis() / 60000 + ":" + (millis()/1000)%60, 540, 40);
    
    textSize(30);
    text("Foot Pressure Map", 75, 75);
    text("Step Count: " + stepCount, 870, 40);
    text("Cadence: " + cadence + " s/min", 870, 80);
    text("x: "+ acx, 870, 100);
    text("y: "+ acy, 870, 120);
    text("z: "+ acz, 870, 140);
    
    //text for determining if user is moving or still
    if(acz > 16000 && acz < 17000){
      text("Standing Still", 870, 180);
    }
    else{
      text("Moving", 870, 180);
    }

    fill(255, 255, 255);
    textSize(25);
    text("MF", 165, 220);
    text("MM", 145, 310);
    text("LF", 225, 280);
    text("HEEL", 163, 460);

    
    delay(1);
}
