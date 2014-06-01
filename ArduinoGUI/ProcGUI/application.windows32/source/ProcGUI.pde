import processing.serial.*;

import controlP5.*;

Serial myPort;
String dataReceived;
COMAPI COM = new COMAPI();

ControlP5 cp5;
Textarea ErrorArea;
Textfield Escribo;
ListBox ListaUSB, ListaConfig, ListaDigConf[];
Slider  AnalogSlider[];
Button DigitalButton[];
HWClass Hard;
boolean conected=false;

void setup() { 
  size(800, 620);

  /*GUI Objects*/
  setInterface();
} 

void draw() {
  background(0);
  if (COM.dataAvailable()>0)
  {
    COM.getDataFromBuffer();
    COM.showData();
  }
  //InterfaceUpdate();
  delay(100);
}

void serialEvent(Serial myPort) {
    dataReceived = myPort.readStringUntil('\n');
  //println(dataReceived.length());

  if (dataReceived != null)
  {
    COM.addtoBuffer(dataReceived);
    dataReceived = null;
  }
}

public void input(String theText) {
  // automatically receives results from controller input
  myPort.write(theText+'\n');
  ErrorArea.setText(ErrorArea.getText()+"User: "+ theText + '\n');
}

void keyPressed() {
  if (key==' ')
  {
    if (myPort != null)
      myPort.stop();
    exit();  // Stops the program
  }
}

