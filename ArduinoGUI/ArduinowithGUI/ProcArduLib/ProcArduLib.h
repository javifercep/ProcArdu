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
#define SERIALBAUDRATE	9600
/* Exported types ------------------------------------------------------------*/
/* Exported constants --------------------------------------------------------*/
/* Exported macro ------------------------------------------------------------*/
/* Exported functions ------------------------------------------------------- */
class ProcArduLib {
private:
	long pin;
	long value;
public:
	ProcArduLib();
	~ProcArduLib();
	bool GetSerialData(char data);
	void ProcessData();
};

//#ifdef __cplusplus
//}
//#endif

#endif /* __PROCARDULIB_H */
	
	
