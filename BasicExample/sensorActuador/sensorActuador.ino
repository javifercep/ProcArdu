const int CURRENTSENSA = A0;
const int MOTORDIRA = 12;
const int MOTORVELA = 3;
const int BREAKA    = 9;
const int SHARP     = A2;

String inputString = "";         // a string to hold incoming data
boolean stringComplete = false;  // whether the string is complete
boolean analogControl = false;

void setup()
{
  /*Sets the voltage reference of ADC to the external 3.3V reference
   *to improve the Sharp sensor resolution*/
  analogReference(EXTERNAL);
  
  /*Sets motor contol pins and initializes UART*/
  pinMode(MOTORDIRA, OUTPUT);
  pinMode(MOTORVELA, OUTPUT);
  pinMode(BREAKA, OUTPUT);
  Serial.begin(9600);
  
  /*Sets the motor at the maximun velocity*/
  analogWrite(MOTORVELA, 255);
}

void loop()
{
  /*Uncomment only one*/
  
  /*See FuncionesEjemplo.ino for more details*/
  //EjemploSensor();
  //EjemploActuador();
  EjemploSensorActuador();

}

void serialEvent()
{
  while (Serial.available()) {
    // get the new byte:
    char inChar = (char)Serial.read();
   
   // if the incoming character is a newline, set a flag
    // so the main loop can do something about it:
    if (inChar == '\n') 
      stringComplete = true;
   else 
    // add it to the inputString:
    inputString += inChar;   
  }
}

