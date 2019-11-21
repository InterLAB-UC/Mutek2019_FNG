import netP5.*;
import oscP5.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

OscP5 oscp5;

Minim       minim;
FilePlayer      filed,filei;
Gain       gaind,gaini;
AudioOutput out;

public float smirk_left = 0;
public float smirk_right = 0;

int port = 7400;

int hi = 0;
int hd = 0;

void setup(){
  size(900,300);
  smooth(8);
  pixelDensity(displayDensity());

  oscp5 = new OscP5(this,port);
  
  oscp5.plug(this,"updateSmirkL","/EXP/SMIRK_LEFT");
  oscp5.plug(this,"updateSmirkR","/EXP/SMIRK_RIGHT");
  colorMode(HSB,360,100,100);
  
  minim = new Minim(this);
  filed = new FilePlayer(minim.loadFileStream("padd.mp3"));
  filei = new FilePlayer(minim.loadFileStream("padi.mp3"));
  gaind = new Gain(0.f);
  gaini = new Gain(0.f);
  filed.play();
  filei.play();
  out = minim.getLineOut();
  filed.patch(gaind).patch(out);
  filei.patch(gaini).patch(out);
}

void draw(){
 
  //float h1 = map(smirk_right,0.000,1.000,100,320);
  if(smirk_right > 0.09) hd+=1;
  else hd-=1;
  fill(hd,100,100);
  rect(0,0,width/2,height);
  fill(0);
  text("derecha", 100,height/2);
  text(smirk_right,100,height/2+50);
  
  hd = constrain(hd,0,360);
  
  //float h2 = map(smirk_left,0.000,1.000,10,320);
  if(smirk_left > 0.09) hi+=1;
  else hi-=1;
  fill(hi,99,99);
  rect(width/2,0,width/2,height);
  fill(0);
  text("izquierda", width/2+100,height/2);
  text(smirk_left,width/2+100,height/2+50);

  hi = constrain(hi,0,237);
  
  float vold = map( hd, 0,360, -19, 12 );
  float voli = map( hi, 0,237,-19,12);
  
 
   gaind.setValue(vold);
   gaini.setValue(voli);

 
}

public void updateSmirkL(float theValue) {
  smirk_left = theValue;
  println("SmirkLeft: "+smirk_left);
}

public void updateSmirkR(float theValue) {
  smirk_right = theValue;
  println("SmirkRight: "+smirk_right);
}
