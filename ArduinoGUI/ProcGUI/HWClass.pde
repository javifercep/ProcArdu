public class HWClass {
  private IntList DigitalState;
  private IntList DigitalValue;
  private IntList AnalogValue;

  public HWClass (int numDigPins, int numAnalogPins)
  {
    DigitalState   = new IntList(numDigPins);
    DigitalValue   = new IntList(numDigPins);
    AnalogValue    = new IntList(numAnalogPins);
  }

  public int getDigitalState(int pin)
  {
    if (DigitalState.maxIndex() > pin && DigitalState.minIndex() <= pin)
      return DigitalState.get(pin);
    else
      return 5;
  }

  public void setDigitalState(int pin, int value)
  {
    DigitalState.set(pin, value);
  }

  public int getDigitalValue(int pin)
  {
    if (DigitalValue.maxIndex() > pin && DigitalValue.minIndex() <= pin)
      return DigitalValue.get(pin);
    else 
      return 0;
  }

  public void setDigitalValue(int pin, int value)
  {
    DigitalValue.set(pin, value);
  }

  public int getAnalogValue(int pin)
  {
    if (AnalogValue.maxIndex() > pin && AnalogValue.minIndex() <= pin)
      return AnalogValue.get(pin);
    else 
      return 0;
  }

  public void setAnalogValue(int pin, int value)
  {
    AnalogValue.set(pin, value);
  }
}

