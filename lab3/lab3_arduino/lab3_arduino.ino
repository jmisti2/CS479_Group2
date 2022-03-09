//lab 2

long timer;
double hr = 72;
int value = 0, count = 0;  
bool flag = 0;
#define threshold 100 // to identify R peak
#define timer_value 10000 // 10 seconds timer to calculate hr

void setup() {
  Serial.begin(115200);
  pinMode(10, INPUT); // Setup for leads off detection LO +
  pinMode(11, INPUT); // Setup for leads off detection LO -
}
void loop() { 
  if((digitalRead(10) == 1)||(digitalRead(11) == 1)){
    timer = millis();
  }
  
  value = analogRead(A0);
  value = map(value, 250, 400, 0, 100); //to flatten the ecg values a bit
  if((value > threshold) && (!flag)) {
    count++;  
    flag = 1;
  }
  else if((value < threshold)) {
    flag = 0;
  }
  if ((millis() - timer) > 10000) {
    hr = count*6;
    timer = millis();
    count = 0;
  }
  Serial.print(value);
  Serial.print(",");
  Serial.print(int(hr));
  Serial.print(",");
  Serial.println(analogRead(A1));
  delay(1);
}

//void setup() {
//  Serial.begin(115200);
//  pinMode(10, INPUT); // Setup for leads off detection LO +
//  pinMode(11, INPUT); // Setup for leads off detection LO -
//}
//void loop() { 
//    Serial.println(analogRead(A0));
//    delay(1);
//}
