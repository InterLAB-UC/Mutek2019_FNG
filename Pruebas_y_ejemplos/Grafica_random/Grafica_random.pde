int xPos = 1;
int inc = 2;

float x1 = 0;
float x2;
float y1;
float y2 = height / 2;

void setup () {
  // set the window size:
  size(800, 600);       
  background(0);
}
void draw () {
  float dato = random(0, 500);

  fill(0);
  rect(0, 0, 100, 100);
  fill(204, 102, 0);
  textSize(15);
  text(str(dato), 10, 70);
  dato = map(dato, 0, 500, 200, height/2);

  // draw the line:
  stroke(255, 255, 0);
  strokeWeight(2);
  line(xPos - inc , y1, xPos, y2);

  y1 = y2;
  y2 = height - dato;

  // at the edge of the screen, go back to the beginning:
  if (xPos >= width) {
    xPos = 0;
    background(0);
  } else {
    // increment the horizontal position:
    xPos= xPos + inc;
  }
}
