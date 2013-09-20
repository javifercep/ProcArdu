import processing.serial.*;

import controlP5.*;

Serial myPort;
String dataReceived;
boolean stringComplete =false;

void setup() { 
  size(600, 600);
  textSize(40);
  myPort = new Serial(this, myPort.list()[0], 9600);
  myPort.bufferUntil('\n');
} 

void draw() {
  if (stringComplete)
  {
    background(184, 29, 98);
    text(dataReceived, 100, 250);
    dataReceived = "";
    stringComplete = false;
  }
}


void serialEvent(Serial myPort) {
  dataReceived = myPort.readStringUntil('\n');
  //println(dataReceived.length());

  if (dataReceived != null)
  {
    stringComplete = true;
  }
}

