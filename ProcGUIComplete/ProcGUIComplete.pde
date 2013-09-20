import processing.serial.*;

import controlP5.*;

Serial myPort;
String dataReceived;
COMAPI COM = new COMAPI();

ControlP5 cp5;
Textarea myTextarea;
Textfield Escribo;
ListBox ListaUSB;
Slider  SharpSlider, CurrentSlider;
//Button StartButton, StopButton, ForwardButton, BackwardButton, AnalogButton, BreakButton;
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
}

public void controlEvent(ControlEvent theEvent) {

  if (theEvent.isGroup())
  {
    if (theEvent.name().equals("usb"))
    {
      int valorCOM=(int)theEvent.group().value();
      String[][] Puerto=ListaUSB.getListBoxItems();
      if (conected)
      {
        println("Desconectando...");
        myPort.clear();
        myPort.stop();
      }
      println("Conectando al puerto "+Puerto[valorCOM][0]);
      myPort = new Serial(this, Puerto[valorCOM][0], 9600);
      myPort.bufferUntil('\n');
      println("CONECTADO");
      conected=true;
    }
  }
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
  myTextarea.setText(myTextarea.getText()+"User: "+ theText + '\n');
}

void keyPressed() {
  if (key==' ')
  {
    if (myPort != null)
      myPort.stop();
    exit();  // Stops the program
  }
}

