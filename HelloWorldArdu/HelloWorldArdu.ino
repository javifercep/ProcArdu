int i=0;

void setup()
{
  /*Initializes the UART at 9600 bps*/
  Serial.begin(9600);
  /*Sends first "Hello World!" message through the UART*/
  Serial.println("Hello World!");
  /*Waits for a second*/
  delay(1000);
}

void loop()
{
  /*Sends more "Hellos World!", increases and prints the variable i every second*/
  Serial.print("Hello World! Again: ");
  Serial.println(++i);
  delay(1000);
}
