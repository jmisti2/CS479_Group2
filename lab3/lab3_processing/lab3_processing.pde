//lab 3

import processing.serial.*;
import grafica.*;

Serial myPort;
PImage img;
String val; 
color bg, white, green;


//Variables for counting steps and cadence
int stepCount, nstepCount, cadence = 0;
boolean stepFlag = false;
int time, time2;

//Variables for detecting motion
int motionTime, prevTime = 0;
boolean motionFlag = false;
int timeCount = 0;
int timeCount2 = 0;

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
ArrayList<Integer> zA = new ArrayList<Integer>();
GPointsArray points = new GPointsArray(0);
int nPoints = 0;

Table steps_table;

//Veriables for stride/step length
float accel;
float accelZ;
float stepL;
float strideL;
float startStride;
float strideTime;
int timeInter;
String stride;
String step;


void setup() {
    size(1110, 600); // window size
    bg = color(240,240,240);
    white = color(255,255,255);
    green = color(52,235,122);
    background(bg);
    // List all the available serial ports
    String portName = Serial.list()[3];
    myPort = new Serial(this, portName, 115200);
    
    img = loadImage("foot.png");
    time = millis();
    
    //Load the table
    steps_table = loadTable("steps_table.csv", "header");
    ////If today's step count has not started, create a new table row
    int last_day = Integer.parseInt(steps_table.getString(steps_table.getRowCount()-1, "day"));
    if(last_day != day()) {
      TableRow today_row = steps_table.addRow();
      today_row.setString("day", String.valueOf(day()));
      today_row.setString("month", String.valueOf(month()));
      today_row.setString("steps", String.valueOf(0));
    }
}

void draw() {
    colorMode(RGB);
    background(bg);
    fill(255, 255, 255);
    
    if(myPort.available() > 0){
      val = myPort.readStringUntil('\n');
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
          lfList.add(heel);
          //println(lf + "," + heel + "," + mm + "," + mf + "," + acx + "," + acy + "," + acz);
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
    
    fill(white);
    rect(840, 210, 235, 140);
    
    fill(0,0,0);
    textSize(30);
    text("Gait Profile", 850, 240);
    text("MFP: " + mfp, 850, 280);
    text("AVG MFP: " + avg2, 850, 310);
    
    String gaitProfile = "Reading";
    
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
    
    //Checks if in motion to start timer to calc stride time
    if(motionFlag){
        timeInter++;
        if(timeCount == 1){
          startStride = millis();
        }
        zA.add(acz); //get aceleration during movement
        
    }
    
    
    
    if(lfList.size() >= 2){ 
      
      if(motionFlag){ //completed stride
        strideTime = millis(); //time stride was completed
        float motionTime = strideTime - startStride;
        int asum = 0;
        for(int i = 0; i < zA.size(); i++){
          asum += zA.get(i);
        }
    
        float avga = asum/aczList.size();
        strideL = abs(avga) * motionTime *motionTime;
        stepL = strideL /2;
        //stride = nf(strideL, 0, 2);
        //step = nf(stepL, 0, 2);
      }
      
      fill(white);
      rect(840, 400, 235, 115);
      fill(0);
      text("Stride Length:  " + strideL, 850, 450);
      text("Step Length:  " + stepL, 850, 480);
        
      //Checks for heel strike to count step
      if(lfList.get(lfList.size()-2) - lfList.get(lfList.size()-1) > 100){
        stepFlag = true;
      }
      
      if(lfList.get(lfList.size()-1) - lfList.get(lfList.size()-2) < -100){
        if(stepFlag){
          if (millis() > time2 + 300){
            stepCount++;
            time2 = millis();
          }
          //Increment the step count for today in the table
          int current_steps = steps_table.getInt(steps_table.getRowCount()-1, "steps");
          steps_table.setString(steps_table.getRowCount()-1, "steps", String.valueOf(current_steps + 1));
          saveTable(steps_table, "steps_table.csv");
          stepFlag = false;
        }
      }
    }
    
    if (millis() > time + 30000){
      cadence = stepCount - cadence;
      time = millis();
      points.add(nPoints, stepCount);
      nPoints++;
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
    text("Step Count: " + stepCount, 380, 305);
    text("Cadence: " + cadence*2 + " s/min", 595, 305);
    
    //////////////////////////SECTION III: Calculating motion and time in motion
    fill(white);
    stroke(1);
    rect(840, 40, 235, 115);
    fill(0);
    text("Motion Detection", 850, 70);
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
    stroke(1);
    if(std > 250 && millis() > 5000){
      fill(255,0,0);
      text("In Motion", 850, 110);
      motionFlag = true;
      timeCount++;
      if(timeCount == 1){
        prevTime = millis();
      }
    }
    else{
      fill(0,255,0);
      text("Standing Still", 850, 110);
      if(motionFlag){
        motionTime = millis() - prevTime;
        timeCount = 0;
        motionFlag = false;
      }
    }
    
    
    //////////////////////////End of SECTION III
    
    fill(0,0,0);
    text("Motion Time: " + motionTime/1000 + "s", 850, 140);

    fill(white);
    textSize(25);
    text("MF", 175, 220);
    text("MM", 145, 310);
    text("LF", 270, 290);
    text("HEEL", 180, 560);

    ///////////////////////////Start of section IV
    
    //Bar plot the previous 4 and current day step count
    stroke(1);
    fill(white);
    rect(380,320, 430,260);
    textSize(15);
    int start_x = 385; int start_y = 330;
    for(int i = steps_table.getRowCount()-5; i < 5; i++) {
      TableRow row = steps_table.getRow(i);
      int steps = Integer.parseInt(row.getString("steps"));
      String month = row.getString("month");
      String day = row.getString("day");
      fill(green);
      rect(start_x, start_y, steps/20, 40);
      fill(0);
      text(steps + " steps " + month + "/" + day + "/" + year(), 385 + steps/20 + 10, start_y + 30);
      start_y += 50; 
    }
    
    ///////////////////////////End of section IV
    
    // Create a new plot and set its position on the screen
    GPlot plot = new GPlot(this);
    plot.setBgColor(white);
    plot.setBoxBgColor(white);
    plot.setPos(380, 50);

    // Set the plot title and the axis labels
    plot.setTitleText("Step Counter");
    plot.getXAxis().setAxisLabelText("Time Elapsed (30s)");
    plot.getYAxis().setAxisLabelText("Steps");
    plot.setDim(330, 120);

    // Add the points
    plot.setPoints(points);

    // Draw it!
    plot.defaultDraw();
    plot.activatePanning();
}


void drawGradient(float x, float y, int radius, int h) {
  for (int r = radius; r > 0; --r) {
    fill(h, 90, 90);
    ellipse(x, y, r, r);
    h = (h + 1) % 360;
  }
}
