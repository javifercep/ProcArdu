/**
  ******************************************************************************
  * @file    ProcArduLib.c
  * @author  Javier Fernandez Cepeda
  * @version V0.0.1
  ******************************************************************************
*/

/* Includes ------------------------------------------------------------------*/
#include <Arduino.h>
#include "ProcArduLib.h"

/* Private typedef -----------------------------------------------------------*/

/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
const long Analog[NUMANPINS] = {A0,A1,A2,A3,A4,A5};
static String inputString;
static boolean stringComplete;
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/

/*Constructors*/
ProcArduLib::ProcArduLib()
{
	inputString = "";
	stringComplete = false;
}

ProcArduLib::~ProcArduLib()
{
	Serial.end();
}

/**
  * @brief  This function get data frames from Serial.
  * @param  None
  * @retval None
  */
bool ProcArduLib::GetSerialData(char data)
{	
	bool ret = false;
    inputString += data; 
    // if the incoming character is a newline, set a flag
    // so the main loop can do something about it:
    if (data == '\n')
	{	
      stringComplete = true; 
	  ret=true;	  
	}
 return ret;	
}

/**
  * @brief  This function process data and execute instructions:
  * @param  None
  * @retval None
  */
void ProcArduLib::ProcessData()
{
	if (stringComplete) {
    char command = inputString.charAt(0);
    switch(command)
    {
    case 'd':
      pin = inputString.substring(1).toInt();
      value = inputString.substring(inputString.indexOf('v')+1).toInt();
#ifdef DEBUG
      Serial.println(inputString.substring(inputString.indexOf('v')));
      Serial.println(pin);
      Serial.println(value);
#endif
      if(pin < 0 || pin > 13)
      {
        Serial.println("E:Invalid pin!:");
        break;
      }
      if(value > 1 || value < 0)
      {
        Serial.println("E:Invalid value!:");
        break;
      } 
      digitalWrite(pin, value);
      break;
    case 'a':
      pin = inputString.substring(1).toInt();
      value = inputString.substring(inputString.indexOf('v')+1).toInt();
      if(pin < 0 || pin > 5)
      {
        Serial.println("E:Invalid pin!:");
        break;
      }
      if(value > 1 || value < 0)
      {
        Serial.println("E:Invalid value!:");
        break;
      }
      Serial.print("A:");
	  Serial.print(pin);
	  Serial.print(":");
      Serial.print(analogRead(Analog[pin]));
	  Serial.println(":");
      break;
    case 'p':
      break;
    case 'r':
      pin = inputString.substring(1).toInt();
      value = inputString.substring(inputString.indexOf('v')+1).toInt();
      if(pin == 0 || pin > 13)
      {
        Serial.println("E:Invalid pin!:");
        break;
      }
      if(value > 1 || value < 0)
      {
        Serial.println("E:Invalid value!:");
        break;
      }
      Serial.print("R:");
	  Serial.print(pin);
	  Serial.print(":");
      Serial.print(digitalRead(pin));
	  Serial.println(":");
      break;
    case 'c':
      pin = inputString.substring(1).toInt();
      value = inputString.substring(inputString.indexOf('v')+1).toInt();
      if(pin < 0 || pin > 13)
      {
        Serial.println("E:Invalid pin!");
        break;
      }
      if(value > 1 || value < 0)
      {
        Serial.println("E:Invalid value!:");
        break;
      } 
      pinMode(pin,value);
      break;
    default:
      Serial.println("E:Invalid command!:");
      break;
    }

    inputString = "";
    stringComplete = false;
  }
  for(int ii = 0; ii < 6; ii++)
  {
	Serial.print("A:");
	Serial.print(pin);
	Serial.print(":");
    Serial.print(analogRead(Analog[pin]));
	Serial.println(":");
  }
  delay(100);
}
