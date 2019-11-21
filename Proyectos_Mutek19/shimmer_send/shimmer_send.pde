//Obtiene señales de shimmer y envia datos a 2 clientes para su uso
import hypermedia.net.*;    // import UDP library
import oscP5.*;
import netP5.*;


UDP udp;  // define the UDP object (sets up)
OscP5 oscP5;
NetAddress myRemoteLocation, myRemoteLocation_main;

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
String aux_g1 ="0";
String aux_g2 ="0";
String aux_g3 ="0";
String aux_g4 ="0";

void setup() {
  size(displayWidth, displayHeight);
  background(0);
  smooth();
  println(width, height);
  frameRate(25);
  oscP5 = new OscP5(this, 12000);
  // create a new datagram connection on port 6000
  // and wait for incoming message
  udp = new UDP( this, 8088);
  myRemoteLocation_main = new NetAddress("127.0.0.1", 12001);
  myRemoteLocation = new NetAddress("127.0.0.1", 12002);
  //udp.log( true );     // <-- printout the connection activity
  udp.listen( true );
}

//void receive( byte[] data ) {       // <-- default handler
void receive( byte[] data, String ip, int port ) {  // <-- extended handler
  String message = new String( data );
  //println(message);
  list = split(message, ";");
  aux_g1 = list[8];  //Eje X
  aux_g2 = list[10]; //Eje y
  aux_g3 = list[12]; //Eje z
  aux_g4 = list[16]; //Pulse
}


void draw () {
  background(0);
  float dato_g1 = float(aux_g1);
  float dato_g2 = float(aux_g2);
  float dato_g3 = float(aux_g3);
  float dato_g4 = float(aux_g4);
  /*float dato_g1 = random(-16000, 16000);
   float dato_g2 = random(-16000, 16000);
   float dato_g3 = random(-16000, 16000);
   float dato_g4 = random(-16000, 16000);*/

  dato_g1 = map(dato_g1, -16000, 16000, -height/8, height/8);
  dato_g2 = map(dato_g2, -16000, 16000, -height/8, height/8);
  dato_g3 = map(dato_g3, -16000, 16000, -height/8, height/8);
  dato_g4 = map(dato_g4, -16000, 16000, -height/8, height/8);

  OscMessage myMessage_x_shimmer = new OscMessage("/x_shimmer");
  OscMessage myMessage_y_shimmer = new OscMessage("/y_shimmer");
  OscMessage myMessage_z_shimmer = new OscMessage("/z_shimmer");
  OscMessage myMessage_pulse_shimmer = new OscMessage("/pulse_shimmer");

  myMessage_x_shimmer.add(dato_g1);
  myMessage_y_shimmer.add(dato_g2);
  myMessage_z_shimmer.add(dato_g3);
  myMessage_pulse_shimmer.add(dato_g4);

  oscP5.send(myMessage_x_shimmer, myRemoteLocation);
  oscP5.send(myMessage_y_shimmer, myRemoteLocation);
  oscP5.send(myMessage_z_shimmer, myRemoteLocation);
  oscP5.send(myMessage_pulse_shimmer, myRemoteLocation);
  oscP5.send(myMessage_x_shimmer, myRemoteLocation_main);
  oscP5.send(myMessage_y_shimmer, myRemoteLocation_main);
  oscP5.send(myMessage_z_shimmer, myRemoteLocation_main);
  oscP5.send(myMessage_pulse_shimmer, myRemoteLocation_main);
}
