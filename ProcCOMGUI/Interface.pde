void setInterface()
{
  PFont font = createFont("arial", 20);
  cp5 = new ControlP5(this);
  myTextarea = cp5.addTextarea("txt")
    .setPosition(20, 40)
      .setSize(760, 460)
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
}
