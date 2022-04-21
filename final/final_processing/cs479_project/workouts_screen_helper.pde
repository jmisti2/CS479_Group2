//coordinates for each button and image
int cardioX = 10;
int cardioY = 50;
int cardioW = 360;
int cardioH = height;


void initializeWorkoutsScreenController(ControlP5 c) {
  c.setAutoDraw(false);
  
  //Add one button for each workout
  Button cardio = c.addButton("Cardio")
     .setValue(0)
     .setPosition(80, 140)
     .setSize(200,40)
     .setFont(createFont("Arial", 20))
     .setColorBackground(color(43, 199, 38))
     .setColorForeground(color(0, 252, 114));
     ;
  Button speed = c.addButton("Speed")
     .setValue(0)
     .setPosition(440,140)
     .setSize(200,40)
     .setFont(createFont("Arial", 20))
     .setColorBackground(color(207, 35, 35))
     .setColorForeground(color(247, 5, 5));
     ;
  Button accuracy = c.addButton("Accuracy")
     .setValue(0)
     .setPosition(800,140)
     .setSize(200,40).setFont(createFont("Arial", 20))
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
  workoutsScreenController.draw();
}
