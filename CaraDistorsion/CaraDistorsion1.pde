//Dar clic con el mouse para ir mejorando el nivel de pixeles
import processing.video.*;

// Variables
color c;
float i = 1;
int inc = 30; 

// Variable para la captura de video
Capture video;

void setup() { 
  size(640, 480, P2D);
  // Constructor para la captura de video
  video = new Capture(this, width, height);  
  video.start();
}

void captureEvent(Capture video) {  
  video.read();
}

void draw() {  
  background(0);
  video.loadPixels();  
  //Loop for processing the image
  for (int x = 0; x < width; x+=inc) {
    for (int y = 0; y < height; y+=inc) {
      c = video.get(x, y);
      float b = brightness(c);
      b = map(b, 0, 255, 30, 5);
      smooth();
      fill(c);
      noStroke();
      pushMatrix();
      translate(i, i, i);
      ellipse(x, y, b, b+2);
      popMatrix();
      i++;
      if (i > 10) i = 0;
    }
  }
}  

void mouseReleased() {
  inc--;
  if (inc == 2)
  {
    inc =30;
  }
  println("Mouse pressed number : " + inc);
}
