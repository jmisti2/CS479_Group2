import processing.serial.*;
import grafica.*;

Serial myPort;
// change the number below to match your port:
String val;
String hr = "-";
String fsr = "-";
GPointsArray points = new GPointsArray(0);
GPointsArray points2 = new GPointsArray(0);
int nPoints = 0;
int nPoints2 = 0;
ArrayList<Integer> pointsList = new ArrayList<Integer>();
ArrayList<Integer> pointsList2 = new ArrayList<Integer>();

void setup () {
  size(1200, 600);// window size
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
    println(val);
    if(val != null){
      //heartrate, confidence, oxygen, status
      String[] list = split(val, ',');
      hr = list[0];
      fsr = list[1];
    }
  }
  textSize(30);
  text("HR: " + hr, 10, 90);

  //Adds points to HR Plot
  if(int(hr) != 0){
    points.add(nPoints, int(hr));
    pointsList.add(int(hr));
    nPoints++;
  }
  
  text("FSR: " + fsr, 600, 90);
  //Adds points to FSR Plot
  points2.add(nPoints2, int(float(fsr)));
  pointsList2.add(int(fsr));
  nPoints2++;
  

  // Create a new plot and set its position on the screen
  GPlot plot = new GPlot(this);
  plot.setPos(10, 110);

  // Set the plot title and the axis labels
  plot.setTitleText("Heart Rate");
  plot.getXAxis().setAxisLabelText("Time Elapsed (s)");
  plot.getYAxis().setAxisLabelText("BPM");
  plot.setDim(400, 200);
 
  // Add the points
  plot.setPoints(points);
  
  // Draw it!
  plot.defaultDraw();
  plot.activatePanning();
  
  //FSR PLOT
  
  // Create a new plot and set its position on the screen
  GPlot plot2 = new GPlot(this);
  plot2.setPos(600, 110);

  // Set the plot title and the axis labels
  plot2.setTitleText("FSR");
  plot2.getXAxis().setAxisLabelText("Time Elapsed (s)");
  plot2.getYAxis().setAxisLabelText("Pressure");
  plot2.setDim(400, 200);
  

  // Add the points
  plot2.setPoints(points2);
  

  // Draw it!
  plot2.defaultDraw();
  plot2.activatePanning();
  
  delay(500);
}
