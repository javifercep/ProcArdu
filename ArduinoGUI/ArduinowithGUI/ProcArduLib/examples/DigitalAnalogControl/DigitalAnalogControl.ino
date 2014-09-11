#include <TimerOne.h>
#include "ProcArduLib.h"

ProcArduLib ArduInterface;
const int AnalogPins[NUMANPINS] = {
  A0,A1,A2,A3,A4,A5};

const int PWMPins[NUMPWM] = {
  3, 5, 6, 9, 10, 11};
volatile int PWMFREQ[NUMPWM] = {
  0, 0, 0, 0, 0, 0};
volatile int PWMDC[NUMPWM] = {
  0, 0, 0, 0, 0, 0};
volatile int PWMCount[NUMPWM] = {
  0, 0, 0, 0, 0, 0};


volatile int TimeCount = 0;

void setup()
{
  Serial.begin(9600);
  Timer1.initialize(100);
  Timer1.attachInterrupt(TimeBase, 100);
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
    case PWM_DUTYCYCLE:
      pinMode(pin,OUTPUT);
      PWMDC[pin] = value;
      break;
    case PWM_FREQ:
      pinMode(pin,OUTPUT);
      PWMFREQ[pin] = value;
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

void TimeBase()
{
  for(int ii = 0; ii < NUMPWM; ii++)
  {
    if (PWMFREQ[ii] == PWMCount[ii])
    {
      digitalWrite(PWMPins[ii],HIGH);
      PWMCount[ii] = -1;
    }
    if(PWMDC[ii] == TimeCount)
    {
      digitalWrite(PWMPins[ii],LOW);
    }
    PWMCount[ii]++;
  }
}

















