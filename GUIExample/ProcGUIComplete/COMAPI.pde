
public class COMAPI {
  private StringList Buffer;
  private String datainformation;
  private int sharpValue;
  private int currentValue;
  private boolean newinfo;

  public COMAPI ()
  {
    Buffer  = new StringList();
    datainformation = "";
    sharpValue = 0;
    currentValue = 0;
    newinfo = false;
  }


  public boolean getDataFromBuffer() 
  {
    boolean temp=false;
    String data = Buffer.get(0);
    Buffer.remove(0);
    if (data.startsWith("i"))
    {
      String[] process = split(data, ':');
      datainformation = process[0].substring(1);
      sharpValue = Integer.parseInt( process[1].substring(1));
      currentValue = Integer.parseInt( process[2].substring(1, process[2].length()-1));
      newinfo = true;
      temp = true;
    }
    else if (data.startsWith("s"))
    {
      String[] process2 = split(data, ':');
      sharpValue = Integer.parseInt( process2[0].substring(1));
      currentValue = Integer.parseInt( process2[1].substring(1));
      newinfo = false;
      temp = true;
    }
    
    return temp;
  }

  public void showData()
  {
    if( newinfo)
    {
      myTextarea.setText(myTextarea.getText()+ "Aduino: " +datainformation + '\n');
      newinfo = false;
    }
    SharpSlider.setValue((int)map((float)sharpValue,0.0,1023.0, 80.0, 10.0));
    CurrentSlider.setValue(currentValue);
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

