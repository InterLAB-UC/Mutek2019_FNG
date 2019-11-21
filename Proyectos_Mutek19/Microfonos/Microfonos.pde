//Programa para detectar señales de 2 micrófonos y enviar datos por Osc mediante
// 4 etiquetas de identificación

import ddf.minim.*;
import oscP5.*;
import netP5.*;

Minim minim;
AudioInput in;
OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  size(800, 800);
  frameRate(25);
  oscP5 = new OscP5(this, 12000);

  minim = new Minim(this);

  in = minim.getLineIn( Minim.STEREO, 512);
  myRemoteLocation = new NetAddress("127.0.0.1", 12001);
  println(width);
  println(height);
}


void draw() {
  OscMessage myMessage_mic1 = new OscMessage("/mic1");
  OscMessage myMessage_mic2 = new OscMessage("/mic2");
  OscMessage myMessage_mic3 = new OscMessage("/mic3");
  OscMessage myMessage_mic4 = new OscMessage("/mic4");
  fill(0, 16);
  noStroke();
  rect(0, 0, width, height);
  stroke(255);
  noFill();

  float mic_r = 0, mic_l=0;

  for (int i = 0; i < in.bufferSize(); i++) {
    mic_r += abs(in.right.get(i))*5;
    mic_l += abs(in.left.get(i))*5;
  }
  ellipse(width/4, height/2, mic_l, mic_l);
  myMessage_mic1.add(int(mic_l));
  myMessage_mic3.add(int(mic_l));
  oscP5.send(myMessage_mic1, myRemoteLocation);
  oscP5.send(myMessage_mic3, myRemoteLocation);
  
  ellipse(width/2 + width/4, height/2, mic_r, mic_r);
  myMessage_mic2.add(int(mic_r));
  myMessage_mic4.add(int(mic_r));
  oscP5.send(myMessage_mic2, myRemoteLocation);
  oscP5.send(myMessage_mic4, myRemoteLocation);
  //println(mic_l,mic_r);
}

void stop() {
  in.close();
  minim.stop();
  super.stop();
}
