void setInterface()
{
  PFont font = createFont("arial", 20);
  cp5 = new ControlP5(this);
  myTextarea = cp5.addTextarea("txt")
    .setPosition(430, 40)
      .setSize(350, 460)
        .setFont(createFont("arial", 16))
          .setLineHeight(14)
            .setColor(color(128))
              .setColorBackground(color(255, 100))
                .setColorForeground(color(255, 100));

  Escribo=cp5.addTextfield("input")
    .setPosition(20, 540)
      .setSize(760, 60)
        .setFont(font)
          .setFocus(true)
            .setColor(color(255, 0, 0));

  ListaUSB = cp5.addListBox("usb")
    .setPosition(600, 35)
      .setSize(180, 40)
        .setItemHeight(20)
          .setBarHeight(30)
            .setColorBackground(color(120, 100, 20))
              .setColorActive(color(220, 200, 20));
  ListaUSB.captionLabel().toUpperCase(true);
  ListaUSB.captionLabel().set("COM");
  ListaUSB.captionLabel().setColor(color(0));
  ListaUSB.captionLabel().style().marginTop = 3;
  ListaUSB.valueLabel().style().marginTop = 0;
  ListaUSB.actAsPulldownMenu(true);

  String[] USBdisponible = myPort.list();

  for (int i=0; i<USBdisponible.length;i++)
  {
    ListBoxItem lbi=ListaUSB.addItem(USBdisponible[i], i);
    lbi.setColorBackground(color(100));
  }
  
  cp5.addButton("Start",0,20,40,120,60);
  cp5.addButton("Stop",1,20,110,120,60);
  cp5.addButton("Forward",2,150,40,120,60);
  cp5.addButton("Backward",3,150,110,120,60);
  cp5.addButton("Break",4,280,40,120,60);
  cp5.addButton("Analog",5,280,110,120,60);
  CurrentSlider = cp5.addSlider("Current (mA)",0,1023,100,40,300,300,50);
  SharpSlider = cp5.addSlider("Sharp (cm)",10,80,20,40,200,300,50);
}


public void Start(int theValue) {
  myPort.write("sta"+'\n');
}
public void Stop(int theValue) {
  myPort.write("sto"+'\n');
}
public void Forward(int theValue) {
  myPort.write("ade"+'\n');
}
public void Backward(int theValue) {
  myPort.write("atr"+'\n');
}
public void Break(int theValue) {
  myPort.write("bre"+'\n');
}
public void Analog(int theValue) {
  myPort.write("ana"+'\n');
}
