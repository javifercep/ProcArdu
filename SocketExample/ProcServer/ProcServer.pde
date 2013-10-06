import controlP5.*;

import processing.serial.*;

import processing.net.*;

Serial myPort;
String dataReceived;
int port = 10002;
boolean myServerRunning = true;
int bgColor = 0;
int direction = 1;
int textLine = 60;
ListBox ListaUSB;
boolean conected=false;
COMAPI COM = new COMAPI();
ControlP5 cp5;
Client thisClient;
Server myServer;

void setup()
{
  size(400, 400);
  myPort = new Serial(this, myPort.list()[0], 9600);
  myServer = new Server(this, port); // Starts a myServer on port 10002
  background(0);
}

void mousePressed()
{
  // If the mouse clicked the myServer stops
  myServer.stop();
  myServerRunning = false;
}

void draw()
{

  if (myServerRunning == true)
  {
    text("server", 15, 45);
    Client thisClient = myServer.available();
    while (thisClient != null) {

      if (thisClient.available() > 0) {
        String data = thisClient.readString();
        println(data);
        fill(255);
        text("mesage from: " + thisClient.ip() + " : " + data, 15, 50);
        myPort.write(data);
      }
      if (COM.dataAvailable()>0)
      {
        COM.getDataFromBuffer();
        COM.showData(thisClient);
      }
    }
  } 
  else 
  {
    text("server", 15, 45);
    text("stopped", 15, 65);
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

