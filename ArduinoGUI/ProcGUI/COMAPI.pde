
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

    String[] process = split(data, ':');
    char command = process[0].charAt(0);
    int pin   = Integer.parseInt(process[1]);
    int value = Integer.parseInt(process[2]);
    switch(command)
    {
    case DIGITAL_READ:
      if (pin >= 0 && pin < DIGITALPINSARDUINOUNO)
        Hard.setDigitalValue(pin, value);  
      temp = true;   
      break;
    case ANALOG_READ:
      if (pin >= 0 && pin < ANALOGPINSARDUINOUNO)
      {
        Hard.setAnalogValue(pin, value);
      }
      temp = true; 
      break;
    case DIGITAL_BROADCAST:
      for (int ii=0; ii< pin; ii++)
      {
        Hard.setDigitalValue(ii, Integer.parseInt(process[ii+2]));
      }
      temp = true; 
      break;
    case ANALOG_BROADCAST:
      for (int ii=0; ii< pin; ii++)
      {
        Hard.setAnalogValue(ii, Integer.parseInt(process[ii+2]));
      }
      temp = true; 
      break;
    case ERROR:
      errorInformation = process[3];
      newinfo = true;
      temp = true; 
      break;
    default:
      break;
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
      if (Hard.getDigitalState(ii) != NOT_CONF)
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

