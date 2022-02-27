import processing.serial.*;
import grafica.*;

Serial myPort;
// change the number below to match your port:
String val;
String ecg = "-";
String hr = "-";
String fsr = "-";
GPointsArray points = new GPointsArray(0);
GPointsArray points2 = new GPointsArray(0);
int nPoints = 0;
int nPoints2 = 0;
ArrayList<Integer> pointsList = new ArrayList<Integer>();
ArrayList<Integer> pointsList2 = new ArrayList<Integer>();

void setup () {
  size(1110, 600);// window size
  background(64,64,64);
  
  // List all the available serial ports
  String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 9600);  
  
}

void draw(){
  background(64,64,64);
  fill(255,255,255);
  if(myPort.available() > 0){
    val = myPort.readStringUntil('\n');
    if(val != null){
      //heartrate, confidence, oxygen, status
      String[] list = split(val, ',');
      ecg = list[0];
      hr = list[1];
      fsr = list[2];
    }
  }
  textSize(30);
  
  text(millis()/60000 + ":" + millis()/1000,540,30);
  text("Heart Rate: " + hr, 10, 90);

  //Adds points to ecg Plot
  if(int(ecg) != 0){
    if(nPoints >= 200){
      points.remove(0);
      points.add(nPoints, int(ecg));
      pointsList.remove(0);
      pointsList.add(int(hr));
     }
    else{
      points.add(nPoints, int(ecg));
      pointsList.add(int(hr));
    }
    nPoints++;
    
    
  }
  
  text("FSR: " + fsr, 600, 90);
  //Adds points to fsr Plot
  if(nPoints2 >= 200){
    points2.remove(0);
    points2.add(nPoints2, int(float(fsr)));
    //pointsList2.add(int(fsr));
  }
  else{
    points2.add(nPoints2, int(fsr));
    //pointsList2.add(int(fsr));
  }
  
  nPoints2++;
  
  color[] pointColors = new color[pointsList.size()];
  
  for(int i = 0; i < pointsList.size(); i++){
    if(pointsList.get(i) >= int(198*.90)){
      pointColors[i] = color(255,0,0);
      //max++;
    }
    else if(pointsList.get(i) >= int(198*.80)){
      pointColors[i] = color(255,128,0);
      //hard++;
    }
    else if(pointsList.get(i) >= int(198*.70)){
      pointColors[i] = color(0,153,0);
      //moderate++;
    }
    else if(pointsList.get(i) >= int(198*.60)){
      pointColors[i] = color(0,128,255);
      //light++;
    }
    else if(pointsList.get(i) >= int(198*.50)){
      pointColors[i] = color(160,160,160);
      //vlight++;
    }
    else{
      pointColors[i] = color(0,0,0);
    }
  }
    
    

  // Create a new plot and set its position on the screen
  GPlot plot = new GPlot(this);
  plot.setPos(10, 110);

  // Set the plot title and the axis labels
  plot.setTitleText("ECG");
  plot.getXAxis().setAxisLabelText("Time Elapsed (ms)");
  plot.getYAxis().setAxisLabelText("BPM");
  plot.setDim(400, 200);
 
  // Add the points
  plot.setPoints(points);
  plot.setPointColors(pointColors); 
  
  // Draw it!
  plot.defaultDraw();
  plot.activatePanning();
  
  //fsr PLOT
  
  // Create a new plot and set its position on the screen
  GPlot plot2 = new GPlot(this);
  plot2.setPos(600, 110);

  // Set the plot title and the axis labels
  plot2.setTitleText("FSR");
  plot2.getXAxis().setAxisLabelText("Time Elapsed (ms)");
  plot2.getYAxis().setAxisLabelText("Pressure");
  plot2.setDim(400, 200);
  

  // Add the points
  plot2.setPoints(points2);
  

  // Draw it!
  plot2.defaultDraw();
  plot2.activatePanning();
  
  delay(1);
}
