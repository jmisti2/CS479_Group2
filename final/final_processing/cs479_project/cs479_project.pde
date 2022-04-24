void setup() {
  size(1100, 750);
  background(255);
    
  //Initialize the bpm array and color array
  heartrateColors = new color[maxPoints];
  heartrates = new GPointsArray(maxPoints);
  
  
  
  // Initialize the plot
  plot = new GPlot(this,plotX, plotY, plotW, plotH);
  initializePlot();
  
  //load the tables
  userTable = loadTable("tables/userTable.csv", "header");
  cardioTable = loadTable("tables/cardioTable.csv", "header");
  
  //load the camera
  String[] cameras = Capture.list();
  cam = new Capture(this, cameras[0]);
  cam.start();
  
  //initialize controlp5 objects
  cameraOnController = new ControlP5(this); cameraOffController = new ControlP5(this); 
  startCardioController = new ControlP5(this); backController = new ControlP5(this); workoutsScreenController = new ControlP5(this);
  initializeButtons(cameraOnController,cameraOffController,startCardioController,backController);
  initializeWorkoutsScreenController(workoutsScreenController);
  
  startAccuracyController = new ControlP5(this);
  backController2 = new ControlP5(this);
  initButtons(startAccuracyController, backController2);

  //load images
  cardio_bag = loadImage("images/cardio_bag.png");
  cardio_button_image = loadImage("images/cardio_button.jpeg");
  speed_button_image = loadImage("images/speed_button.jpg");
  accuracy_button_image = loadImage("images/accuracy_button.jpg");
  punchImg = loadImage("images/punch.png");
  
  //establish the port
  String portName = Serial.list()[3];
  myPort = new Serial(this, portName, 115200);
}


void draw() {
  background(255);
  
  //Keep reading values from the sensors
  if(myPort.available() > 0){
      val = myPort.readStringUntil('\n');
      if(val != null){
        String[] list = split(val, ',');
        if(list.length >= 8){
          acx = int(list[0]);
          acy = int(list[1]);
          acz = int(list[2]);
          xang = int(list[3]);
          yang = int(list[4]);
          zang = int(list[5]);
          bpm = int(list[6]);
          fsr = int(list[7]);
        }
      }
    }
  
  if(cardioMode) {
    //display workout timer
    drawTimer();
    //draw the bpm plot
    drawPlot();
    //Display the legend
    drawLegend();
    //draw the bar chart
    drawBarChart();
    //draw the camera
    drawCameraButtons();
    //draw start btton 
    drawStartButton();
    //draw back button
    drawBackButton();
    //draw the stats 
    drawStats();
    //draw the cardio animation
    drawCardioAnimation();
    //draw the punching bag
    drawBag();
    
    //if the workout is over, stop the count, stop the workout and record the stats
    if(workoutTimer == 0) {
      cardioStarted = false;
      //save the workout stats into the csv file
      saveStats();
    }
    //Plot only every 1 second
    if(cardioStarted) {
      if(millis() - plottingTimer >= 1000) {    
        //Generate a random bpm and its color
        //if(Math.round(random(0,1)) == 0 ) {bpm = Math.round(random(50, 100));}
        //Based on the value of the BPM determine its color
        int c = determineBPMColor(bpm);
        
        //Add the bpm and its color to the plot
        addPoints(c, bpm);
        
        plottingTimer = millis();
        workoutTimer--;
        seconds++;
      }
      //display targets
      drawTargets();
    }
 
    
  }//end cardio mode
  else if(speedMode) {
    
  
  }//end speed mode
  else if (accuracyMode) {
    draw_accuracy();
  }//end accuracy mode
  else if(workoutsScreen) {
    drawWorkoutsScreen();
  }
  
  //delay(500);
}//End draw
