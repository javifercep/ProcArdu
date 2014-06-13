#include "ProcArduLib.h"

ProcArduLib ArduInterface;
const int AnalogPins[NUMANPINS] = {
  A0,A1,A2,A3,A4,A5};

void setup()
{
  Serial.begin(9600);
}

void loop()
{
  if(ArduInterface.ProcessData())
  {
    int pin = ArduInterface.GetPin();
    int value = ArduInterface.GetValue();
    switch(ArduInterface.GetCommand())
    {
    case DIGITAL_WRITE:
      if(pin < 0 || pin > 13)
      {
        ArduInterface.SendErrorMsg("Invalid pin!");
        break;
      }
      if(value > 1 || value < 0)
      {
        ArduInterface.SendErrorMsg("Invalid value!");
        break;
      } 
      digitalWrite(pin, value);
      break;
    case ANALOG_READ:
      if(pin < 0 || pin > 5)
      {
        ArduInterface.SendErrorMsg("Invalid pin!");
        break;
      }
      ArduInterface.SendCommand(ANALOG_READ, pin, analogRead(AnalogPins[pin]));
      break;
    case DIGITAL_READ:
      if(pin < 0 || pin > 13)
      {
        ArduInterface.SendErrorMsg("Invalid value!:");
        break;
      }
      ArduInterface.SendCommand(DIGITAL_READ, pin, digitalRead(pin));
      break;
    case CONFIG_PIN:
      if(pin < 0 || pin > 13)
      {
        ArduInterface.SendErrorMsg("Invalid pin!");
        break;
      }
      if(value > 2  || value < 0)
      {
        ArduInterface.SendErrorMsg("Invalid value!");
        break;
      } 
      pinMode(pin,value);
      break;
	case ANALOG_BROADCAST:
		ArduInterface.SendBroadcast(ANALOG_BROADCAST);
	break;
	case DIGITAL_BROADCAST:
		ArduInterface.SendBroadcast(DIGITAL_BROADCAST);
	break;
    default:
      ArduInterface.SendErrorMsg("Invalid command!");
      break;
    }
  }
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












