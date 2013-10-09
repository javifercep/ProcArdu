void EjemploSensor()
{
  /*@brief: Reads data from sensors and prints them*/
  
  /*Prints data from sharp sensor*/
  Serial.print("Sensor Sharp: ");
  Serial.println(analogRead(SHARP));
  
  /*Changes the motor direction to force a current peak to sense it better*/
  digitalWrite(MOTORDIRA, digitalRead(MOTORDIRA)^1);
  
  /*Converts the input data to mV and multiplies by the constant of 
   *proporcionality to transform it into Amperes.*/
  int miliVolt = map(analogRead(CURRENTSENSA), 0, 1023, 0, 3300);
  float current = (float)miliVolt/(1.65*1000);
  /*Prints the result*/
  Serial.print("Current Sensor: ");
  Serial.print(current);
  Serial.println("A");
  delay(600);
}

void EjemploActuador()
{
  /*@brief: Reads a command from PC through UART and does an action*/
  
  /*Checks if there is a complete string from UART*/
  if (stringComplete) {
    
    /*Checks de received command*/
    if(inputString.equals("ade"))
    {
      /*Moves the motor forward*/
      digitalWrite(MOTORDIRA, HIGH);
    }
    else if (inputString.equals("atr"))
    {
      /*Moves the motor backward*/
      digitalWrite(MOTORDIRA, LOW);
    }
    else if(inputString.equals("bre"))
    {
      /*Breaks or releases the break*/
      digitalWrite(BREAKA, digitalRead(BREAKA)^1);
    }
    else if(inputString.equals("sto"))
    {
      /*Breaks or releases the break*/
      analogWrite(MOTORVELA, 0);
    }
    else if (inputString.equals("sta"))
    {
      /*Sets the motor velocity*/
      analogWrite(MOTORVELA, 255);
    }
    
    // clear the string:
    inputString = "";
    stringComplete = false;
  }

}

void EjemploSensorActuador()
{

  /*brief: joins the codes above and adds a new funcionality:
   * Now you can control the velocity with the sharp sensor*/
  
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

