/**
  ******************************************************************************
  * @file    ProcArduLib.h
  * @author  Javier Fernandez Cepeda
  * @version V0.0.1
  ******************************************************************************
*/

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __PROCARDULIB_H
#define __PROCARDULIB_H

//#ifdef __cplusplus
// extern "C" {
//#endif

/* Includes ------------------------------------------------------------------*/
#include <Arduino.h>

/* Exported define -----------------------------------------------------------*/
//#define DEBUG 		1

#define NUMANPINS		6
#define NUMDIGPINS		14
#define NUMPWM			6
#define PINBROADCAST	0xFF
#define MAXPWMFREQCOUNT 50

/* COMMANDS Defines */
#define DIGITAL_READ 		'R'
#define DIGITAL_WRITE 		'W'
#define ANALOG_READ			'A'
#define CONFIG_PIN			'C'
#define DIGITAL_BROADCAST	'D'
#define ANALOG_BROADCAST	'B'
#define PWM_DUTYCYCLE		'Y'
#define PWM_FREQ			'F'

/* Exported types ------------------------------------------------------------*/
/* Exported constants --------------------------------------------------------*/
/* Exported macro ------------------------------------------------------------*/
/* Exported functions ------------------------------------------------------- */
class ProcArduLib {
private:
	long pin;
	long value;
	char command;
public:
	ProcArduLib();
	~ProcArduLib();
	bool GetSerialData(char data);
	bool ProcessData();
	int GetCommand();
	long GetPin();
	long GetValue();
	bool SendCommand(char command, long pin, long value);
	bool SendBroadcast(char command);
	void SendErrorMsg(const char * error);
	
};

//#ifdef __cplusplus
//}
//#endif

#endif /* __PROCARDULIB_H */
	
	
