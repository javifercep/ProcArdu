
public class COMAPI {
  private StringList Buffer;
  private String errorInformation;
  private boolean newinfo;

  public COMAPI ()
  {
    Buffer  = new StringList();
    errorInformation = "";
    newinfo = false;
  }


  public boolean getDataFromBuffer() 
  {
    boolean temp=false;
    String data = Buffer.get(0);
    Buffer.remove(0);
    if (data.startsWith("R"))
    {
      String[] process = split(data, ':');
      if (Integer.parseInt(process[2]) == 0)
      {
        int pin = Integer.parseInt(process[1]);
        if (pin > 0 && pin < 14)
        {
          Hard.setDigitalValue(pin, LOW);
          newinfo = false;
        } else
        {
          errorInformation = "Invalid pin number!";
          newinfo = true;
        }
      } else
      {
        int pin = Integer.parseInt(process[1]);
        if (pin > 0 && pin < 14)
        {
          Hard.setDigitalValue(pin, HIGH);
          newinfo = false;
        } else
        {
          errorInformation = "Invalid pin number!";
          newinfo = true;
        }
      }
      temp = true;
    } else if (data.startsWith("A"))
    {
      String[] process = split(data, ':');
      int pin = Integer.parseInt(process[1]);
      if (pin > 0 && pin < 6)
      {
        Hard.setAnalogValue(pin, Integer.parseInt(process[2]));
        newinfo = false;
      } else
      {
        errorInformation = "Invalid pin number!";
        newinfo = true;
      }
      temp = true;
    } else if (data.startsWith("E"))
    {
      String[] process = split(data, ':');
      errorInformation = process[1];
      newinfo = true;
      temp = true;
    }
    return temp;
  }

  public void showData()
  {
    if ( newinfo)
    {
      ErrorArea.setText(errorInformation);
      newinfo = false;
    }
    for (int ii=0; ii < DIGITALPINSARDUINOUNO; ii++)
    {
      if (Hard.getDigitalState(ii) == OUTPUT)
      {
        if (Hard.getDigitalValue(ii) == HIGH)
          DigitalButton[ii].setOn();
        else
          DigitalButton[ii].setOff();
      }
    }

    for (int ii = 0; ii < ANALOGPINSARDUINOUNO; ii++)
    {
      AnalogSlider[ii].setValue((float)Hard.getAnalogValue(ii));
    }
  }

  public void addtoBuffer(String data)
  {
    Buffer.append(data);
  }

  public int dataAvailable()
  {
    return Buffer.size();
  }
}

