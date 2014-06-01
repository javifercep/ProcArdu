//#define DEBUG 1

String inputString = "";         // a string to hold incoming data
boolean stringComplete = false;  // whether the string is complete
long pin;
long value;
const long Analog[6] = {A0,A1,A2,A3,A4,A5};

void setup()
{
  Serial.begin(9600);
}

void loop()
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
        Serial.println("E:Invalid pin!");
        break;
      }
      if(value > 1 || value < 0)
      {
        Serial.println("E:Invalid value!");
        break;
      } 
      digitalWrite(pin, value);
      break;
    case 'a':
      pin = inputString.substring(1).toInt();
      value = inputString.substring(inputString.indexOf('v')+1).toInt();
      if(pin < 0 || pin > 5)
      {
        Serial.println("E:Invalid pin!");
        break;
      }
      if(value > 1 || value < 0)
      {
        Serial.println("E:Invalid value!");
        break;
      }
      Serial.print("A:");
      Serial.println(analogRead(Analog[pin]));
      break;
    case 'p':
      break;
    case 'r':
      pin = inputString.substring(1).toInt();
      value = inputString.substring(inputString.indexOf('v')+1).toInt();
      if(pin == 0 || pin > 13)
      {
        Serial.println("E:Invalid pin!");
        break;
      }
      if(value > 1 || value < 0)
      {
        Serial.println("E:Invalid value!");
        break;
      }
      Serial.print("R:");
      Serial.println(digitalRead(pin));
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
        Serial.println("E:Invalid value!");
        break;
      } 
      pinMode(pin,value);
      break;
    default:
      Serial.println("E:Invalid command!");
      break;
    }

    inputString = "";
    stringComplete = false;
  }
}

void serialEvent()
{
  while (Serial.available()) {
    // get the new byte:
    char inChar = (char)Serial.read();
    inputString += inChar; 

    // if the incoming character is a newline, set a flag
    // so the main loop can do something about it:
    if (inChar == '\n') 
      stringComplete = true;      
  }
}









