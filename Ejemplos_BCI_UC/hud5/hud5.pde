import netP5.*;
import oscP5.*;
import ddf.minim.*;

Minim minim;

AudioSample HH;
AudioSample Chord;
AudioSample Clap;
AudioSample Kick;
AudioSample Water;
AudioSample kick2;

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

int s = 0;

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
  
  minim = new Minim(this);

  HH = minim.loadSample("sample/HH.mp3",512);
  Chord = minim.loadSample("sample/Chords 7.mp3",512);
  Clap = minim.loadSample("sample/Clap.mp3",512);
  Kick = minim.loadSample("sample/Impact kick.mp3",512);
  Water = minim.loadSample("sample/Water texture.mp3",512);
  kick2 = minim.loadSample("sample/Kick.mp3",512);
  
}


void draw(){
  background(255);
  float x = width/2;
  float y = height/2;
  float x1,y1;
  float ang;
  float dist =350;
 
 
  ang = TWO_PI;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  triggerHH(x1,y1,colors[0], frown, "Fruncir");
  
  
  ang = TWO_PI/7.5;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  triggerChord(x1,y1,colors[1],smirk_right, "Mueca Derecha");
  

  ang = TWO_PI/4;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  triggerWater(x1,y1,colors[2],laugh, "Reir");
  
  
  ang = TWO_PI/2.74;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  triggerClap(x1,y1,colors[3], smirk_left,"Mueca Izquierda");
  
  
  ang = TWO_PI/2;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
 trigger(x1,y1,colors[3], blink, "Parpadear");
  
  ang = -TWO_PI/2.74;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  trigger(x1,y1,colors[4],wink_left, "Guino Izquierdo");
 
  ang = -TWO_PI/4;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  triggerKick(x1,y1,colors[5], smile, "Sonriza");
  
  ang = -TWO_PI/7.5;
  x1 = x + cos(ang) * dist;
  y1 = y + sin(ang) * dist;
  trigger(x1,y1,colors[6], wink_right, "Guino Derecho");
}

void keyPressed(){
  if(key == '1') s = 1;
  if(key == '0') s = 0;
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

color colors[] = {
#CCFF00,#00CC66,#00CC00,#3333CC,#990099,#FF0000,#FF9900, #EF089C
};
