//lab 3

import processing.serial.*;
import grafica.*;

Serial myPort;
PImage img;

void setup() {
    size(1110, 600); // window size
    background(64, 64, 64);

    // List all the available serial ports
    String portName = Serial.list()[2];
    myPort = new Serial(this, portName, 115200);
    
    img = loadImage("foot.png");
}

void draw() {
    background(230,230,230);
    fill(255, 255, 255);
    image(img, 0, 100, width/4 + 100, height/2 + 100);
    
    textSize(30);
    fill(0,0,0);
    text("Foot Pressure Map", 75, 75);
    
    fill(255, 255, 255);
    textSize(25);
    
    circle(180, 180, 35);
    
    text("MF", 165, 220);
    
    circle(160, 270, 35);
    
    text("MM", 145, 310);
    
    circle(235, 240, 35);
    
    text("LF", 225, 280);
    
    circle(190, 420, 35);
    
    text("LF", 176, 460);

    
    delay(1);
}
