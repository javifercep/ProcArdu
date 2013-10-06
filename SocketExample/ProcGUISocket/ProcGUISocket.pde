import controlP5.*;

import processing.net.*; 

SERVERAPI COM = new SERVERAPI();
Client myClient; 
String dataReceived;
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
  myClient = new Client(this, "127.0.0.1", 10002);
} 

void draw() {
  background(0);
  if (COM.dataAvailable()>0)
  {
    COM.getDataFromBuffer();
    COM.showData();
  }
}

/*public void controlEvent(ControlEvent theEvent) {

  if (theEvent.isGroup())
  {
    if (theEvent.name().equals("usb"))
    {
      int valorCOM=(int)theEvent.group().value();
      String[][] Puerto=ListaUSB.getListBoxItems();
      if (conected)
      {
        println("Desconectando...");
        myClient.clear();
        myClient.stop();
      }
      println("Conectando al puerto "+Puerto[valorCOM][0]);
      myPort = new Serial(this, Puerto[valorCOM][0], 9600);
      myPort.bufferUntil('\n');
      println("CONECTADO");
      conected=true;
    }
  }
}*/


void clientEvent(Client someClient) {
  dataReceived = myClient.readStringUntil('\n');
  //println(dataReceived.length());
  if (dataReceived != null)
  {
    COM.addtoBuffer(dataReceived);
    dataReceived = null;
  }
}

public void input(String theText) {
  // automatically receives results from controller input
  myClient.write(theText+'\n');
  myTextarea.setText(myTextarea.getText()+"User: "+ theText + '\n');
}

void keyPressed() {
  if (key==' ')
  {
    if (myClient != null)
      myClient.stop();
    exit();  // Stops the program
  }
}

