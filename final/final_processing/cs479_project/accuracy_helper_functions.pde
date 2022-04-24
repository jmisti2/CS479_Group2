//accuracy screen

ControlP5 startAccuracyController;
ControlP5 backController2;

Table accuracyTable;

int xangAvg, yangAvg, zangAvg;
String angleRating = "";

int lastTime = 0;
int intervalTime = 0;
int intervalCount = 0;
int intervalTotal = 0;
int intervalsHit = 0;
int intervalStopper = 0;

int punchCount;
int punchSpeed;
float punchRating;
int fsrReading;
float acc = 0;
int writeOnce = 0;

boolean punchDetected;

int strikeTimer2;
int accuracyTimer = 120;

boolean accuracyStarted = false;
boolean newStrikes2 = false;
PImage punchImg;

ArrayList<Integer> acxList = new ArrayList<Integer>();
ArrayList<Integer> acyList = new ArrayList<Integer>();
ArrayList<Integer> aczList = new ArrayList<Integer>();
ArrayList<Integer> xangList = new ArrayList<Integer>();
ArrayList<Integer> yangList = new ArrayList<Integer>();
ArrayList<Integer> zangList = new ArrayList<Integer>();
ArrayList<String> angleList = new ArrayList<String>();
ArrayList<Integer> fsrList = new ArrayList<Integer>();

ArrayList<String> intervalList = new ArrayList<String>(Arrays.asList("Jab","Cross","Hook","Cross","Hook","Jab","Hook"));
ArrayList<Integer> intervalListX = new ArrayList<Integer>(Arrays.asList(520, 520, 570, 520, 570, 520, 570));
ArrayList<Integer> intervalListY = new ArrayList<Integer>(Arrays.asList(330, 460, 400, 460, 400, 330, 400));


void draw_accuracy() {
    drawTimerAccuracy();
    
    backController2.draw();
    startAccuracyController.draw();
    
    stroke(0);
    fill(255);
    rect(cardioAnimationX, cardioAnimationY, cardioAnimationW, cardioAnimationH);
    rect(50,125,300,285);
    rect(50,450,300,250);
    
    rect(750,125,300,285);
    rect(750,450,300,250);
    
    image(cardio_bag, cardioAnimationX-70, cardioAnimationY, cardioAnimationW+150, cardioAnimationH);
    
    if (cam.available() == true) {
     cam.read();
    }
    image(cam, 750, 450, 300, 250);
    
    fill(255,0,0);
    
    accuracyTable = loadTable("tables/accuracyTable.csv", "header");
    
    if(accuracyTimer == 0 && writeOnce < 1){
      TableRow stats = accuracyTable.addRow();
      stats.setInt("Accuracy", (int)acc);
      stats.setInt("Punches", punchCount);
      stats.setString("Date", month() + "/" + day());
      stats.setString("Acc", intervalsHit + "/" + intervalTotal);
  
      saveTable(accuracyTable, "tables/accuracyTable.csv");
      writeOnce++;
    }
    
    if(accuracyStarted && accuracyTimer > 0){
      int interval = 1000;
      
      if(accuracyTimer < 90){
        interval = 500;
      }
      else if(accuracyTimer < 60){
        interval = 1250;
      }
      
      if(millis() - lastTime >= 1000){
        accuracyTimer--;
        lastTime = millis();
      }
      
      if(millis() - intervalTime >= interval){
        intervalCount++;
        intervalTotal++;
        intervalStopper = 0;
        intervalTime = millis();
      }
      else{
        if(intervalCount == intervalList.size()){
          intervalCount = 0;
        }
        text(intervalList.get(intervalCount),intervalListX.get(intervalCount), intervalListY.get(intervalCount));
        image(punchImg, intervalListX.get(intervalCount), intervalListY.get(intervalCount), 100, 100);
        
        if(punchDetected){
          intervalStopper++;
          if(intervalStopper <= 1){
            fsrReading = (int)fsr;
            intervalsHit++;
          }
        }
        
      }
      
    }
    
    fill(0);
    
    
    //storing last 30 angle points
    if(xangList.size() == 30){
      xangList.remove(0);
    }
    xangList.add(xang);
    
    if(yangList.size() == 30){
      yangList.remove(0);
    }
    yangList.add(yang);
    
    if(zangList.size() == 30){
      zangList.remove(0);
    }
    zangList.add(zang);
    
    //storing last 30 acx points
    if(acxList.size() == 30){
      acxList.remove(0);
    }
    acxList.add(acx);
    
    if(fsrList.size() == 30){
      fsrList.remove(0);
    }
    fsrList.add(fsr);
    
    
    //detects punch
    if(acx > 1000 && acz < 15000){
      punchDetected = true;
      
    }
    else{
      if(punchDetected){
        for(int i = 0; i < 30; i++){
          angleList.add(detectAngle(xangList.get(i),yangList.get(i),zangList.get(i)));
          xangAvg += xangList.get(i);
          yangAvg += yangList.get(i);
          zangAvg += zangList.get(i);
        }
        xangAvg = xangAvg/30;
        yangAvg = yangAvg/30;
        zangAvg = zangAvg/30;
                
        angleList = new ArrayList<String>();
        
        punchSpeed = findMax(acxList);
        fsrReading = findMax(fsrList);
        
        punchRating = (((float)punchSpeed/20000)*100 + ((float)xangAvg/100)*100 + ((float)yangAvg/200)*100 + ((float)zangAvg/100)*100)/4;
        //punchRating = ((float)punchSpeed/20000)*100;

        saveFrame("images/punches/"+punchCount+".png");
        punchCount++;
        
        if(xangAvg > 80 && yangAvg > 150 && zang > 100){
          angleRating = "Great";
        }
        else{
          angleRating = "Bad";
        }
      }
      punchDetected = false;
    }
    
    
    String pastAcc = accuracyTable.getString(accuracyTable.getRowCount()-1, "Accuracy");
    String pastPunches = accuracyTable.getString(accuracyTable.getRowCount()-1, "Punches");
    String pastDate = accuracyTable.getString(accuracyTable.getRowCount()-1, "Date");
    String pastTotal = accuracyTable.getString(accuracyTable.getRowCount()-1, "Acc");
    
    textSize(35);
    text("Punch Information", 760, 160);
    
    if(punchDetected){
      fill(255,0,0);
    }
    
    textSize(30);
    text("Punch Speed: " + punchSpeed,  760, 200);
    text("Punch Score: " + (int)punchRating, 760, 240);
    text("Angle Rating: " + angleRating, 760, 280);
    text("Punch Force: " + fsrReading, 760, 320);
    
    fill(0);
    textSize(35);
    text("Accuracy Stats", 60, 160);
    
    textSize(30);
    text("Punch Count: " + punchCount, 60, 200);
    text("Accuracy: " + intervalsHit + "/" + intervalTotal, 60, 240);
    
    textSize(35);
    text("Past Session: " + pastDate, 60, 490);
    
    textSize(30);
    text("Punch Count: " + pastPunches, 60, 530);
    text("Accuracy: " + pastTotal, 60, 570);
    text("Accuracy Score: " + pastAcc, 60, 610);
    
    
    
    if(intervalTotal > 0){
      acc = (intervalsHit*(100.0f))/(float)intervalTotal;
      text("Accuracy Score: " + (int)acc + "%", 60, 280);
    }
    else{
      text("Accuracy Score: ", 60, 280);
    }
    
    
    
     
}

String detectAngle(int x, int y, int z){
  
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
int findMax(ArrayList<Integer> arr){
  int max = arr.get(0);
  for(int i = 1; i < arr.size(); i++){
    if (arr.get(i) > max){
      max = arr.get(i);
    }
  }
  return max;
}

void initButtons(ControlP5 startAccuracyController, ControlP5 backController2) {
  startAccuracyController.setAutoDraw(false);
  backController2.setAutoDraw(false);

  Button startButton2 = startAccuracyController.addButton("Start", 0, 130, 20, 100, 50);
  Button backButton2 = backController2.addButton("Back", 0, 20, 20, 100, 50);
  startButton2.setFont(createFont("Arial", 15)).setColorBackground(color(7, 27, 110)).setColorForeground(color(12, 43, 173));
  backButton2.setFont(createFont("Arial", 15)).setColorBackground(color(60, 34, 125)).setColorForeground(color(89, 44, 201));

  startButton2.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if(theEvent.getAction() == ControlP5.ACTION_PRESSED) {
        accuracyStarted = true;
        punchCount = 0;
        lastTime = 0;
        intervalTime = 0;
        intervalCount = 0;
        intervalTotal = 0;
        intervalsHit = 0;
        intervalStopper = 0;
        punchCount = 0;
        acc = 0;
        writeOnce = 0;
        accuracyTimer = 10;
      }
    }
  });
  backButton2.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if(theEvent.getAction() == ControlP5.ACTION_PRESSED) {
        accuracyMode = false; 
        workoutsScreen = true;
        accuracyStarted = false;
        punchCount = 0;
        lastTime = 0;
        intervalTime = 0;
        intervalCount = 0;
        intervalTotal = 0;
        intervalsHit = 0;
        intervalStopper = 0;
        punchCount = 0;
        acc = 0;
        writeOnce = 0;
        accuracyTimer = 10;
      }
    }
  });
}

void drawTimerAccuracy() {
  fill(0);
  textSize(40);
  String seconds = ""; String minutes = "";
  if(accuracyTimer % 60 < 10) {seconds = "0" + accuracyTimer % 60;} else {seconds = "" + accuracyTimer % 60;}
  if(accuracyTimer / 60 < 10) {minutes = "0" + accuracyTimer / 60;} else {minutes = "" + accuracyTimer / 60;}
  text(minutes + ":" + seconds, width / 2 - 40, 50);
  //println(workoutTimer);
}
