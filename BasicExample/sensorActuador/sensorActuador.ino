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
  analogReference(EXTERNAL);
  pinMode(MOTORDIRA, OUTPUT);
  pinMode(MOTORVELA, OUTPUT);
  pinMode(BREAKA, OUTPUT);
  Serial.begin(9600);
  
  analogWrite(MOTORVELA, 255);
}

void loop()
{
  /*Sólo uno descomentado*/
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

