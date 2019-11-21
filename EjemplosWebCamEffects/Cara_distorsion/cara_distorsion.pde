PImage bg;
color c;
float i = 1;

void setup()
{
  size(1000, 1500, P2D);
  bg = loadImage("cara.jpg");
  bg.resize(width, height);
  image(bg, 0, 0);
  background(0);
}

int count = 0;
void draw() 
{
  for (int x = 0; x < bg.width; x+=15) {
    for (int y = 0; y < bg.height; y+=15) {
      c = bg.get(x, y);
      float b = brightness(c);
      b = map(b, 0, 255, 15, 5);
      smooth();
      fill(c);
      noStroke();
      pushMatrix();
      translate(i, i);
      ellipse(x, y, b, b+2);
      popMatrix();
      i++;
      if (i > 60) i = 0;
    }
  }
}
