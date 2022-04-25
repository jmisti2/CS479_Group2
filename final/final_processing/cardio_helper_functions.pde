import grafica.*;
import java.util.ArrayList; // import the ArrayList class
import java.util.*;
import controlP5.*;
import processing.video.*;

//graph information
color[] heartrateColors;//store the heartrate zone color of the heartrate
GPointsArray heartrates;//store the heartrates for the graph
int maxPoints = 150;
int plottingTimer = 0;
int seconds = 0;
//int bpm = 0;
GPlot plot;
//workout
boolean cardioStarted = false;
int workoutTimer = 900;//start at 15 minutes(900s) and count down
int strikeTimer;
boolean newStrikes = false;
String upper_strike1 = ""; String upper_strike2 = ""; String lower_strike = "";
float targetSpeed = 0.0;
String predCardioZone = "";
boolean prevStats = false;
boolean currStats = false;
int pastAvgBPM = 0;
int pastAvgCalories = 0;
String past_zone = "";
int currBPM = 0;
int currCalories = 0;
String currZone = "";
//CP5 UI elements
ControlP5 cameraOnController;
ControlP5 cameraOffController;
ControlP5 startCardioController;
ControlP5 backController;
ControlP5 workoutsScreenController;
ControlP5 c6;
PFont buttonFont;
Button cameraOnButton;
Button cameraOffButton;
Button startButton;
Button backButton;
//Plot coordinates and size
int plotX = -10;
int plotY = 100;
int plotW = 420;
int plotH = 300;
//Bar chart coordinates and size
int barX = 15;
int barY = 450;
int barW = 370;
int barH = 245;
int stickH = 45;
//Camera coordinates
int cameraX = 730;
int cameraY = 125;
int cameraW = 350;
int cameraH = 300;
Capture cam;
boolean cameraOn = false;
//Stats coordinates
int statsX = 730;
int statsY = 450;
int statsW = 350;
int statsH = 250;
//Cardio Animation coordinates
int cardioAnimationX = 400;
int cardioAnimationY = 125;
int cardioAnimationW = 300;
int cardioAnimationH = 575;
PImage cardio_bag;
//Cardio Zones Time
int veryLightZone = 0;//Keep track of seconds in this zone
int lightZone = 0;//Keep track of seconds in this zone
int moderateZone = 0;//Keep track of seconds in this zone
int hardZone = 0;//Keep track of seconds in this zone
int maxZone = 0;//Keep track of seconds in this zone
//CSV tables
Table userTable;//(Age, Sex, Weight, Height)
Table cardioTable;//(Date, AverageBPM, CaloriesBurned, LongestCardioZone)

String[] drawTargetsHelper() {
  //combo structure: (left punch type, right punch type, (left leg attack/ right leg attack) / (left hook / right hook)
  // punch types can be jab or uppercut, leg attack can be side kick or knee strike
  if(Math.round(random(0,1)) == 0) {upper_strike1 = "JAB";} else {upper_strike1 = "U-CUT";}
  if(Math.round(random(0,1)) == 0) {upper_strike2 = "JAB";} else {upper_strike2 = "U-CUT";}
  if(Math.round(random(0,1)) == 0) {lower_strike = "KNEE";} else {lower_strike = "KICK";}
  
  String[] combo = {upper_strike1, upper_strike2, lower_strike};
  return combo;
}

void saveStats() {
  //if the workout ended and we have not yet recorded the stats, save them
  if(!currStats) {
    TableRow curr_stats = cardioTable.addRow();
    
    float cals = (float(userTable.getString(0, "Weight")) / 2.20462) * 9.5 * 0.0175 * 15;
    int currentCalories = int(cals);
    int avgBPM = int((.5*veryLightZone + .6*lightZone + .7*moderateZone + .8*hardZone + .9*maxZone) / 
                      (veryLightZone + lightZone + moderateZone + hardZone + maxZone) );
    curr_stats.setString("CaloriesBurned", String.valueOf(currentCalories));
    curr_stats.setString("LongestCardioZone", predCardioZone);
    curr_stats.setString("AverageBPM", String.valueOf(avgBPM));
    saveTable(cardioTable, "tables/cardioTable.csv");
    
    currStats = true;
    
    println("stats save: " + cals + " " + avgBPM);
  }
}

void drawBag() {
  image(cardio_bag, cardioAnimationX-70, cardioAnimationY, cardioAnimationW+150, cardioAnimationH);
}

void drawTargets() {
  if(newStrikes) {
    String[] strikes = drawTargetsHelper();
    upper_strike1 = strikes[0]; upper_strike2 = strikes[1]; lower_strike = strikes[2];
    newStrikes = false;
  }
  fill(34, 77, 230);
  textSize(50);
  if(workoutTimer > 600) {targetSpeed = 0;}
  else if(workoutTimer > 300) {targetSpeed = 0.4;}
  else {targetSpeed = 0.6;}
  
  if(millis() - strikeTimer <= 1100 - 1000*targetSpeed) {text(upper_strike1, 460, 350);}
  else if(millis() - strikeTimer <= 2100 - 1000*targetSpeed) {text(upper_strike2, 550, 350);}
  else if(millis() - strikeTimer <= 3100 - 1000*targetSpeed) {text(lower_strike, 490, 500);}
  else if(millis() - strikeTimer >= 3800 - 1000*targetSpeed) {strikeTimer = millis(); newStrikes = true;}
  
  fill(0);
  textSize(25);
  if(targetSpeed == 0) {text("Slow Mode", width / 2 - 50, 100);}
  else if(targetSpeed == 0.4) {text("Moderate Mode", width / 2 - 70, 100);}
  else {text("Fast Mode", width / 2 - 50, 100);}
  
}


void initializeButtons(ControlP5 cameraOnController, ControlP5 cameraOffController, ControlP5 startCardioController, ControlP5 backController) {
  cameraOnController.setAutoDraw(false); cameraOffController.setAutoDraw(false); startCardioController.setAutoDraw(false); backController.setAutoDraw(false);
  Button cameraOnButton = cameraOnController.addButton("Turn Camera On", 0, cameraX + 60, cameraY + 100, 230, 70);
  Button cameraOffButton = cameraOffController.addButton("Turn Camera Off", 0, cameraX + 60, cameraY - 100, 230, 70);
  Button startButton = startCardioController.addButton("Start", 0, 130, 20, 100, 50);
  Button backButton = backController.addButton("Back", 0, 20, 20, 100, 50);
  cameraOnButton.setFont(createFont("Arial", 15)).setColorBackground(color(55, 186, 22)).setColorForeground(color(60, 232, 16));
  cameraOffButton.setFont(createFont("Arial", 15)).setColorBackground(color(173, 39, 29)).setColorForeground(color(230, 28, 14));
  startButton.setFont(createFont("AvenirNext-Medium", 15)).setColorBackground(color(7, 27, 110)).setColorForeground(color(12, 43, 173));
  backButton.setFont(createFont("AvenirNext-Medium", 15)).setColorBackground(color(60, 34, 125)).setColorForeground(color(89, 44, 201));
  cameraOnButton.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if(theEvent.getAction() == ControlP5.ACTION_PRESSED) {println("camera on");cameraOn = true; cam.start();}
    }
  });
  cameraOffButton.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if(theEvent.getAction() == ControlP5.ACTION_PRESSED) {println("camera off"); cameraOn = false;cam.stop();}
    }
  });
  startButton.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if(theEvent.getAction() == ControlP5.ACTION_PRESSED) {cardioStarted = true; strikeTimer = millis(); newStrikes = true;}
    }
  });
  backButton.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if(theEvent.getAction() == ControlP5.ACTION_PRESSED) {cardioMode = false; workoutsScreen = true;}
    }
  });
}

void drawTimer() {
  fill(0);
  textSize(40);
  String seconds = ""; String minutes = "";
  if(workoutTimer % 60 < 10) {seconds = "0" + workoutTimer % 60;} else {seconds = "" + workoutTimer % 60;}
  if(workoutTimer / 60 < 10) {minutes = "0" + workoutTimer / 60;} else {minutes = "" + workoutTimer / 60;}
  text(minutes + ":" + seconds, width / 2 - 40, 50);
  //println(workoutTimer);
}
void drawBackButton() {
  backController.draw();
}

void drawStartButton() {
  if(!cardioStarted && workoutTimer != 0) {
    startCardioController.draw();
  }
}

void initializePlot() {
  plot.getXAxis().setAxisLabelText("Time(s)");
  plot.getYAxis().setAxisLabelText("BPM");
  plot.setPointSize(7);
}
void drawPlot() {
  // Add the points
  plot.setPointColors(heartrateColors);
  plot.setPoints(heartrates);
  
  // Draw it!
  plot.defaultDraw();
}

void drawCameraButtons() {
  stroke(0);
  fill(255);
  rect(cameraX, cameraY, cameraW-5, cameraH-5);
  
  //Draw the on-button if camera is off
  if(!cameraOn) {
    cameraOnController.draw();
  } else {
    cameraOffController.draw();
    if (cam.available() == true) {
      cam.read();
    }
    pushMatrix();
    translate( cameraX + cameraW, cameraY );
    scale( -1, 1 );
    image( cam, 0, 0, cameraW, cameraH );
    popMatrix();
    //image(cam, cameraX, cameraY, cameraW, cameraH);
  }
}

void drawStats() {
  stroke(0);
  fill(255);
  rect(statsX, statsY, statsW, statsH);
  
  if(!prevStats) {
    int[] zones = {0,0,0,0,0};
    for(int i = 0; i < cardioTable.getRowCount(); i++) {
      pastAvgBPM += int(cardioTable.getString(i, "AverageBPM"));
      pastAvgCalories += int(cardioTable.getString(i, "CaloriesBurned"));
      if(cardioTable.getString(i, "LongestCardioZone").equals("very light")) {zones[0] += 1;}
      else if(cardioTable.getString(i, "LongestCardioZone").equals("light")) {zones[1] += 1;}
      else if(cardioTable.getString(i, "LongestCardioZone").equals("moderate")) {zones[2] += 1;}
      else if(cardioTable.getString(i, "LongestCardioZone").equals("hard")) {zones[3] += 1;}
      else if(cardioTable.getString(i, "LongestCardioZone").equals("max")) {zones[4] += 1;}
    }
    int past_max = zones[0];int past_i = 0;
    for(int i = 0; i < 5; i++) {
      if(zones[i] > past_max) {past_max = zones[i]; past_i = i;}
    }
    //get the past predominant zone
    if(past_i == 0) {past_zone = "Very Light";}
    else if(past_i == 1) {past_zone = "Light";}
    else if(past_i == 2) {past_zone = "Moderate";}
    else if(past_i == 3) {past_zone = "Hard";}
    else {past_zone = "Max";}
    
    pastAvgBPM /= cardioTable.getRowCount();
    pastAvgCalories /= cardioTable.getRowCount();
    prevStats = true;
  }//end if
  
  //if the workout is still ongoing, keep calculating the current stats
  if(workoutTimer > 0) {
    //Get past average BPM, and average calories burned
    int[] curr_zones = {veryLightZone, lightZone, moderateZone, hardZone, maxZone};
    
    //Determine which cardio zone the user has been the longest in on average
    int curr_max = curr_zones[0]; int curr_i = 0;
    String curr_zone = "";
    for(int i = 0; i < 5; i++) {
      if(curr_zones[i] > curr_max) {curr_max = curr_zones[i]; curr_i = i;}
    }
    
    //get the current predominant zone
    if(curr_i == 0) {curr_zone = "Very Light";}
    else if(curr_i == 1) {curr_zone = "Light";}
    else if(curr_i == 2) {curr_zone = "Moderate";}
    else if(curr_i == 3) {curr_zone = "Hard";}
    else {curr_zone = "Max";}
    
    //Calculate the current caloric expenditure (weight_lb/2.20462) * 9.5 * 0.0175 * minutes
    float cals = (float(userTable.getString(0, "Weight")) / 2.20462) * 9.5 * 0.0175 * (seconds / 60);
    int currentCalories = int(cals);
    predCardioZone = curr_zone;
    currBPM = bpm;
    currCalories = currentCalories;
    currZone = curr_zone;
  }
  
  //Display the stats
  textSize(30);
  fill(0);
  text("Past Workouts Stats", statsX + 40, statsY + 27);
  textSize(20);
  fill(bpmToColor(pastAvgBPM));
  text("Avg. BPM: " + pastAvgBPM, statsX + 10, statsY + 55);
  fill(0);
  text("Avg. Caloric Expenditure: " + pastAvgCalories, statsX + 10, statsY + 78);
  fill(zoneToColor(past_zone));
  text("Predominant Cardio Zone: " + past_zone, statsX + 10, statsY + 102);
  fill(0);
  line(statsX, statsY + 120, statsX + statsW, statsY + 120); 
  textSize(28);
  text("Current Workout Stats", statsX + 30, statsY + 147);
  textSize(20);
  fill(bpmToColor(bpm));
  text("Current BPM: " + currBPM, statsX + 10, statsY + 175);
  fill(0);
  text("Current Caloric Expenditure: " + currCalories, statsX + 10, statsY + 200);
  fill(zoneToColor(currZone));
  text("Predominant Cardio Zone: " + currZone, statsX + 10, statsY + 225); 
}

color bpmToColor(int bpm) {
  int age = int(userTable.getString(0, "Age"));
  int max = 220 - age;
  if (bpm < .5 * max) {return color(142, 150, 141);}//gray 
  else if(bpm < .6 * max) {return color(56, 140, 209);}//blue
  else if(bpm < .7 * max) {return color(28, 199, 48);}//green
  else if(bpm < .8 * max) {return  color(230, 142, 60);}//orange
  else {maxZone++; return color(204, 38, 33);}//red
}

color zoneToColor(String zone) {
  if (zone.toLowerCase().equals("very light")) {return color(142, 150, 141);}//gray 
  else if(zone.toLowerCase().equals("light")) {return color(56, 140, 209);}//blue
  else if(zone.toLowerCase().equals("moderate")) {return color(28, 199, 48);}//green
  else if(zone.toLowerCase().equals("hard")) {return  color(230, 142, 60);}//orange
  else {return color(204, 38, 33);}//red
}

void drawCardioAnimation() { 
  stroke(0);
  fill(255);
  rect(cardioAnimationX, cardioAnimationY, cardioAnimationW, cardioAnimationH);
}
void drawLegend() {
  //Display the legend
  noStroke();
  textSize(15);
  fill(142, 160, 141);
  circle(20,115,15);
  text("Very Light", 30, 120);
  fill(56, 140, 209);
  circle(120, 115, 15);
  text("Light", 130, 120);
  fill(28, 199, 48);
  circle(185, 115, 15);
  text("Moderate", 195, 120);
  fill(230, 142, 60);
  circle(280, 115, 15);
  text("Hard", 290, 120);
  fill(204, 38, 33);
  circle(340, 115, 15);
  text("Max", 350, 120);
}


void drawBarChart() {
  textSize(30);
  stroke(0);
  fill(255);
  rect(barX, barY, barW, barH);
  //noStroke();
  fill(0);
  text("Cardio Zone Time", barX + 80, barY - 15);
  textSize(17);
  //very light zone    
  fill(142, 150, 141);
  //restrict the length of the bar
  if(veryLightZone > 1000) {rect(barX, barY, 300, stickH);fill(0);text(veryLightZone/60 + "m" + veryLightZone % 60 + "s", 300 + 17, barY + 30);}
  else {rect(barX, barY, .3 * veryLightZone, stickH);fill(0);text(veryLightZone/60 + "m" + veryLightZone % 60 + "s", .3 * veryLightZone + 17, barY + 30);}
  //light zone
  fill(56, 140, 209);
  if(lightZone > 1000) {rect(barX, barY + stickH + 5, 300, stickH);fill(0);text(lightZone/60 + "m" + lightZone%60 + "s", 300 + 17, barY + 75);}
  else { rect(barX, barY + stickH + 5, .3 * lightZone, stickH);fill(0);text(lightZone/60 + "m" + lightZone%60 + "s", (.3 * lightZone) + 17, barY + 75);}
  //moderate zone
  fill(28, 199, 48);
  if(moderateZone > 1000) {rect(barX, barY + 2*stickH + 10, 300, stickH);fill(0);text(moderateZone/60 + "m" + moderateZone%60 + "s", 300 + 17, barY + 125);}
  else { rect(barX, barY + 2*stickH + 10, .3 * moderateZone, stickH);fill(0);text(moderateZone/60 + "m" + moderateZone%60 + "s", (.3 * moderateZone) + 17, barY + 125);}
  //hard zone
  fill(230, 142, 60);
  if(hardZone > 1000) {rect(barX, barY + 3*stickH + 15, 300, stickH);fill(0);text(hardZone/60 + "m" + hardZone%60 + "s", 300 + 17, barY + 180);}
  else { rect(barX, barY + 3*stickH + 15, .3 * hardZone, stickH);fill(0);text(hardZone/60 + "m" + hardZone%60 + "s", (.3 * hardZone) + 17, barY + 180);}
  //max zone
  fill(204, 38, 33);
  if(maxZone > 1000) {rect(barX, barY + 4*stickH + 20, 300, stickH);fill(0);text(maxZone/60 + "m" + maxZone%60 + "s", 300 + 17, barY + 225);}
  else {rect(barX, barY + 4*stickH + 20, .3 * maxZone, stickH);fill(0);text(maxZone/60 + "m" + maxZone%60 + "s", (.3 * maxZone) + 17, barY + 225);}
}
//Determine the color of ther bpm based on its value
int determineBPMColor(int bpm) {
  int age = int(userTable.getString(0, "Age"));
  int max = 220 - age;
  if (bpm < .5 * max) {veryLightZone++; return color(142, 150, 141);}//gray 
  else if(bpm < .6 * max) {lightZone++; return color(56, 140, 209);}//blue
  else if(bpm < .7 * max) {moderateZone++; return color(28, 199, 48);}//green
  else if(bpm < .8 * max) {hardZone++; return  color(230, 142, 60);}//orange
  else {maxZone++; return color(204, 38, 33);}//red
} 

//Adds points to the plot
void addPoints(int c, int bpm) {
  //If the array isn't filled up to maxPoints, keep adding points to it
  if(heartrates.getNPoints() < maxPoints) {
    //If this the first point, just add it to the array
    if(heartrates.getNPoints() == 0) {
      heartrates.add(seconds, bpm);
      heartrateColors[0] = c;
    }
    else {
      //Check whether the newest point is different than the previous one
      GPoint prev = heartrates.get(heartrates.getNPoints() - 1);
      if(prev.getY() == bpm) {
        //Add 1 second to the last point in the array
        heartrates.setX(heartrates.getNPoints() - 1, heartrates.getX(heartrates.getNPoints() - 1) + 1);
      } 
      else {
        heartrates.add(seconds, bpm);
        heartrateColors[heartrates.getNPoints()-1] = c;
      }
    }
  }
  else {
    println(heartrates.getNPoints());
    //Check whether the newest point is different than the previous one
    GPoint prev = heartrates.get(heartrates.getNPoints() - 1);
    if(prev.getY() == bpm) {
      //Add 1 second to the last point in the array
      heartrates.setX(heartrates.getNPoints() - 1, heartrates.getX(heartrates.getNPoints() - 1) + 1);
    }
    else {
      //Shift the colors and points by 1 to the left
      color[] tempColors = new color[maxPoints];
      for(int i = 0; i < maxPoints-1; i++) {
        tempColors[i] = heartrateColors[i+1];
        heartrates.set(i, heartrates.get(i+1));
      }
      //Add the new color and new point
      tempColors[maxPoints - 1] = c;
      heartrateColors = tempColors;
      heartrates.setXY(maxPoints - 1, seconds, bpm); 
    }
  }
}

void keyPressed() {
  if(key == 'z') {workoutTimer -= 110;}
}
