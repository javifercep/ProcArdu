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
static String inputString;
static boolean stringComplete;
static long Analog[NUMANPINS] = {A0,A1,A2,A3,A4,A5};
static long Digital[NUMDIGPINS];
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/

/*Constructors*/
ProcArduLib::ProcArduLib()
{
	inputString = "";
	stringComplete = false;
	for(int i = 0; i < NUMDIGPINS; i++)
		Digital[i]=i;
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
bool ProcArduLib::ProcessData()
{
	bool ret = false;
	if (stringComplete) {
    command = inputString.charAt(0);
	pin = inputString.substring(1).toInt();
	value = inputString.substring(inputString.indexOf('v')+1).toInt();
	inputString = "";
    stringComplete = false;
	ret = true;
	}
	return ret;
}

int ProcArduLib::GetCommand()
{
	return command;
}

long ProcArduLib::GetPin()
{
	return pin;
}

long ProcArduLib::GetValue()
{
	return value;
}

bool ProcArduLib::SendCommand(char command, long pin, long value)
{
	bool ret = false;
	if( pin >= 0 )
	{
		Serial.print(command);
		Serial.print(":");
		Serial.print(pin);
		Serial.print(":");
		Serial.print(value);
		Serial.println(":");
		ret = true;
	}
	return ret;
}

bool ProcArduLib::SendBroadcast(char command)
{
	bool ret = false;
	switch(command)
	{
		case DIGITAL_BROADCAST:
			Serial.print(command);
			Serial.print(":");
			Serial.print(NUMDIGPINS);
			for(int i = 0; i < NUMDIGPINS; i++)
			{
				Serial.print(":");
				Serial.print(digitalRead(Digital[i]));
			}
			Serial.println(":");
			ret = true;
		break;
		case ANALOG_BROADCAST:
			Serial.print(command);
			Serial.print(":");
			Serial.print(NUMANPINS);
			for(int i = 0; i < NUMANPINS; i++)
			{
				Serial.print(":");
				Serial.print(analogRead(Analog[i]));
			}
			Serial.println(":");
			ret = true;
		break;
		default:
		break;
	}
	return ret;
}

void ProcArduLib::SendErrorMsg(const char * error)
{
	Serial.print("E:0:0:");
	Serial.println(error);
}