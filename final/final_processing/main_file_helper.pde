import processing.serial.*;

//modes
boolean workoutsScreen = false;
boolean cardioMode = false;
boolean speedMode = false;
boolean accuracyMode = false;
boolean statsMode = true;


Serial myPort;
String val;
int acx, acy, acz, xang, yang, zang, bpm, fsr;
