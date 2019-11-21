PImage img;

import de.looksgood.ani.*;
int x, y;
void setup() {
  size(500,500);
  // Images must be in the "data" directory to load correctly
  img = loadImage("https://processing.org/reference/images/image_0.png");
  Ani.init(this);
}

void draw() {
  background(0);
  image(img, x, y);
}

void mouseReleased() {
    // animate the variables x and y in 1.5 sec to mouse click position
    Ani.to(this, 1.5, "x", mouseX);
    Ani.to(this, 1.5, "y", mouseY);
}
