
public class COMAPI {
  private StringList Buffer;
  private String data;

  public COMAPI ()
  {
    Buffer  = new StringList();
    data = "";
  }


  public void getDataFromBuffer() 
  {
      data = Buffer.get(0);
      Buffer.remove(0);
  }

  public void showData()
  {
    myTextarea.setText(myTextarea.getText()+ "Aduino: " +data + '\n');
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

