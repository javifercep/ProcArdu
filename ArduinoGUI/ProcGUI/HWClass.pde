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
      return DigitalState.get(pin);
  }

  public void setDigitalState(int pin, int value)
  {
    DigitalState.set(pin, value);
  }

  public int getDigitalValue(int pin)
  {
      return DigitalValue.get(pin);
  }

  public void setDigitalValue(int pin, int value)
  {
    DigitalValue.set(pin, value);
  }

  public int getAnalogValue(int pin)
  {
      return AnalogValue.get(pin);
  }

  public void setAnalogValue(int pin, int value)
  {
    AnalogValue.set(pin, value);
  }
}

