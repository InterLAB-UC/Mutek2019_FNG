import ddf.minim.*;

Minim minim;

AudioSample HH;
AudioSample Chord;
AudioSample Clap;
AudioSample Kick;
AudioSample Water;
AudioSample kick2;


Core core;

Sides[] sides;



void setup(){
  size(1000,1000);
  
  smooth(8);
  pixelDensity(displayDensity());
  
  minim = new Minim(this);
  
  HH = minim.loadSample("sample/HH.mp3", 512);
  Chord = minim.loadSample("sample/Chords 7.mp3", 512);
  Clap = minim.loadSample("sample/Clap.mp3", 512);
  Kick = minim.loadSample("sample/Impact kick.mp3", 512);
  Water = minim.loadSample("sample/Water texture.mp3", 512);
  kick2 = minim.loadSample("sample/Kick.mp3", 512);

  core = new Core(width/2,height/2);
  
  sides = new Sides[8];
 
  float x = width/2;
  float y = height/2;
  float ang = TWO_PI;
  float tam = 350;
  
  for(int i = 0; i < sides.length; i++){
    float xx = x + cos(ang) * tam;
    float yy = y + sin(ang) * tam;
    sides[i] = new Sides(xx,yy,i,i);
    ang+=0.8;
  }
  
}

void draw(){
 background(255);
 
 core.display(str(random(200)));
 
 for(int i = 0; i < sides.length; i++){
   sides[i].display();
 }
 
}

class Core{
  float x,y, size;

  PFont f = createFont("Courier",16,true);
 
  
  Core(float x, float y){
    this.x = x;
    this.y = y;
    
    size = 200; 
    
    ellipseMode(CENTER);
    textAlign(CENTER);
    textSize(16);
    
  }
  
  
  void display(String var){
   lines();
    noStroke();
    fill(0);
    ellipse(x,y,size,size);
    fill(255);
    text(var,x,y);
  }
  
  
  void lines(){
    float ang = 0;
    float tam = 40;
   for(int j = 0; j < 8; j++){
    float x1 = x;
    float y1 = y;
    int cc = 39;
    
    for(int i = 0; i < cc; i++){
    float xx = x1 + cos(ang) * tam/4;
    float yy = y1 + sin(ang) * tam/4;
    float s = tam * map(i,0,cc,0.99,0.1);
    stroke(random(255),random(255),random(255));
    noFill();
    ellipse(x1,y1,s,s);
    x1 = xx;
    y1 = yy;
    }
    ang+=0.8;
  }
 }
 
 
}

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

class Sides {

  float x, y, size;
  int indexColor;
  PFont f = createFont("Courier", 16, true);
  int expresion;
  int port = 7400;
  float tam;


  Sides(float x, float y, color c, int selection) {

    this.x = x;
    this.y = y;
    indexColor = c;
    size = 150;
    expresion = selection;

    oscp5 = new OscP5(this, port);

    oscp5.plug(this, "updateFrown", "/EXP/FROWN");
    oscp5.plug(this, "updateBlink", "/EXP/BLINK");
    oscp5.plug(this, "updateLaugh", "/EXP/LAUGH");
    oscp5.plug(this, "updateWinkL", "/EXP/WINK_LEFT");
    oscp5.plug(this, "updateWinkR", "/EXP/WINK_RIGHT");
    oscp5.plug(this, "updateSurprise", "/EXP/SURPRISE");
    oscp5.plug(this, "updateSmile", "/EXP/SMILE");
    oscp5.plug(this, "updateClench", "/EXP/CLENCH");
    oscp5.plug(this, "updateSmirkL", "/EXP/SMIRK_LEFT");
    oscp5.plug(this, "updateSmirkR", "/EXP/SMIRK_RIGHT");


    ellipseMode(CENTER);
    textFont(f);
    textAlign(CENTER);
  }

  void display() {

    noStroke();
    fill(colors[indexColor]);
    ellipse(x, y, tam, tam);
    fill(0);
    if (expresion == 0) {
      tam = size+(frown * 100);
      text(frown, x, y);
     if(frown > 0.5){
      HH.trigger();
      }
    }
    if (expresion == 1) {
      tam = size+laugh * 100; 
      text(laugh, x, y);
      if(frown > 0.5){
        Chord.trigger();
      }
    }
    if (expresion == 2) {
      tam =size+ smile * 100; 
      text(smile, x, y);
      if(frown > 0.5){
        Clap.trigger();
      }
    }
    if (expresion == 3) {
      tam = size+clench * 100; 
      text(clench, x, y);
      if(frown > 0.5){
         Kick.trigger();
      }
    }
    if (expresion == 4) {
      tam = size+surprise * 100;  
      text(surprise, x, y);
      if(frown > 0.5){
        kick2.trigger();
      }
    }
    if (expresion == 5) {
      tam = size+wink_left * 100;  
      text(wink_left, x, y);
      if(frown > 0.5){
         Water.trigger();
      }
    }
    if (expresion == 6) {
      tam =size+ wink_right * 100;
      text(wink_right, x, y);
      if(frown > 0.5){
        HH.trigger();
      }
    }
    if (expresion == 7) {
      tam =size+ frown * 100;
    }
  }



  color colors[] = {
    #FF009D, #000000, #FFFFFF, #303030, #FFFF00, #009AFF, #FB8A98, #FDB5BC
  };
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
