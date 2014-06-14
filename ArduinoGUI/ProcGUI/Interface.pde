int digitalIndex, analogIndex;
boolean AutoModeOn = false;
int SendAnalog = 0;
volatile String commandMsg = null;
int DelayTime = 100;

void setInterface()
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

  AutomaticMode = cp5.addTextarea("Auto")
    .setPosition(275, 30)
      .setSize(250, 40)
        .setFont(createFont("arial", 18))
          .setLineHeight(18)
            .setColor(color(30, 200, 20))
              .setColorBackground(0)
                .setColorForeground(0)
                  .setText("Automatic Mode Off");

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

  AutoModeButton = cp5.addButton("AutoModeButton")
    .setPosition(450, 25)
      .setSize(90, 30)
        .setColorBackground(color(30, 200, 20))
          .setColorActive(color(40, 200, 60))
            .setColorForeground(color(200, 200, 60))
              .lock();

  UpdateRate =  cp5.addSlider("Update_Rate")
    .setPosition(270, 60)
      .setSize(180, 20)
        .setColorBackground(color(40, 200, 60))
          .setColorActive(color(200, 200, 60))
            .setColorForeground(color(200, 200, 60))
              .setRange(20.00, 100.00)
                .setLock(true);
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
      AutoModeButton.unlock();
      UpdateRate.unlock();
      switch(valorConf)
      {
      case 0:
        DigitalButton = new Button[DIGITALPINSARDUINOUNO];
        ListaDigConf = new ListBox[DIGITALPINSARDUINOUNO];
        AnalogSlider = new Slider[ANALOGPINSARDUINOUNO];
        AnalogButton = new Button[ANALOGPINSARDUINOUNO];

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
                      .setRange(0.00, 1023.00)
                        .setLock(true);
          Hard.setAnalogValue(ii, 0);
          AnalogButton[ii] = cp5.addButton("An"+String.valueOf(ii))
            .setPosition(495 + (50*ii), 250)
              .setSize(30, 20)
                .setColorBackground(color(200, 150, 60))
                  .setColorActive(color(100, 100, 30))
                    .setColorForeground(color(200, 150, 60));
        }
        UpdateAllDig = cp5.addButton("Update_ALL_Digital")
          .setPosition(35, 450)
            .setSize(280, 50)
              .setColorBackground(color(150, 200, 60))
                .setColorActive(color(100, 100, 30))
                  .setColorForeground(color(150, 200, 60));

        UpdateAllAn = cp5.addButton("Update_ALL_Analog")
          .setPosition(495, 290)
            .setSize(280, 50)
              .setColorBackground(color(150, 200, 60))
                .setColorActive(color(100, 100, 30))
                  .setColorForeground(color(150, 200, 60));
        openConfig = true;
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
      commandMsg = 'C'+pin+'v'+String.valueOf(config)+'\n';
    } else if (theEvent.name().startsWith("Analog"))
    {
      //Nothing
    }
  } else if (theEvent.isController() == true)
  {
    if (theEvent.getName().startsWith("DigBut"))
    {
      String pin = theEvent.getName().substring(6);
      if (Hard.getDigitalState(Integer.parseInt(pin))==OUTPUT)
      {
        if (DigitalButton[Integer.parseInt(pin)].isOn() == true)
        {
          Hard.setDigitalValue(Integer.parseInt(pin), HIGH);
          commandMsg = 'W'+pin+"v1\n";
        } else
        {
          Hard.setDigitalValue(Integer.parseInt(pin), LOW);
          commandMsg = 'W'+pin+"v0\n";
        }
      }
    }
  }
}

void InterfaceUpdate()
{
  String commandAux = null;

  if (AutoModeOn)
  {
    switch(SendAnalog)
    {
    case 0:
      commandAux = "B255v0\n";
      SendAnalog++;
      break;
    case 1:
      commandAux = "D255v0\n";
      SendAnalog++;
      break;
    case 2:
      if (commandMsg != null)
      {
        commandAux = commandMsg;
        commandMsg = null;
      }
      SendAnalog = 0;
      break;
    default:
      break;
    }
    if (commandAux!=null)
      myPort.write(commandAux);
  } else
  {
    if (Hard != null)
    {
      if (commandMsg != null)
      {
        myPort.write(commandMsg);
        commandMsg = null;
      }
    }
  }
}

public void An0(int Value)
{
  commandMsg = "A0v0\n";
}

public void An1(int Value)
{
  commandMsg = "A1v0\n";
}

public void An2(int Value)
{
  commandMsg = "A2v0\n";
}

public void An3(int Value)
{
  commandMsg = "A3v0\n";
}

public void An4(int Value)
{
  commandMsg = "A4v0\n";
}

public void An5(int Value)
{
  commandMsg = "A5v0\n";
}

public void Update_ALL_Analog(int Value)
{
  commandMsg = "B255v0\n";
}

public void Update_ALL_Digital(int Value)
{
  commandMsg = "D255v0\n";
}

public void AutoModeButton(int Value)
{
  if (AutoModeOn)
  {
    AutoModeOn = false;
    AutomaticMode.setText("Automatic Mode Off");
    if (UpdateAllDig != null)
    {
      UpdateAllDig.show();
      UpdateAllAn.show();
      for (int ii = 0; ii < ANALOGPINSARDUINOUNO; ii++)
        AnalogButton[ii].show();
    }
  } else
  {
    AutoModeOn = true;
    AutomaticMode.setText("Automatic Mode On");
    if (UpdateAllDig != null)
    {
      UpdateAllDig.hide();
      UpdateAllAn.hide();
      for (int ii = 0; ii < ANALOGPINSARDUINOUNO; ii++)
        AnalogButton[ii].hide();
    }
  }
}

public void Update_Rate(int Value)
{
  DelayTime = Value;
}

