#include "ProcArduLib.h"

ProcArduLib ArduInterface;

void setup()
{
  Serial.begin(9600);
}

void loop()
{
  ArduInterface.ProcessData();
}

void serialEvent()
{
  while (Serial.available()) 
  {
    // get the new byte:
    if(ArduInterface.GetSerialData((char)Serial.read()))
      break;
  }
}










