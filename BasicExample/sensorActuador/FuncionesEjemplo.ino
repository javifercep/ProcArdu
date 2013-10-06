void EjemploSensor()
{
  digitalWrite(MOTORDIRA, digitalRead(MOTORDIRA)^1);
  Serial.print("Sensor Sharp: ");
  Serial.println(analogRead(SHARP));
  int miliVolt = map(analogRead(CURRENTSENSA), 0, 1023, 0, 3300);
  float current = (float)miliVolt/(1.65*1000);

  Serial.print("Current Sensor: ");
  Serial.print(current);
  Serial.println("A");
  delay(600);
}

void EjemploActuador()
{
  if (stringComplete) {
    //Serial.println(inputString); 
    // clear the string:
    if(inputString.equals("ade"))
    {
      digitalWrite(MOTORDIRA, HIGH);
    }
    else if (inputString.equals("atr"))
    {
      digitalWrite(MOTORDIRA, LOW);
    }
    else if(inputString.equals("bre"))
    {
      digitalWrite(BREAKA, digitalRead(BREAKA)^1);
    }
    else if(inputString.equals("sto"))
    {
      analogWrite(MOTORVELA, 0);
    }
    else if (inputString.equals("sta"))
    {
      analogWrite(MOTORVELA, 255);
    }
  
    inputString = "";
    stringComplete = false;
  }

}

void EjemploSensorActuador()
{
   if (stringComplete) {
    //Serial.println(inputString); 
    // clear the string:
    if(inputString.equals("ade"))
    {
      digitalWrite(MOTORDIRA, HIGH);
      analogControl = false;
    }
    else if (inputString.equals("atr"))
    {
      digitalWrite(MOTORDIRA, LOW);
      analogControl = false;
    }
    else if(inputString.equals("bre"))
    {
      digitalWrite(BREAKA, digitalRead(BREAKA)^1);
      analogControl = false;
    }
    else if(inputString.equals("sto"))
    {
      analogWrite(MOTORVELA, 0);
      analogControl = false;
    }
    else if (inputString.equals("sta"))
    {
      analogWrite(MOTORVELA, 255);
      analogControl = false;
    }
    else if (inputString.equals("ana"))
    {
      analogControl = true;
    }
  
    inputString = "";
    stringComplete = false;
  }
  if(analogControl)
  {
    analogWrite(MOTORVELA, map(analogRead(SHARP),0, 1023, 0, 255));
  }
  
  Serial.print("Sensor Sharp: ");
  Serial.println(analogRead(SHARP));
  int miliVolt = map(analogRead(CURRENTSENSA), 0, 1023, 0, 3300);
  float current = (float)miliVolt/(1.65*1000);

  Serial.print("Current Sensor: ");
  Serial.print(current);
  Serial.println("A");
  delay(100);

}

