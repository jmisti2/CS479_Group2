
ControlP5 startSpeedController3;
ControlP5 backController3;
ControlP5 speedController;

Table speedTable;

Button cameraOnButton3;
Button cameraOffButton3;
Button startButton3;
Button backButton3;

int xangAvg2, yangAvg2, zangAvg2;
String angleRating2 = "";

int prevTime = 0;
int intervalTimer = 0;
int intervalNum = 0;
int intervalSum = 0;
int intervalsPassed = 0;
int intervalStop = 0;
int hits = 0;

int punchCounter;
int punchSpeed2;
int maxSpeed;
float punchRating2;
int fsrVal;
float acel = 0;
int writing = 0;

boolean punchDetected2;

int speedTimer = 60;

boolean speedStart = false;

ArrayList<Integer> acxList3 = new ArrayList<Integer>();
ArrayList<Integer> acyList3 = new ArrayList<Integer>();
ArrayList<Integer> aczList3 = new ArrayList<Integer>();
ArrayList<Integer> xangList3 = new ArrayList<Integer>();
ArrayList<Integer> yangList3 = new ArrayList<Integer>();
ArrayList<Integer> zangList3 = new ArrayList<Integer>();
ArrayList<String> angleList3 = new ArrayList<String>();
ArrayList<Integer> fsrList3 = new ArrayList<Integer>();

ArrayList<String> intervalList3 = new ArrayList<String>(Arrays.asList("Jab","Cross","Hook","Cross","Hook","Jab","Hook"));
ArrayList<Integer> intervalListX3 = new ArrayList<Integer>(Arrays.asList(520, 520, 570, 520, 570, 520, 570));
ArrayList<Integer> intervalListY3 = new ArrayList<Integer>(Arrays.asList(330, 460, 400, 460, 400, 330, 400));


void drawStartButton2() {
  if(!speedStart && speedTimer != 0) {
    startCardioController.draw();
  }
}

void initializeSpeedButtons(ControlP5 startSpeedController, ControlP5 backController){
  speedController.setAutoDraw(false);
  startSpeedController3.setAutoDraw(false); 
  backController3.setAutoDraw(false);
 
  Button startButton3 = startSpeedController.addButton("Start", 0, 130, 20, 100, 50);
  Button backButton3 = backController.addButton("Back", 0, 20, 20, 100, 50);
  startButton3.setFont(createFont("Arial", 15)).setColorBackground(color(7, 27, 110)).setColorForeground(color(12, 43, 173));
  backButton3.setFont(createFont("Arial", 15)).setColorBackground(color(60, 34, 125)).setColorForeground(color(89, 44, 201));
  

  startButton3.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if(theEvent.getAction() == ControlP5.ACTION_PRESSED) {
        speedStart = true; 
        speedTimer = 60;
        prevTime = 0;
        intervalTimer = 0;
        intervalNum = 0;
        intervalSum = 0;
        intervalsPassed = 0;
        intervalStop = 0;
        hits = 0;
        punchCounter = 0;
        punchSpeed2 = 0;
        acel = 0;
        writing = 0;
     }
    }
  });
  backButton3.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if(theEvent.getAction() == ControlP5.ACTION_PRESSED) {
        speedStart = false;
        speedMode = false; 
        workoutsScreen = true;
        speedStart = false;
        newStrikes = true;
        speedTimer = 60;
        prevTime = 0;
        intervalTimer = 0;
        intervalNum = 0;
        intervalSum = 0;
        intervalsPassed = 0;
        intervalStop = 0;
        hits = 0;
        punchCounter = 0;
        punchSpeed2 = 0;
        acel = 0;
        writing = 0;
      }
    }
  });
  
}

String detectAngle2(int x, int y, int z){
  
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

int findMax2(ArrayList<Integer> arr){
  int max = arr.get(0);
  for(int i = 1; i < arr.size(); i++){
    if (arr.get(i) > max){
      max = arr.get(i);
    }
  }
  return max;
}

void drawSpeedScene(){
  drawTimerSpeed();
  
  backController3.draw();
  speedController.draw();
  startSpeedController3.draw();
  
  stroke(0);
  fill(255);
  rect(cardioAnimationX, cardioAnimationY, cardioAnimationW, cardioAnimationH);
  rect(50,125,300,285);
  rect(50,450,300,250);
    
  rect(750,125,300,285);
  
  drawBag(); 
  drawCameraButtons();
  //draw start btton 
  drawStartButton2();
  //draw back button
  drawBackButton();
  speedTable = loadTable("tables/speedTable.csv", "header");
  
  //end of timer and write to data file stats
  if(speedTimer == 0 && writing < 1){
      TableRow stats = speedTable.addRow();
      stats.setInt("Punches", punchCounter);
      stats.setInt("Max Speed", maxSpeed);
      stats.setString("Date", month() + "/" + day());
  
      saveTable(speedTable, "tables/accuracyTable.csv");
      writing++;
  }
  
  if(speedStart && speedTimer > 0){
    if(millis() - prevTime >= 1000){
      speedTimer--;
      prevTime = millis();
     
    }
  }
  
  //storing last 30 angle points
    if(xangList3.size() == 30){
      xangList3.remove(0);
    }
    xangList3.add(xang);
    
    if(yangList3.size() == 30){
      yangList3.remove(0);
    }
    yangList3.add(yang);
    
    if(zangList3.size() == 30){
      zangList3.remove(0);
    }
    zangList3.add(zang);
    
    //storing last 30 acx points
    if(acxList3.size() == 30){
      acxList3.remove(0);
    }
    acxList3.add(acx);
    
    if(fsrList3.size() == 30){
      fsrList3.remove(0);
    }
    fsrList3.add(fsr);
    
    
    //detects punch
    if(acx > 1000 && acz < 15000){
      punchDetected2 = true;
      
    }
    else{
      if(punchDetected2){
        for(int i = 0; i < 30; i++){
          angleList3.add(detectAngle2(xangList3.get(i),yangList3.get(i),zangList3.get(i)));
          xangAvg2 += xangList3.get(i);
          yangAvg2 += yangList3.get(i);
          zangAvg2 += zangList3.get(i);
        }
        xangAvg2 = xangAvg2/30;
        yangAvg2 = yangAvg2/30;
        zangAvg2 = zangAvg2/30;
                
        angleList3 = new ArrayList<String>();
        
        punchSpeed2 = findMax2(acxList3);
        fsrVal = findMax2(fsrList3);
        
        punchRating2 = (((float)punchSpeed2/20000)*100 + ((float)xangAvg2/100)*100 + ((float)yangAvg2/200)*100 + ((float)zangAvg2/100)*100)/4;
        punchCounter++;
        
        if(xangAvg2 > 80 && yangAvg2 > 150 && zang > 100){
          angleRating2 = "Great";
        }
        else{
          angleRating2 = "Bad";
        }
      }
      punchDetected2 = false;
    }
    
    String pastDate2 = speedTable.getString(speedTable.getRowCount()-1, "Date");
    String pastPunches2 = speedTable.getString(speedTable.getRowCount()-1, "Punches");
    String pastSpeed = speedTable.getString(speedTable.getRowCount()-1, "Max Speed");
    
    
    fill(0);
    textSize(35);
    text("Punch Stats", 60, 160); 
    textSize(30);
    text("Punch Count: " + punchCounter, 60, 200);
    text("Punch Speed: " + punchSpeed2, 60, 240);
    text("Angle Rating: " + angleRating2, 60, 280);
    text("Punch Force: " + fsrVal, 60, 320);
    
    textSize(35);
    text("Past Session", 60, 490);
    textSize(30);
    text("Date: " + pastDate2, 60, 530);
    text("Total Punches: " + pastPunches2, 60, 570);
    text("Max Speed: " + pastSpeed, 60, 610);
  
}

void drawTimerSpeed() {
  fill(0);
  textSize(40);
  String seconds = ""; String minutes = "";
  if(speedTimer % 60 < 10) {seconds = "0" + speedTimer % 60;} else {seconds = "" + speedTimer % 60;}
  if(speedTimer / 60 < 10) {minutes = "0" + speedTimer / 60;} else {minutes = "" + speedTimer / 60;}
  text(minutes + ":" + seconds, width / 2 - 40, 50);
}
