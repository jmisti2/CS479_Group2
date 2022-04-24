//coordinates for each button and image
//int cardioX = 10;
//int cardioY = 50;
//int cardioW = 360;
//int cardioH = height;

//images
PImage cardio_button_image;
PImage speed_button_image;
PImage accuracy_button_image;


void initializeWorkoutsScreenController(ControlP5 c) {
  c.setAutoDraw(false);
  
  //Add one button for each workout
  Button cardio = c.addButton("Cardio")
     .setValue(0)
     .setPosition(90, 220)
     .setSize(200,60)
     .setFont(createFont("Arial", 20))
     .setColorBackground(color(43, 199, 38))
     .setColorForeground(color(0, 252, 114));
     ;
  Button speed = c.addButton("Speed")
     .setValue(0)
     .setPosition(450,220)
     .setSize(200,60)
     .setFont(createFont("Arial", 20))
     .setColorBackground(color(207, 35, 35))
     .setColorForeground(color(247, 5, 5));
     ;
  Button accuracy = c.addButton("Accuracy")
     .setValue(0)
     .setPosition(810,220)
     .setSize(200,60).setFont(createFont("Arial", 20))
     .setColorBackground(color(22, 122, 199))
     .setColorForeground(color(0, 141, 242));
     
  cardio.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if(theEvent.getAction() == ControlP5.ACTION_PRESSED) {
        cardioMode = true; 
        workoutsScreen = false;
        
        //initialize all the variables from cardio mode
        //graph information
        heartrateColors = new color[maxPoints];
        heartrates = new GPointsArray(maxPoints);
        plottingTimer = 0;
        seconds = 0;
        //workout
        cardioStarted = false;
        workoutTimer = 900;//start at 15 minutes(900s) and count down
        newStrikes = false;
        targetSpeed = 0.0;
        prevStats = false;
        currStats = false;
        currBPM = 0;
        currCalories = 0;
        cameraOn = false;
        veryLightZone = 0;
        lightZone = 0;
        moderateZone = 0;
        hardZone = 0;
        maxZone = 0;
      }
    }
  });
  speed.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if(theEvent.getAction() == ControlP5.ACTION_PRESSED) {speedMode = true; workoutsScreen = false;}
    }
  });
  accuracy.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if(theEvent.getAction() == ControlP5.ACTION_PRESSED) {accuracyMode = true; workoutsScreen = false;}
    }
  });
     
}

void drawWorkoutsScreen() {
  
  //title
  textSize(50);
  fill(0);
  text("Choose the workout mode", 300, 80);
  
  //draw rectangles for each mode
  stroke(0);
  fill(255);
  rect(20, 140, 340, 500);
  rect(380, 140, 340, 500);
  rect(740, 140, 340, 500);
  
  //draw the images
  image(cardio_button_image, 45, 320, 280,300);
  image(speed_button_image, 410, 320, 280,300);
  image(accuracy_button_image, 770, 320, 280,300);
  
  //draw the buttons
  workoutsScreenController.draw();
}
