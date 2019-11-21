import netP5.*;
import oscP5.*;

OscP5 oscp5;
NetAddress superCollider;

public float smirk_left = 0;
public float smirk_right = 0;

int port = 7400;

int hi = 0;
int hd = 0;

void setup(){
  size(700,300);
  smooth(8);
  
  oscp5 = new OscP5(this,port);
  
  oscp5.plug(this,"updateSmirkL","/EXP/SMIRK_LEFT");
  oscp5.plug(this,"updateSmirkR","/EXP/SMIRK_RIGHT");
  
  superCollider = new NetAddress("127.0.0.1",57120);
}

void draw(){
  
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
  
  float vold = map( hd, 0,360, -29, 12 );
  float voli = map( hi, 0,237,-29,12);
  if(hi > 100){
    OscMessage msg = new OscMessage("/brainwave");
    msg.add(map(hi,100,237,1,40));
    oscp5.send(msg,superCollider);
  }
}

public void updateSmirkL(float theValue) {
  smirk_left = theValue;
  println("SmirkLeft: "+smirk_left);
}

public void updateSmirkR(float theValue) {
  smirk_right = theValue;
  println("SmirkRight: "+smirk_right);
}
