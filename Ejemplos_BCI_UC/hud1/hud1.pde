import netP5.*;
import oscP5.*;

OscP5 oscp5;


public float laugh = 0;
public float smirk = 0;

int port = 7400;
void setup(){
  size(1000,1000);
  smooth(8);
  rectMode(CENTER);
  textAlign(CENTER);
  
  oscp5 = new OscP5(this,port);
}

void draw(){
  background(255);
  float x = width/2;
  float y = height/2;
  float x1,y1;
  float ang;
  float dist =250;
  float tam1,tam2,tam3,tam4,tam5,tam6,tam7,tam8;
  tam1=100 + laugh;
  tam2=100 + smirk;
  tam3=100;
  tam4=100;
  tam5=100;
  tam6=100;
  tam7=100;
  tam8=100;
  ang = TWO_PI;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  emotion(x1,y1,ang, "Laugh", tam1);
   ang = TWO_PI/7.5;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  emotion(x1,y1,ang, "Smirk",tam2);
   ang = TWO_PI/4;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  emotion(x1,y1,ang, "3",tam3);
  ang = TWO_PI/2.74;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  emotion(x1,y1,ang, "4",tam4);
  ang = TWO_PI/2;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  emotion(x1,y1,ang, "5",tam5);
  ang = -TWO_PI/2.74;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  emotion(x1,y1,ang, "6",tam6);
  
  ang = -TWO_PI/4;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  emotion(x1,y1,ang, "7",tam7);
  
  ang = -TWO_PI/7.5;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  emotion(x1,y1,ang, "8",tam8);
}



void emotion(float x, float y, float rot, String name, float tam){
  fill(0);
  rect(x,y,tam,tam);
  fill(255);
  text(name,x,y);
}


void oscEvent(OscMessage theOscMessage){
  if(theOscMessage.checkAddrPattern("/EXP/LAUGH") == true){
    laugh = theOscMessage.get(0).floatValue();
  }
  if(theOscMessage.checkAddrPattern("/EXP/SMIRK") == true){
    smirk = theOscMessage.get(0).floatValue();
  }
}
