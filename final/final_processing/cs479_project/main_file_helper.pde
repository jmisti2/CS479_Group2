import processing.serial.*;

//modes
boolean workoutsScreen = true;
boolean cardioMode = false;
boolean speedMode = false;
boolean accuracyMode = false;


Serial myPort;
String val;
int acx, acy, acz, xang, yang, zang, bpm, fsr;
