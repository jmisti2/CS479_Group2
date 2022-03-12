//lab 3

import processing.serial.*;
import grafica.*;

Serial myPort;
PImage img;
String val; 
color bg, white;


//Variables for counting steps and cadence
int stepCount, nstepCount, cadence = 0;
boolean stepFlag = false;
int time;

//Variables for detecting motion
int motionTime, prevTime = 0;
boolean motionFlag = false;
int timeCount = 0;

//variables for gait profiles
float mfp = 0;
int lf, heel, mm, mf, acx, acy, acz = 0;
ArrayList<Integer> lfList = new ArrayList<Integer>();
ArrayList<Integer> heelList = new ArrayList<Integer>();
ArrayList<Integer> mmList = new ArrayList<Integer>();
ArrayList<Integer> mfList = new ArrayList<Integer>();
ArrayList<Integer> cadenceList = new ArrayList<Integer>();
ArrayList<Integer> aczList = new ArrayList<Integer>();
ArrayList<Integer> motionList = new ArrayList<Integer>();
ArrayList<Float> mfpList = new ArrayList<Float>();

void setup() {
    size(1110, 600); // window size
    bg = color(240,240,240);
    white = color(255,255,255);
    background(bg);
    // List all the available serial ports
    String portName = Serial.list()[3];
    myPort = new Serial(this, portName, 115200);
    
    img = loadImage("foot.png");
    time = millis();
}

void draw() {
    colorMode(RGB);
    background(bg);
    fill(255, 255, 255);
    
    if(myPort.available() > 0){
      val = myPort.readStringUntil('\n');
      println(val);
      if(val != null){
        //heartrate, confidence, oxygen, status
        String[] list = split(val, ',');
        if(list.length >= 7){
          println("HERE");
          lf = int(list[0]);
          heel = int(list[1]);
          mm = int(list[2]);
          mf = int(list[3]);
          acx = int(list[4]);
          acy = int(list[5]);
          acz = int(list[6]);
          lfList.add(heel);
          println(lf + "," + heel + "," + mm + "," + mf + "," + acx + "," + acy + "," + acz);
        }
      }
    }
    
    //////////////////////////SECTION II: Detecting 5 Gait profiles
    
    mfp = ((mm + mf)*100)/(mm+mf+lf+heel+0.001);
    
    if(mfpList.size() == 300){
      mfpList.remove(0);
    }
    mfpList.add(mfp);
    
    int sum2 = 0;
    for(int i = 0; i < mfpList.size(); i++){
      sum2 += mfpList.get(i);
    }
    
    int avg2 = 0;
    if(mfpList.size() == 300){
      avg2 = sum2/mfpList.size();
    }
    
    fill(0,0,0);
    textSize(30);
    text("MFP: " + mfp, 850, 280);
    text("AVG MFP: " + avg2, 850, 310);
    
    String gaitProfile = "-";
    
    if(millis() > 3000){
      if(avg2 < 10){
        gaitProfile = "Heel";
      }
      else if(avg2 < 44){
        gaitProfile = "Normal Gait";
      }
      else if(avg2 < 48){
        gaitProfile = "In-toeing";
      }
      else if(avg2 < 65){
        gaitProfile = "Out-toeing";
      }
      else if(avg2 < 80){
        gaitProfile = "Tiptoeing";
      }
    }
    
    
    
    text(gaitProfile, 850, 340);

    //////////////////////////End of SECTION II
    
    //////////////////////////SECTION I: Detects step count and cadence
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
    //////////////////////////End of SECTION I
    
    //////////////////////////Foot Pressure Graph
    image(img, -80, 55, width/4 + 300, height/2 + 250);

    
    //MF Circle
    if(mf < 35){
      colorMode(RGB);
      fill(white);
      circle(190, 180, 35);//mf coordinates for the circle
    }
    else {
      colorMode(HSB, 360, 100, 100);
      noStroke();
      drawGradient(190, 180, mf / 5, 340);
      colorMode(RGB);
    }
    
    //MM Circle
    if(mm < 35){
      colorMode(RGB);
      fill(white);
      circle(160, 270, 35);
    }
    else {
      colorMode(HSB, 360, 100, 100);
      noStroke();
      drawGradient(160, 270, mm / 5, 130);
      colorMode(RGB);
    }
        
    //LF Circle
    if(lf < 35){
      colorMode(RGB);
      fill(white);
      circle(280, 246, 35);
    }
    else {
      colorMode(HSB, 360, 100, 100);
      noStroke();
      drawGradient(280, 246, lf / 5, 211);
      colorMode(RGB);
    }
    
    //Heel Circle
    if(heel < 35){
      colorMode(RGB);
      fill(white);
      circle(210, 520, 35);
    }
    else {
      colorMode(HSB, 360, 100, 100);
      noStroke();
      drawGradient(210, 520, heel / 5, 25);
      colorMode(RGB);
    }
    
    //////////////////////////End of Foot Pressure Graph
    
    colorMode(RGB);
    fill(0,0,0);
    textSize(40);
    text(millis() / 60000 + ":" + (millis()/1000)%60, 540, 40);
    
    textSize(30);
    text("Foot Pressure Map", 75, 75);
    text("Step Count: " + stepCount, 870, 40);
    text("Cadence: " + cadence*2 + " s/min", 870, 80);
    text("x: "+ acx, 950, 500);
    text("y: "+ acy, 950, 520);
    text("z: "+ acz, 950, 540);
    
    //////////////////////////SECTION III: Calculating motion and time in motion
    
    //text for determining if user is moving or still
    if(aczList.size() == 100){
      aczList.remove(0);
    }
    aczList.add(acz);
    
    int sum = 0;
    for(int i = 0; i < aczList.size(); i++){
      sum += aczList.get(i);
    }
    
    int avg = 0;
    if(aczList.size() == 100){
      avg = sum/aczList.size();
    }
        
    int sq = 0;
    for(int i = 0; i < aczList.size(); i++){
      sq += sq(aczList.get(i)-avg);
    }
    
    float std = sqrt(sq/100);
    
    if(std > 150 && millis() > 5000){
      fill(255,0,0);
      text("In Motion", 870, 180);
      motionFlag = true;
      timeCount++;
      if(timeCount == 1){
        prevTime = millis();
      }
    }
    else{
      fill(0,255,0);
      text("Standing Still", 870, 180);
      if(motionFlag){
        motionTime = millis() - prevTime;
        timeCount = 0;
        motionFlag = false;
      }
    }
    //////////////////////////End of SECTION III
    
    fill(0,0,0);
    text("Motion Time: " + motionTime/1000 + "s", 850, 220);

    fill(255, 255, 255);
    textSize(25);
    text("MF", 175, 220);
    text("MM", 145, 310);
    text("LF", 270, 290);
    text("HEEL", 180, 560);

    //delay(1);
}


void drawGradient(float x, float y, int radius, int h) {
  for (int r = radius; r > 0; --r) {
    fill(h, 90, 90);
    ellipse(x, y, r, r);
    h = (h + 1) % 360;
  }
}
