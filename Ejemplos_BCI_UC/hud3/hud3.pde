import netP5.*;
import oscP5.*;

OscP5 oscp5;
NetAddress superCollider;

public float frown = 0;
public float blink = 0;
public float laugh = 0;
public float wink_right = 0;
public float wink_left = 0;
public float surprise = 0;
public float smile = 0;
public float clench = 0;
public float smirk_left = 0;
public float smirk_right = 0;

int port = 7400;
void setup(){
  size(1000,1000);
  smooth(8);
  rectMode(CENTER);
  textAlign(CENTER);
  ellipseMode(CENTER);
  
  oscp5 = new OscP5(this,port);
  
  oscp5.plug(this,"updateFrown", "/EXP/FROWN");
  oscp5.plug(this,"updateBlink", "/EXP/BLINK");
  oscp5.plug(this,"updateLaugh", "/EXP/LAUGH");
  oscp5.plug(this,"updateWinkL", "/EXP/WINK_LEFT");
  oscp5.plug(this,"updateWinkR", "/EXP/WINK_RIGHT");
  oscp5.plug(this,"updateSurprise","/EXP/SURPRISE");
  oscp5.plug(this,"updateSmile","/EXP/SMILE");
  oscp5.plug(this,"updateClench","/EXP/CLENCH");
  oscp5.plug(this,"updateSmirkL","/EXP/SMIRK_LEFT");
  oscp5.plug(this,"updateSmirkR","/EXP/SMIRK_RIGHT");
  
  superCollider = new NetAddress("127.0.0.1",57120);
}

void draw(){
  background(255);
  float x = width/2;
  float y = height/2;
  float x1,y1;
  float ang;
  float dist =300;
  float tam = 200;
 
  ang = TWO_PI;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  emotion(x1,y1,ang, "Fruncir", tam,5,frown,0);
  ang = TWO_PI/7.5;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  emotion(x1,y1,ang, "Mueca Derecha",tam,4,smirk_right,1);
  ang = TWO_PI/4;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  emotion(x1,y1,ang, "Reir",tam,3,laugh,2);
  
  ang = TWO_PI/2.74;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  emotion(x1,y1,ang, "Mueca Izquierda",tam,4,smirk_left,3);
  ang = TWO_PI/2;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  emotion(x1,y1,ang, "Parpadear",tam,5,blink,4);
  ang = -TWO_PI/2.74;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  emotion(x1,y1,ang, "Guino Izquierdo",tam,4,wink_left,5);
  
  ang = -TWO_PI/4;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  emotion(x1,y1,ang, "Sonriza",tam,3,smile,6);
  
  ang = -TWO_PI/7.5;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  emotion(x1,y1,ang, "Guino Derecho",tam,4,wink_right,7);
}



void emotion(float x, float y, float rot, String name, float tam, int side, float s, int col){
  noStroke();
  fill(colors[col]);
  float size = tam + (s*100);
  ellipse(x,y,size,size);
  fill(255);
  textSize(20);
  text(name,x,y);
  
  if(s > 0.5){
    OscMessage msg = new OscMessage("/brainwave");
    msg.add(map(s,0.0,1.0,0,1));
    oscp5.send(msg,superCollider);
  }
}


public void updateFrown(float theValue) {
  frown = theValue;
  println("frown: "+frown);
}

public void updateBlink(float theValue) {
  blink = theValue;
  println("blink: "+blink);
}

public void updateLaugh(float theValue) {
  laugh = theValue;
  println("laugh: "+laugh);
}

public void updateWinkL(float theValue) {
  wink_left = theValue;
  println("laugh: "+laugh);
}

public void updateWinkR(float theValue) {
  wink_right = theValue;
}

public void updateSurprise(float theValue) {
   surprise = theValue;
}

public void updateSmile(float theValue) {
   smile = theValue;
}

public void updateClench(float theValue) {
   clench = theValue;
}

public void updateSmirkL(float theValue) {
   smirk_left = theValue;
}

public void updateSmirkR(float theValue) {
   smirk_right = theValue;
}

void keyPressed(){
  if(key == 's')saveFrame("###.jpg");  
}  

color colors[] = {
#CCFF00,#00CC66,#00CC00,#3333CC,#990099,#FF0000,#FF9900, #EF089C
};
