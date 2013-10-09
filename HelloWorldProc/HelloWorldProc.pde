void setup()
{
  /* Sets size window to 600x600 pixels and sets text size*/
  size(600,600);
  textSize(40);
}

void draw()
{
  /*Draws a beautiful background*/
  background(128,210,30);
  /*Draws a red "Hello World!" at the mouse position*/
  fill(255,0,0);
  text("Hello World!", mouseX,mouseY);
}
