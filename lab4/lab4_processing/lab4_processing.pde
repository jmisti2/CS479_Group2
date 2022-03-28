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
  int x = 100;
  int y = 100;
  int xspeed = 1;
  int yspeed = 0;
  int squareSize = 20;
  int scale = 20;
  int total = 1;
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
      if(dist < 2) {
        this.total = 1;
        this.tail = new ArrayList<ArrayList<Integer>>();
        ArrayList<Integer> startSnake = new ArrayList<Integer>();
        startSnake.add(100);//index 0 = x
        startSnake.add(100);//index 1 = y
        this.tail.add(startSnake);
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
    
    this.x = constrain(this.x, 100, 700 - this.squareSize);
    this.y = constrain(this.y, 100, 700 - this.squareSize);

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


Snake snake;
Food food;
Serial myPort;
String val;

int boardWidth = 600;
int boardHeight = 500;
int boardX = 100;
int boardY = 100;

void setup() {
  frameRate(10);
  size(800,800);
  background(255);
  fill(0);
  rect(boardX, boardY, boardWidth, boardHeight);
  snake = new Snake();
  pickFoodLocation();
  
  //connect to the port
  String portName = Serial.list()[3];
  myPort = new Serial(this, portName, 115200);
}


void draw() {
  background(0);
  background(255);
  
  //get input from the board
  if(myPort.available() > 0){
      val = myPort.readStringUntil('\n');
      if(val != null){
        println(val);
        val = val.trim();
        if(val.equals("5")) {
          snake.dir(-1, 0);
          println("sensor pressed : 5");
        } else if(val.equals("3")) {
          snake.dir(0, 1);
          println("sensor pressed : 3");
        } else if(val.equals("7")) {
          snake.dir(1, 0);
          println("sensor pressed : 7");
        } else if(val.equals("1")) {
          snake.dir(0, -1);
          println("sensor pressed : 1");
        }
      }
    }
  
  
  
  //draw the board
  fill(0);
  rect(100, 100, 600, 600);
  //Draw the snake
  snake.selfCollision();
  snake.update();
  snake.show();
  
  //draw the food
  // If the food is eaten, chenge the location
  fill(255, 0, 100);
  if(snake.eat(food)) {
    pickFoodLocation();
  } 
  rect(food.x, food.y, snake.scale, snake.scale);
  //println("food x: " + food.x + " food y: " + food.y);  
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
    snake.dir(-1, 0);
  } else if(key == 's') {
    snake.dir(0, 1);
  } else if(key == 'd') {
    snake.dir(1, 0);
  } else if(key == 'w') {
    snake.dir(0, -1);
  }
}
