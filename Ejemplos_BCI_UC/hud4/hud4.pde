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
  
  if(frown>0.5){
    trigger(#CCFF00,frown,4);
  }
  
  if(blink>0.5){
    trigger(#00CC66,blink,3);
  }
  
   if(laugh>0.5){
    trigger(#00CC00,laugh,8);
  }
  
  if(wink_left >0.5){
    trigger(#3333CC,wink_left,5);
  }
  
  if(wink_right > 0.5){
   trigger(#990099,wink_right,6);
  }
  
  if(surprise > 0.5){
    trigger(#FF0000,surprise,10);
  }
  
  if(smile > 0.5){
     trigger(#FF9900, smile,20);
  }
  
  if(clench > 0.5){
    trigger(#EF089C, clench,20);
  }
  

  
}

void trigger(color c, float message, int side){
  
  for(int i = 0; i < 100; i++){
  
  float x = random(width);
  float y = random(height);
  float lar = 10;
  fill(c);
  noStroke();
  ellipse(x,y,lar,lar);
  //form(x,y,lar,side,random(TWO_PI));
 
  }
  
   if(message > 0.5){
    OscMessage msg = new OscMessage("/brainwave");
    msg.add(map(message,0.0,1.0,0,1));
    oscp5.send(msg,superCollider);
  }
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
  println("WinkLeft: "+wink_left);
}

public void updateWinkR(float theValue) {
  wink_right = theValue;
  println("WinkRight: "+wink_right);
}

public void updateSurprise(float theValue) {
   surprise = theValue;
    println("Surprise: "+surprise);
}

public void updateSmile(float theValue) {
   smile = theValue;
   println("Smile: "+smile);
}

public void updateClench(float theValue) {
   clench = theValue;
    println("Clench: "+clench);
}

public void updateSmirkL(float theValue) {
   smirk_left = theValue;
    println("SmirkLeft: "+smirk_left);
}

public void updateSmirkR(float theValue) {
   smirk_right = theValue;
    println("SmirkRight: "+smirk_right);
}
