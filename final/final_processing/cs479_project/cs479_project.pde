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
  
  //initialize controlp5 objects
  c1 = new ControlP5(this); c2 = new ControlP5(this); c3 = new ControlP5(this); c4 = new ControlP5(this); 
  initializeButtons(c1,c2,c3,c4);

  //load images
  cardio_bag = loadImage("images/cardio_bag.png");
}


void draw() {
  background(255);
  
  
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
    
    //load images
    image(cardio_bag, cardioAnimationX-70, cardioAnimationY, cardioAnimationW+150, cardioAnimationH);
    //if the workout is over, stop the count, stop the workout and record the stats
    if(workoutTimer == 0) {
      cardioStarted = false;
    }
    //Plot only every 1 second
    if(cardioStarted) {
      if(millis() - plottingTimer >= 1000) {    
        //Generate a random bpm and its color
        if(Math.round(random(0,1)) == 0 ) {bpm = Math.round(random(50, 100));}
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
  
  //delay(500);
}//End draw
