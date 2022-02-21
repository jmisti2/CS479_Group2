import processing.serial.*;
import grafica.*;

Serial myPort;
// change the number below to match your port:
String val;
String heartrate;
String confidence;
String oxygen;
String status;
GPointsArray points;
int nPoints = 0;

void setup () {
  size(800, 800);// window size
  background(80,80,80);
  
  // List all the available serial ports
  String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 115200);
  
  points = new GPointsArray(nPoints);
  
}

void draw(){
  background(80,80,80);
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
  text("Heart Rate Monitor", 10, 30); 
  strokeWeight(10);
  if(heartrate != null){
    text("Heartrate BPM: " + heartrate, 10, 60);
    if(nPoints >= 10){
      points.remove(0);
    }
    if(int(heartrate) != 0){
      points.add(nPoints, int(heartrate));
      nPoints++;
    }
    //else if(int(heartrate) == 0 && nPoints > 0){
    //  points.add(nPoints, points.getLastPoint());
    //  nPoints++;
    //}
    
  }
  if(oxygen != null){
    text("Blood Oxygen Level: " + oxygen, 10, 90);
  }
  if(confidence != null){
    text("Confidence: " + confidence, 10, 120);
  }
  
  // Prepare the points for the plot
  

  

  // Create a new plot and set its position on the screen
  GPlot plot = new GPlot(this);
  plot.setPos(10, 160);
  // or all in one go
  // GPlot plot = new GPlot(this, 25, 25);

  // Set the plot title and the axis labels
  plot.setTitleText("Heart Rate");
  plot.getXAxis().setAxisLabelText("ms");
  plot.getYAxis().setAxisLabelText("BPM");
  

  // Add the points
  plot.setPoints(points);

  // Draw it!
  plot.defaultDraw();
  
  delay(1000);
}
