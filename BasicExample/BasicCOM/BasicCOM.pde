import processing.serial.*;

import controlP5.*;

Serial myPort;
String dataReceived;
boolean stringComplete =false;

/*brief: This code lets connect PC to an Arduino and 
 *draws the received data*/

void setup() { 

  /*Sets windows and text size*/
  size(600, 600);
  textSize(40);
  
  /*Connects to the Arduino. If you have problems, use this
   * function:
   *
   *  println(myPort.list());
   *
   *and check the available COM ports. Change the '[0]' by the
   *position of the desired COM in the list printed */
  myPort = new Serial(this, myPort.list()[0], 9600);
  /*There will be an event only when a '\n' character has been received*/
  myPort.bufferUntil('\n');
} 

void draw() {

  /* if there is a new data, it shows it*/
  if (stringComplete)
  {
    background(184, 29, 98);
    text(dataReceived, 100, 250);
    dataReceived = "";
    stringComplete = false;
  }
}


void serialEvent(Serial myPort) {
  /*reads data in string format*/
  dataReceived = myPort.readStringUntil('\n');
  //println(dataReceived.length());

  if (dataReceived != null)
  {
    stringComplete = true;
  }
}

