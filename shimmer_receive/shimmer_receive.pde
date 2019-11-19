import oscP5.*;

OscP5 oscP5;

int inc = 2;
int count = 0;
int xPos_g1 = 1;
float x1_g1 = 0;
float x2_g1;
float y1_g1;
float y2_g1 = height/8;

int xPos_g2 = 1;
float x1_g2 = 0;
float x2_g2;
float y1_g2;
float y2_g2 = height/8*3;

int xPos_g3 = 1;
float x1_g3 = 0;
float x2_g3;
float y1_g3;
float y2_g3 = height/8*5;

int xPos_g4 = 1;
float x1_g4 = 0;
float x2_g4;
float y1_g4;
float y2_g4 = height/8*7;

String[] list;
float dato_g1 = 0;
float dato_g2 = 0;
float dato_g3 = 0;
float dato_g4 = 0;

float x_shimmer = 0, y_shimmer = 0, z_shimmer = 0, pulse_shimmer = 0;

void setup() {
  //size(displayWidth, displayHeight);
  size(1920,2160);
  background(0);
  smooth();
  println(width,height);
  frameRate(25);
  oscP5 = new OscP5(this, 12002);
}


void draw () {
  // draw the line:
  textSize(30);
  stroke(255, 255, 255);
  fill(255, 255, 255);
  text("Eje x", width-100, 30);
  strokeWeight(2);
  line(xPos_g1 - inc, y1_g1, xPos_g1, y2_g1);
  text("Eje y", width-100,height/8*2);
  line(xPos_g2 - inc, y1_g2, xPos_g2, y2_g2);
  text("Eje z", width-100,height/8*4);
  line(xPos_g3 - inc, y1_g3, xPos_g3, y2_g3);
  text("Pulso", width-100,height/8*6);
  line(xPos_g4 - inc, y1_g4, xPos_g4, y2_g4);
  /*ellipse(0,height/8,5,5);
  ellipse(0,height/8*3,5,5);
  ellipse(0,height/8*5,5,5);
  ellipse(0,height/8*7,5,5);*/

  y1_g1 = y2_g1;
  y1_g2 = y2_g2;
  y1_g3 = y2_g3;
  y1_g4 = y2_g4;

  y2_g1 = height/8 - dato_g1;
  y2_g2 = height/8*3 - dato_g2;
  y2_g3 = height/8*5 - dato_g3;
  y2_g4 = height/8*7 - dato_g4;

  // at the edge of the screen, go back to the beginning:
  if (xPos_g1 >= width) {
    xPos_g1 = 0;
    background(0);
  } else {
    // increment the horizontal position:
    xPos_g1 = xPos_g1 + inc;
  }

  if (xPos_g2 >= width) {
    xPos_g2 = 0;
    background(0);
  } else {
    // increment the horizontal position:
    xPos_g2= xPos_g2 + inc;
  }

  if (xPos_g3 >= width) {
    xPos_g3 = 0;
    background(0);
  } else {
    // increment the horizontal position:
    xPos_g3= xPos_g3 + inc;
  }
  
  if (xPos_g4 >= width) {
    xPos_g4 = 0;
    background(0);
  } else {
    // increment the horizontal position:
    xPos_g4= xPos_g4 + inc;
  }
}

void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.checkAddrPattern("/x_shimmer")==true)
  {
    float value = theOscMessage.get(0).floatValue();
    dato_g1 = value;
  }
  if(theOscMessage.checkAddrPattern("/y_shimmer")==true)
  {
    float value = theOscMessage.get(0).floatValue();
    dato_g2 = value;
  }
  if(theOscMessage.checkAddrPattern("/z_shimmer")==true)
  {
    float value = theOscMessage.get(0).floatValue();
    dato_g3 = value;
  }
  if(theOscMessage.checkAddrPattern("/pulse_shimmer")==true)
  {
    float value = theOscMessage.get(0).floatValue();
    dato_g4 = value;
  }
}
