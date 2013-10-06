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
  if (stringComplete) {
    //Serial.println(inputString); 
    // clear the string:
    if(inputString.equals("ade"))
    {
      Serial.print("iMotor hacia adelante:");
      digitalWrite(MOTORDIRA, HIGH);
      analogControl = false;
    }
    else if (inputString.equals("atr"))
    {
      Serial.print("iMotor hacia atrás:");
      digitalWrite(MOTORDIRA, LOW);
      analogControl = false;
    }
    else if(inputString.equals("bre"))
    {
      if(digitalRead(BREAKA)== HIGH)
        Serial.print("iMotor frenado:");
      else
        Serial.print("iMotor NO frenado:");
      digitalWrite(BREAKA, digitalRead(BREAKA)^1);
      analogControl = false;
    }
    else if(inputString.equals("sto"))
    {
      Serial.print("iMotor parado:");
      analogWrite(MOTORVELA, 0);
      analogControl = false;
    }
    else if (inputString.equals("sta"))
    {
      Serial.print("iMotor encendido:");
      analogWrite(MOTORVELA, 255);
      analogControl = false;
    }
    else if (inputString.equals("ana"))
    {
      Serial.print("iMotor controlado por sensor:");
      analogControl = true;
    }

    inputString = "";
    stringComplete = false;
  }
  if(analogControl)
  {
    analogWrite(MOTORVELA, map(analogRead(SHARP),0, 1023, 0, 255));
  }

  Serial.print("s");
  Serial.print(analogRead(SHARP));
  Serial.print(":");
  int miliVolt = map(analogRead(CURRENTSENSA), 0, 1023, 0, 3300);
  int current = miliVolt/1.65;

  Serial.print("c");
  Serial.print(current);
  Serial.println(":");
  delay(100);

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


