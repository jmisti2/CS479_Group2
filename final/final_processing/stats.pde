import processing.serial.*;
import grafica.*;
import controlP5.*;
import java.util.*;

//ControlP5 cp5;
ControlP5 cp5; //for stats input scene


String nameInput;
String ageInput;
String weightInput;
String heightInput;
float h;
int age;
String s = null;
String sexInput;
PImage bg;
Boolean inputAdded = false;

void checkInput(){
  if(!inputAdded){
    if(userTable.getRowCount() == 0){
      statsMode = true;
      inputAdded = true;
      workoutsScreen = false;
      cardioMode = false;
      speedMode = false;
      accuracyMode = false;
    } else{
      statsMode = false;
      workoutsScreen = true;
    }
  }  
}

void initializeStatsController(ControlP5 cp5){
  cp5.setAutoDraw(false);
  PFont font = createFont("arial",40);
  
  //cp5 = new ControlP5(this);
  
  Textfield n = cp5.addTextfield("Name")
     .setPosition(230,150)
     .setSize(200,50)
     .setFont(createFont("arial",30))
     .setAutoClear(false)
     ;
  Label label = n.getCaptionLabel(); 
  label.setFont(font);
  label.toUpperCase(false);
  label.setText("Name: "); 
  label.align(ControlP5.LEFT_OUTSIDE, CENTER);
  label.getStyle().setPaddingLeft(-10);
  
  Textfield a =cp5.addTextfield("Age")
     .setPosition(200,250)
     .setSize(200,50)
     .setFont(createFont("arial",30))
     .setAutoClear(false)
     ;
     
  Label label2 = a.getCaptionLabel(); 
  label2.setFont(font);
  label2.toUpperCase(false);
  label2.setText("Age: "); 
  label2.align(ControlP5.LEFT_OUTSIDE, CENTER);
  label2.getStyle().setPaddingLeft(-10);
  
  Textfield w =cp5.addTextfield("Weight")
     .setPosition(250,350)
     .setSize(200,50)
     .setFont(createFont("arial",30))
     .setAutoClear(false)
     ;
     
  Label label3 = w.getCaptionLabel(); 
  label3.setFont(font);
  label3.toUpperCase(false);
  label3.setText("Weight: "); 
  label3.align(ControlP5.LEFT_OUTSIDE, CENTER);
  label3.getStyle().setPaddingLeft(-10);
  
  Textfield h =cp5.addTextfield("Height")
     .setPosition(250,450)
     .setSize(200,50)
     .setFont(createFont("arial",30))
     .setAutoClear(false)
     ;
  Label label4 = h.getCaptionLabel(); 
  label4.setFont(font);
  label4.toUpperCase(false);
  label4.setText("Height: "); 
  label4.align(ControlP5.LEFT_OUTSIDE, CENTER);
  label4.getStyle().setPaddingLeft(-10);
       
  
  List l = Arrays.asList("Female", "Male");
  cp5.addScrollableList("Select Sex")
     .setPosition(250, 550)
     .setSize(200, 500)
     .setBarHeight(50)
     .setItemHeight(50)
     .addItems(l)
     //.setType(ScrollableList.DROPDOWN) // currently supported DROPDOWN and LIST
     ;
   cp5.addBang("Continue")
     .setPosition(500, 550)
     .setSize(80,40)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;  
     
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    //println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
  } 
  else if (theEvent.isController()) {
    println(theEvent.getController().getValue());
    if(theEvent.getController().getValue() == 1.0){
      s = "m";
      println("s:" + s);
    } else if (theEvent.getController().getValue() == 0.0) {
      s = "f";
      println("s:" + s);
    }
  }
}



void drawStatsInput() {
  
  //bg = loadImage("boxing.jpg");
  background(bg);
  //background(0);
  fill(250);
  textSize(70);
  text("Enter Stats", 200, 75);
  textSize(40);
  text("Sex: ", 100, 587);
    
  nameInput = cp5.get(Textfield.class,"Name").getText();
  ageInput = cp5.get(Textfield.class,"Age").getText();
  weightInput = cp5.get(Textfield.class,"Weight").getText();
  heightInput = cp5.get(Textfield.class,"Height").getText();
  
  cp5.draw();
}

void dropdown(int index) {
  println(cp5.get(ScrollableList.class, "Select Sex").getItem(index));
}

public void Continue() {
  //save stats to csv file
  if(userTable.getRowCount() == 0){
    TableRow userStats = userTable.addRow();
    //Age, Sex, Weight, Height
    
    userStats.setString("Age", ageInput);
    userStats.setString("Sex", s);
    userStats.setString("Weight", weightInput);
    userStats.setString("Height", heightInput);
    saveTable(userTable, "tables/userTable.csv");
  }
  
  
  //continue to next screen
  workoutsScreen = true;
  statsMode = false;
}
