import netP5.*;
import oscP5.*;

OscP5 oscp5;


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
}

void draw(){
  background(255);
  float x = width/2;
  float y = height/2;
  float x1,y1;
  float ang;
  float dist =250;
  float tam = 100;
 
  ang = TWO_PI;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  emotion(x1,y1,ang, "Frown", tam,5,frown);
  ang = TWO_PI/7.5;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  emotion(x1,y1,ang, "Smirk_right",tam,4,smirk_right);
  ang = TWO_PI/4;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  emotion(x1,y1,ang, "laugh",tam,3,laugh);
  
  ang = TWO_PI/2.74;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  emotion(x1,y1,ang, "Smirk_left",tam,4,smirk_left);
  ang = TWO_PI/2;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  emotion(x1,y1,ang, "blink",tam,5,blink);
  ang = -TWO_PI/2.74;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  emotion(x1,y1,ang, "wink_left",tam,4,wink_left);
  
  ang = -TWO_PI/4;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  emotion(x1,y1,ang, "smile",tam,3,smile);
  
  ang = -TWO_PI/7.5;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  emotion(x1,y1,ang, "wink_right",tam,4,wink_right);
}



void emotion(float x, float y, float rot, String name, float tam, int side, float s){
  fill(0);
  float size = tam + (s*100);
  form(x,y,size,side,map(frameCount,0,1000,0,TWO_PI));
  fill(255);
  text(name,x,y);
}

//0.1
//void oscEvent(OscMessage theOscMessage){
//  if(theOscMessage.checkAddrPattern("/EXP/SMIRK_RIGHT") == true){
//    blink = theOscMessage.get(0).floatValue() * 100;
//    println(blink);
//  }
//  if(theOscMessage.checkAddrPattern("/EXP/FROWN") == true){
//    frown = theOscMessage.get(0).floatValue() * 100;
//  }
//}

//0.2
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


void form(float x, float y, float dim, int side, float ang) {
  float r = dim * 0.5;
  float da = TWO_PI/side;
  beginShape();
  for (int i = 0; i < side; i++) {
    float angs = ang + da * i;
    vertex(x+cos(angs)* r, y + sin(angs) * r);
  }
  endShape(CLOSE);
}
