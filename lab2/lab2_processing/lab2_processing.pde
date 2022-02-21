import processing.serial.*;
import grafica.*;

Serial myPort;
// change the number below to match your port:
String val;
String heartrate = "-";
String confidence = "-";
String oxygen = "-";
String status = "-";
String resting = "-";
String zone = "none";
GPointsArray points = new GPointsArray(0);
int nPoints = 0;
ArrayList<Integer> pointsList = new ArrayList<Integer>();
int elapsedSecs = 0;
String time;

int max = 0;
int hard = 0;
int moderate = 0;
int light = 0;
int vlight = 0;

void setup () {
  size(700, 900);// window size
  background(64,64,64);
  
  // List all the available serial ports
  String portName = Serial.list()[3];
  myPort = new Serial(this, portName, 115200);  
  
}

void draw(){
  background(64,64,64);
  fill(255,255,255);
  if(myPort.available() > 0){
    val = myPort.readStringUntil('\n');
    if(val != null){
      //heartrate, confidence, oxygen, status
      String[] list = split(val, ',');
      heartrate = list[0];
      confidence = list[1];
      oxygen = list[2];
      status = list[3];
    }
  }
  textSize(30);
  text("Current bpm: " + heartrate, 10, 90);

  if(int(heartrate) != 0){
    points.add(nPoints, int(heartrate));
    pointsList.add(int(heartrate));
    nPoints++;
    
  }
  
  if(pointsList.size() % 30 == 0 && pointsList.size() > 0){
    int sum = 0;
    for(int i = pointsList.size()-30; i < pointsList.size(); i++){
      sum += pointsList.get(i);
    }
    double avg = sum/30;
    resting = String.valueOf(avg);
  }
  
  if(int(resting) > 0){
    if(int(heartrate)-int(resting) >= 10){
      println("Stressed");
      myPort.write('1');
    }
    else{
      println("Relaxed");
      myPort.write('0');
    }
  }
  
    
  text("Blood Oxygen: " + oxygen, 250, 90);
  text("Confidence: " + confidence, 500, 90);
  
  text("Avg bpm: " + resting, 290, 450);
  
  
  
  color[] pointColors = new color[pointsList.size()];
  
  for(int i = 0; i < pointsList.size(); i++){
    if(pointsList.get(i) >= int(198*.90)){
      pointColors[i] = color(255,0,0);
      max++;
    }
    else if(pointsList.get(i) >= int(198*.80)){
      pointColors[i] = color(255,128,0);
      hard++;
    }
    else if(pointsList.get(i) >= int(198*.70)){
      pointColors[i] = color(0,153,0);
      moderate++;
    }
    else if(pointsList.get(i) >= int(198*.60)){
      pointColors[i] = color(0,128,255);
      light++;
    }
    else if(pointsList.get(i) >= int(198*.50)){
      pointColors[i] = color(160,160,160);
      vlight++;
    }
    else{
      pointColors[i] = color(0,0,0);
    }
  }
    

  // Create a new plot and set its position on the screen
  GPlot plot = new GPlot(this);
  plot.setPos(10, 110);
  // or all in one go
  // GPlot plot = new GPlot(this, 25, 25);

  // Set the plot title and the axis labels
  plot.setTitleText("Heart Rate");
  plot.getXAxis().setAxisLabelText("Time Elapsed (s)");
  plot.getYAxis().setAxisLabelText("BPM");
  plot.setDim(580, 200);
  

  // Add the points
  plot.setPoints(points);
  plot.setPointColors(pointColors); 
  

  // Draw it!
  plot.defaultDraw();
  plot.activatePanning();
  
  elapsedSecs++;
  
  if(elapsedSecs%60 < 10){
    time = (elapsedSecs/60)%60 + ":0" + (elapsedSecs%60);
  }
  else{
    time = (elapsedSecs/60)%60 + ":" + (elapsedSecs%60);
  }
  
  textSize(40);
  text(time, 320, 40);  
  
  text("Exercise Zones", 230, 550);  
  strokeWeight(0);
  textSize(30);
  rect(10, 570, 680, 310);
  
  fill(255,0,0);
  rect(20, 580, 1+max, 50);
  
  fill(255,128,0);
  rect(20, 640, 1+hard, 50);
  
  fill(0,153,0);
  rect(20, 700, 1+moderate, 50);
  
  fill(0,128,255);
  rect(20, 760, 1+light, 50);
  
  fill(160,160,160);
  rect(20, 820, 1+vlight, 50);
  
  fill(0,0,0);
  text(max + "s", 30+max, 615);
  text(hard + "s", 30+hard, 675);
  text(moderate + "s", 30+moderate, 735);
  text(light + "s", 30+light, 795);
  text(vlight + "s", 30+vlight, 855);
  
  fill(255,0,0);
  rect(20, 485, 10, 10);
  text("Max",50,500);
  
  fill(255,128,0);
  rect(130, 485, 10, 10);
  text("Hard",160,500);
  
  fill(0,153,0);
  rect(250, 485, 10, 10);
  text("Moderate",280,500);
  
  fill(0,128,255);
  rect(420, 485, 10, 10);
  text("Light",450,500);
  
  fill(160,160,160);
  rect(530, 485, 10, 10);
  text("Very Light",560,500);
  
  max = 0;
  hard = 0;
  moderate = 0;
  light = 0;
  vlight = 0;
 
  
  delay(1000);
}
