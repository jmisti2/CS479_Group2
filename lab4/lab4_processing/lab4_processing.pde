import java.util.ArrayList; 
import processing.serial.*;


public class Food {
  int x;
  int y;
  
  public Food(int x, int y) {
    this.x = x;
    this.y = y;
  }
  public void setX(int x) {
    this.x = x;
  }
  public void setY(int y) {
    this.y = y;
  }
  public void mult(int scale) {
    this.x *= scale;
    this.y *= scale;
  }
  
}
public class Snake {
  int x = boardX;
  int y = boardY;
  int xspeed = 1;
  int yspeed = 0;
  int squareSize = 20;
  int scale = 20;
  int total = 1;
  boolean gameLost = false;
  //List of integer lists(actually tuples of x,y coordinates)
  //Stores the coordinates of each square in the snake's body
  ArrayList<ArrayList<Integer>> tail; 
  
  public Snake() {
    this.total = 1;
    this.tail = new ArrayList<ArrayList<Integer>>();
    ArrayList<Integer> startSnake = new ArrayList<Integer>();
    startSnake.add(this.x);//index 0 = x
    startSnake.add(this.y);//index 1 = y
    this.tail.add(startSnake);
  }
  
  public void selfCollision() {
    for(int i = 0; i < this.tail.size(); i++) {
      ArrayList<Integer> pos = this.tail.get(i);
      float dist = dist(this.x, this.y, pos.get(0), pos.get(1));
      if(dist < 2 && this.total != 1) {
        this.total = 1;
        this.tail = new ArrayList<ArrayList<Integer>>();
        ArrayList<Integer> startSnake = new ArrayList<Integer>();
        startSnake.add(boardX);//index 0 = x
        startSnake.add(boardY);//index 1 = y
        this.tail.add(startSnake);
        this.gameLost = true;
        
        println("collision");
      }
    }
  }
  public void update() {
    //println("total : " + this.total + " tail size : " + this.tail.size());
    //If the snake hasn't eaten food, just shift it forward
    if(this.total == this.tail.size()) {
      for(int i = 0; i < this.tail.size() - 1; i++) {
        this.tail.set(i, this.tail.get(i+1));
      }
      ArrayList<Integer> head = new ArrayList<Integer>();
      head.add(this.x);
      head.add(this.y);
      this.tail.set(this.total - 1, head);
      //println("yessS");
    } else {
      ArrayList<Integer> head = new ArrayList<Integer>();
      head.add(this.x);
      head.add(this.y);
      this.tail.add(head);
    }
    
    this.x += this.xspeed * this.scale;
    this.y += this.yspeed * this.scale;
    
    this.x = constrain(this.x, boardX, boardX + boardWidth - this.squareSize);
    this.y = constrain(this.y, boardY, boardY + boardHeight - this.squareSize);

  }
  
  public void show() {
    fill(73, 122, 44);
    stroke(104, 176, 62);
    for(int i = 0; i < this.tail.size(); i++) {
      rect(this.tail.get(i).get(0), this.tail.get(i).get(1), this.squareSize, this.squareSize);
    }
  }
  
  public void dir(int x, int y) {
    this.xspeed = x;
    this.yspeed = y;
  }
  
  public boolean eat(Food f) {
    float dist = dist(this.x, this.y, f.x, f.y);
    //If the snake ate food, increase the total
    if(dist < 1) {
      this.total++;
      //this.tail.add(new ArrayList<Integer>());
      return true;
    } else {
      return false;
    }
  }
  
}

//Images <arrow_orientation_brightness> i.e a_l_d = arrow_left_dark, a_u_l = arrow_up_light
PImage a_u_l;
PImage a_d_l;
PImage a_l_l;
PImage a_r_l;
PImage a_u_d;
PImage a_d_d;
PImage a_l_d;
PImage a_r_d;
PImage bg;

Snake snake;
Food food;
Serial myPort;
String val;
PFont mainFont;
PFont titleFont;

int boardWidth = 600;
int boardHeight = 500;
int boardX = 100;
int boardY = 250;

boolean introScreen = true;
boolean blink = false;
boolean pause = false;
int prevTime;

//flags to keep track of direction before pause
boolean left = false;
boolean right = false;
boolean up = false;
boolean down = false;
int pausecount = 0; // to keep track of pause and unpause

void setup() {
  frameRate(10);
  size(800,800);
  background(255);
  fill(0);
  rect(boardX, boardY, boardWidth, boardHeight);
  snake = new Snake();
  pickFoodLocation();
  mainFont = loadFont("Ravie-48.vlw");
  titleFont = loadFont("Jokerman-Regular-48.vlw");
  prevTime = millis();
  
  
  //load the images
  a_u_l = loadImage("arrow_imgs/a_u_l.png");
  a_d_l = loadImage("arrow_imgs/a_d_l.png");
  a_l_l = loadImage("arrow_imgs/a_l_l.png");
  a_r_l = loadImage("arrow_imgs/a_r_l.png");
  a_u_d = loadImage("arrow_imgs/a_u_d.png");
  a_d_d = loadImage("arrow_imgs/a_d_d.png");
  a_l_d = loadImage("arrow_imgs/a_l_d.png");
  a_r_d = loadImage("arrow_imgs/a_r_d.png");
  bg = loadImage("background/background_dark.jpg");//source: https://wallpapers-hd-wide.com/1245-green-leaves-texture-background_wallpaper.html
  
  //connect to the port
  //String portName = Serial.list()[3];
  //myPort = new Serial(this, portName, 115200);
}


void draw() {
  if(introScreen){
    background(0);
    textSize(100);
    fill(255,0,100);
    text("Snake", width/2-120, height/2-100);
    fill(255);
    rect(width/2-70, height/2-50,160,80,10);
    textSize(50);
    fill(0);
    strokeWeight(5);
    
    //blinking button
    if(millis() > prevTime + 500){
      if(blink){
        stroke(104, 176, 62);
        blink = false;
      }
      else{
        stroke(0);
        blink = true;
      }
      
      prevTime = millis();
    }
    
    text("Start", width/2-42, height/2+5);
    
  }else {
    background(0);
    image(bg, 0, 0, width, height);
    
    //get input from the board
    //if(myPort.available() > 0){
    //    val = myPort.readStringUntil('\n');
    //    if(val != null){
    //      println(val);
    //      val = val.trim();
    //      if(val.equals("5")) {
    //        snake.dir(-1, 0);
    //        println("sensor pressed : 5");
    //      } else if(val.equals("3")) {
    //        snake.dir(0, 1);
    //        println("sensor pressed : 3");
    //      } else if(val.equals("7")) {
    //        snake.dir(1, 0);
    //        println("sensor pressed : 7");
    //      } else if(val.equals("1")) {
    //        snake.dir(0, -1);
    //        println("sensor pressed : 1");
    //      }
    //    }
    //  }
    
    
    //draw the title
    noStroke();
    fill(112, 209, 15);
    textFont(titleFont, 50);
    text("SNAKE", 320, 50);
    
    //draw the board
    fill(6, 15, 0);
    rect(boardX, boardY, boardWidth, boardHeight);
    
    //Draw board frame
    fill(86, 89, 83);
    //left side
    rect(boardX - 25, boardY, 25, boardHeight);
    //right side
    rect(boardX + boardWidth, boardY, 25, boardHeight);
    //top side
    rect(boardX - 25, boardY - 25, 50 + boardWidth, 25);
    //bottom side
    rect(boardX - 25, boardY + boardHeight, 50 + boardWidth, 25);
    
    //draw the score
    fill(112, 209, 15);
    textFont(mainFont, 30);
    text("Score: " + snake.total, boardX - 25, boardY - 40);
    
    //draw the arrows
    //up arrow
    image(a_u_d, 268, 70, 300,300);
    //down arrow
    image(a_d_d, 272, 100, 300, 300);
    //left arrow
    image(a_l_d, 234, 8, 300, 300);
    //right arrow
    image(a_r_d, 311, -43, 300, 300);
    
    //Draw the snake
    //the game is ongoing
    if(!snake.gameLost) {
      snake.selfCollision();
      snake.update();
      snake.show();
      //draw the food
      // If the food is eaten, chenge the location
      fill(204, 0, 0);
      stroke(255, 77, 77);
      if(snake.eat(food)) {
        pickFoodLocation();
      } 
      rect(food.x, food.y, snake.scale, snake.scale);
    } 
    //the user lost
    else {
      //Show the game lost screen
      fill(13, 26, 2);
      stroke(67, 115, 20);
      rect(200, 200, 400, 300, 20);
      fill(112, 209, 15);
      textFont(mainFont, 30);
      text("GAME OVER!", 270, 280);
      textSize(20);
      fill(96, 166, 36);
      text("Press Pause button to restart", 220, 370); //press q 
      text("the game", 320, 400);
    }
  }

}


void pickFoodLocation() {
  int cols = floor(boardWidth / snake.scale);
  int rows = floor(boardHeight / snake.scale);
  food = new Food(floor(random(cols)), floor(random(rows)));
  food.mult(snake.scale);
  food.setX(food.x + boardX);//ensures food.x starts inside the board
  food.setY(food.y + boardY);//ensures food.y starts innside the board
}



void keyPressed() {
  if(key == 'a') {
    if(pause == false){
      image(a_l_l, 180, -40, 300, 300);
      snake.dir(-1, 0);
      up = false;
      down = false;
      left = true;
      right = false;
    }
  } else if(key == 's') {
    if(pause == false){
      image(a_d_l, 220, 100, 300, 300);
      snake.dir(0, 1);
      up = false;
      down = true;
      left = false;
      right = false;
    }
  } else if(key == 'd') {
    if(pause ==false){
      image(a_r_l, 260, 8, 300, 300);
      snake.dir(1, 0);
      up = false;
      down = false;
      left = false;
      right = true;
    }
  } else if(key == 'w') {
    if(pause == false){
      image(a_u_l, 220, 70, 300,300);
      snake.dir(0, -1);
      up = true;
      down = false;
      left = false;
      right = false;
    }
  }
  else if(key == 'q') {
    //restarts the game
    if(key == 'q' && snake.gameLost){
      snake.gameLost = false;
    } else {
      introScreen = false;
      pausecount++;
      if(pausecount > 1){ // past intro screen
        if (pausecount%2 == 0){
          pause = true;
          snake.dir(0,0);
         }else {
           
           pause = false;
           if(up == true){
             snake.dir(0,-1);
           }else if(down == true){
             snake.dir(0,1);
           }else if(left == true){
             snake.dir(-1,0);
           }else if(right == true){
             snake.dir(1,0);
           }
         }
      }
    }
  }
}