import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 
import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ProcGUI extends PApplet {





Serial myPort;
String dataReceived;
COMAPI COM = new COMAPI();

ControlP5 cp5;
Textarea ErrorArea;
Textfield Escribo;
ListBox ListaUSB, ListaConfig, ListaDigConf[];
Slider  AnalogSlider[];
Button DigitalButton[];
HWClass Hard;
boolean conected=false;

public void setup() { 
  size(800, 620);

  /*GUI Objects*/
  setInterface();
} 

public void draw() {
  background(0);
  if (COM.dataAvailable()>0)
  {
    COM.getDataFromBuffer();
    COM.showData();
  }
  //InterfaceUpdate();
  delay(100);
}

public void serialEvent(Serial myPort) {
    dataReceived = myPort.readStringUntil('\n');
  //println(dataReceived.length());

  if (dataReceived != null)
  {
    COM.addtoBuffer(dataReceived);
    dataReceived = null;
  }
}

public void input(String theText) {
  // automatically receives results from controller input
  myPort.write(theText+'\n');
  ErrorArea.setText(ErrorArea.getText()+"User: "+ theText + '\n');
}

public void keyPressed() {
  if (key==' ')
  {
    if (myPort != null)
      myPort.stop();
    exit();  // Stops the program
  }
}


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

static final int DIGITALPINSARDUINOUNO = 14;
static final int ANALOGPINSARDUINOUNO = 6;
static final int LOW = 0;
static final int HIGH = 1;

static final int INPUT = 0;
static final int OUTPUT = 1;
static final int INPUT_PULLUP = 2;
static final int NOT_CONF = 3;
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

int digitalIndex, analogIndex;

public void setInterface()
{
  digitalIndex = 0;
  analogIndex = 0;
  PFont font = createFont("arial", 20);
  cp5 = new ControlP5(this);
  ErrorArea = cp5.addTextarea("txt")
    .setPosition(10, 560)
      .setSize(500, 40)
        .setFont(createFont("arial", 14))
          .setLineHeight(14)
            .setColor(color(200, 20, 0))
              .setColorBackground(color(255, 100))
                .setColorForeground(color(255));

  Escribo=cp5.addTextfield("input")
    .setPosition(580, 560)
      .setSize(200, 40)
        .setFont(createFont("arial", 14))
          .setFocus(true)
            .setColor(color(0, 200, 0))
              .setColorBackground(color(250))
                .setColorForeground(color(50, 200, 10));

  ListaUSB = cp5.addListBox("usb")
    .setPosition(600, 35)
      .setSize(180, 40)
        .setItemHeight(30)
          .setBarHeight(30)
            .setHeight(60)
              .setColorBackground(color(20, 170, 50))
                .setColorActive(color(40, 200, 60))
                  .setColorForeground(color(40, 200, 60));
  ListaUSB.captionLabel().toUpperCase(true);
  ListaUSB.captionLabel().set("COM");
  ListaUSB.captionLabel().setColor(color(0));
  ListaUSB.captionLabel().style().marginTop = 3;
  ListaUSB.valueLabel().style().marginTop = 0;
  ListaUSB.actAsPulldownMenu(true);

  String[] USBdisponible = myPort.list();

  for (int i=0; i<USBdisponible.length; i++)
  {
    ListBoxItem lbi=ListaUSB.addItem(USBdisponible[i], i);
    lbi.setColorBackground(color(100));
  }

  ListaConfig = cp5.addListBox("config")
    .setPosition(20, 35)
      .setSize(180, 40)
        .setItemHeight(20)
          .setBarHeight(30)
            .setHeight(60)
              .setColorBackground(color(20, 170, 50))
                .setColorActive(color(40, 200, 60))
                  .setColorForeground(color(40, 200, 60))
                    .hide();
  ListaConfig.captionLabel().toUpperCase(true);
  ListaConfig.captionLabel().set("HW config");
  ListaConfig.captionLabel().setColor(color(0));
  ListaConfig.captionLabel().style().marginTop = 3;
  ListaConfig.valueLabel().style().marginTop = 0;
  ListaConfig.actAsPulldownMenu(true);
  ListaConfig.addItem("Arduino UNO", 0).setColorBackground(color(100));
  ListaConfig.addItem("Custom", 1).setColorBackground(color(100));
}

public void controlEvent(ControlEvent theEvent) {
  if (theEvent.isGroup())
  {
    if (theEvent.name().equals("usb"))
    {
      int valorCOM=(int)theEvent.group().value();
      String[][] Puerto=ListaUSB.getListBoxItems();
      if (conected)
      {
        println("Desconectando...");
        myPort.clear();
        myPort.stop();
      }
      println("Conectando al puerto "+Puerto[valorCOM][0]);
      myPort = new Serial(this, Puerto[valorCOM][0], 9600);
      myPort.bufferUntil('\n');
      ListaConfig.show();
      println("CONECTADO");
      conected=true;
    } else if (theEvent.name().equals("config"))
    {
      int valorConf=(int)theEvent.group().value();
      switch(valorConf)
      {
      case 0:
        DigitalButton = new Button[DIGITALPINSARDUINOUNO];
        ListaDigConf = new ListBox[DIGITALPINSARDUINOUNO];
        AnalogSlider = new Slider[ANALOGPINSARDUINOUNO];
        Hard = new HWClass(DIGITALPINSARDUINOUNO, ANALOGPINSARDUINOUNO);
        int jj = 1;
        for (int ii = 0; ii < DIGITALPINSARDUINOUNO; ii++)
        {
          DigitalButton[ii] = cp5.addButton("DigBut"+String.valueOf(ii))
            .setPosition(20 + (80*ii)%400, 120 * jj)
              .setSize(60, 40)
                .setColorBackground(color(200, 20, 50))
                  .setColorActive(color(40, 200, 60))
                    .setColorForeground(color(200, 200, 60))
                      .setSwitch(true)
                        .setId(ii);
          Hard.setDigitalValue(ii, LOW);

          ListaDigConf[ii] = cp5.addListBox("DigConf"+String.valueOf(ii))
            .setPosition(20 + (80*ii)%400, 55 + 120*jj)
              .setSize(60, 40)
                .setItemHeight(20)
                  .setHeight(60)
                    .setColorBackground(color(20, 170, 50))
                      .setColorActive(color(40, 200, 60))
                        .setColorForeground(color(40, 200, 60));
          ListaDigConf[ii].captionLabel().toUpperCase(true);
          ListaDigConf[ii].actAsPulldownMenu(true);
          ListaDigConf[ii].addItem("INPUT", 0).setColorBackground(color(100));
          ListaDigConf[ii].addItem("OUTPUT", 1).setColorBackground(color(100));
          ListaDigConf[ii].addItem("INPUT PULLUP", 2).setColorBackground(color(100));

          Hard.setDigitalState(ii, NOT_CONF);

          if (80*(ii+1)%400 == 0)
          {
            jj++;
          }
        }
        for (int ii = 0; ii < ANALOGPINSARDUINOUNO; ii++)
        {
          AnalogSlider[ii] =   cp5.addSlider("Analog"+String.valueOf(ii))
            .setPosition(500 + (50*ii), 120)
              .setSize(20, 100)
                .setColorBackground(color(200, 200, 60))
                  .setColorActive(color(40, 200, 60))
                    .setColorForeground(color(40, 200, 60))
                      .setRange(0.00f, 1023.00f)
                        .setLock(true);
          Hard.setAnalogValue(ii, 0);
        }
        break;
      case 1:
        break;
      default:
        break;
      }
    } else if (theEvent.name().startsWith("DigConf"))
    {
      String pin = theEvent.name().substring(7);
      int config=(int)theEvent.group().value();
      Hard.setDigitalState(Integer.parseInt(pin), config);
      myPort.write('c'+pin+'v'+String.valueOf(config)+'\n');
    } else if (theEvent.name().startsWith("Analog"))
    {
      //Nothing
    }
  } else
  {
    if (theEvent.getName().startsWith("DigBut"))
    {
      String pin = theEvent.getName().substring(6);
      if (DigitalButton[Integer.parseInt(pin)].isOn() == true)
      {
        Hard.setDigitalValue(Integer.parseInt(pin), HIGH);
        myPort.write('d'+pin+"v1\n");
      } else
      {
        Hard.setDigitalValue(Integer.parseInt(pin), LOW);
        myPort.write('d'+pin+"v0\n");
      }
    }
  }
}

public void InterfaceUpdate()
{
  if (Hard != null)
  {
    if (Hard.getDigitalState(digitalIndex) == INPUT)
    {
      myPort.write('r'+String.valueOf(digitalIndex)+"v0\n");
    }
    myPort.write('a'+String.valueOf(analogIndex)+"v0\n");
    digitalIndex++;
    if (digitalIndex == DIGITALPINSARDUINOUNO)
      digitalIndex = 0;
    analogIndex++;
    if (analogIndex == ANALOGPINSARDUINOUNO)
      analogIndex=0;
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ProcGUI" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
