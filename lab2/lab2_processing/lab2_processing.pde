//lab 2

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
ArrayList < Integer > pointsList = new ArrayList < Integer > ();
ArrayList < Integer > pointsList2 = new ArrayList < Integer > ();

//flags for scene changes
boolean stressMode;
boolean fitnessMode;
boolean meditationMode;
boolean startingScene;
boolean calculatingScene;
boolean ageScene;

String ageInput; //stores input of user
int userAge; //Stores the age of the user
int userMaxHeartrate; //220 - user age

//breathing variables
int breathCount = 0;
int newCount = 0;
boolean flag = false;
int respRate = 0;
int inhDur = 0;
int exDur = 0;

void setup() {
    size(1110, 600); // window size
    background(64, 64, 64);

    // List all the available serial ports
    String portName = Serial.list()[2];
    myPort = new Serial(this, portName, 115200);
    startingScene = true;
    ageInput = "";
}

void draw() {
    background(64, 64, 64);
    fill(255, 255, 255);

    if (myPort.available() > 0) {
        val = myPort.readStringUntil('\n');
        println(val);
        if (val != null) {
            //heartrate, confidence, oxygen, status
            String[] list = split(val, ',');
            if (list.length == 3) {
                ecg = list[0];
                hr = list[1];
                fsr = list[2];
            }

        }
    }

    if (startingScene) {
        textSize(50);
        fill(255);
        text("Choose mode", 340, 150);

        //Fitness button
        textSize(35);
        fill(color(167, 197, 235)); //146,169,189
        rect(100, 300, 150, 75, 28);
        fill(0);
        text("Fitness", 125, 345);

        //Stress button
        fill(color(211, 228, 205)); // 153,167,153
        rect(400, 300, 150, 75, 28);
        fill(0);
        text("Stress", 427, 345);

        //meditation button
        fill(color(175, 149, 194));
        rect(700, 300, 200, 75, 28);
        fill(0);
        text("Meditation", 720, 345);


        //If mouse is hovering over the fitness button, change its color
        if (mouseX >= 100 && mouseX <= 250 && mouseY >= 200 && mouseY <= 375) {
            textSize(35);
            fill(color(146, 169, 189));
            rect(100, 300, 150, 75, 28);
            fill(0);
            text("Fitness", 125, 345);
            //If he user presses the fitness button switch to age stage
            if (mousePressed) {
                startingScene = false;
                ageScene = true;
            }
        }
        //If the mouse is hovering over the stress button, change its color
        if (mouseX >= 400 && mouseX <= 550 && mouseY >= 200 && mouseY <= 375) {
            textSize(35);
            fill(color(153, 167, 153));
            rect(400, 300, 150, 75, 28);
            fill(0);
            text("Stress", 427, 345);
            if (mousePressed) {
                startingScene = false;
            }
        }
        //If the mouse is hovering over the stress button, change its color
        if (mouseX >= 700 && mouseX <= 900 && mouseY >= 200 && mouseY <= 375) {
            textSize(35);
            fill(color(157, 149, 183));
            rect(700, 300, 200, 75, 28);
            fill(0);
            text("Meditation", 720, 345);

            if (mousePressed) {
                startingScene = false;
            }
        }

    } else if (ageScene) {
        textSize(35);
        text("Type your age.", 400, 200);
        text("Press x to delete input and enter to save the age.", 150, 300);
        text("Age: " + ageInput, 375, 400);
        fill(255);
    } else if (fitnessMode) {

        textSize(30);

        text(millis() / 60000 + ":" + (millis()/1000)%60, 540, 30);
        text("BPM: " + hr, 10, 90);
        text("Resting BPM: " + hr, 10, 90);

        //Adds points to ecg Plot
        if (int(ecg) != 0) {
            if (nPoints >= 200) {
                points.remove(0);
                points.add(nPoints, int(ecg));
                pointsList.remove(0);
                pointsList.add(int(hr));
            } else {
                points.add(nPoints, int(ecg));
                pointsList.add(int(hr));
            }
            nPoints++;
        }

        int fsrPoint = int(float(fsr));
        
        //Adds points to fsr Plot
        if (nPoints2 >= 600) {
          points2.remove(0);
        }
        if(fsrPoint > 100){
          points2.add(nPoints2, fsrPoint);
        }
        
        int threshold = 350;
        
        if(millis() > 5000){
          if(fsrPoint > threshold){
            if(!flag){
              breathCount++;
              flag = true;
            }
            exDur++;
          }
          else if(fsrPoint < threshold){
            inhDur++;
            flag = false;
          }
        }
        if((((millis()/1000)%60)%30) == 0){
          respRate = breathCount*2;
        }
        
        
        
        text("FSR: " + fsrPoint, 600, 90);
        text("Breath Count: " + breathCount, 600, 450);
        text("Inhalation Duration: " + inhDur + "(ms)", 600, 480);
        text("Exhalation Duration: " + exDur + "(ms)", 600, 510);
        text("Respiration Rate: " + respRate + "(br/min)", 600, 540);

        nPoints2++;

        color[] pointColors = new color[pointsList.size()];

        for (int i = 0; i < pointsList.size(); i++) {
            if (pointsList.get(i) >= int(userMaxHeartrate * .90)) {
                pointColors[i] = color(255, 0, 0);
                //max++;
            } else if (pointsList.get(i) >= int(userMaxHeartrate * .80)) {
                pointColors[i] = color(255, 128, 0);
                //hard++;
            } else if (pointsList.get(i) >= int(userMaxHeartrate * .70)) {
                pointColors[i] = color(0, 153, 0);
                //moderate++;
            } else if (pointsList.get(i) >= int(userMaxHeartrate * .60)) {
                pointColors[i] = color(0, 128, 255);
                //light++;
            } else if (pointsList.get(i) >= int(userMaxHeartrate * .50)) {
                pointColors[i] = color(160, 160, 160);
                //vlight++;
            } else {
                pointColors[i] = color(0, 0, 0);
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

    }
    delay(1);
}

void keyPressed() {
    //delete the last character the user typed
    if (key == 'x' && ageScene) {
        if (ageInput.length() > 0) {
            ageInput = ageInput.substring(0, ageInput.length() - 1);
        }
    }
    //save the age and move onto the fitness stage
    else if (key == ENTER && ageScene) {
        userAge = Integer.parseInt(ageInput);
        userMaxHeartrate = 220 - userAge;
        ageScene = false;
        fitnessMode = true;
    }
    //add what the user is typing onto the string
    else if (ageScene) {
        ageInput += key;
    }
}
