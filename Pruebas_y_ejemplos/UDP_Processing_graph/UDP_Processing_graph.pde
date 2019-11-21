import hypermedia.net.*;    // import UDP library


UDP udp;  // define the UDP object (sets up)

int xPos = 1;
int inc = 2;
int count = 0;

float x1 = 0;
float x2;
float y1;
float y2 = height / 2;

String[] list;

/**
 * init
 */
void setup() {
  size(480, 640);
  background(0);
  smooth();
  // create a new datagram connection on port 6000
  // and wait for incoming message
  udp = new UDP( this, 8088);  
  //udp.log( true );     // <-- printout the connection activity
  udp.listen( true );
}

//void receive( byte[] data ) {       // <-- default handler
void receive( byte[] data, String ip, int port ) {  // <-- extended handler
  String message = new String( data );
  //println(message);
  list = split(message, ";");
  println(list[count]);
  
}


void draw () {
  float dato = float(list[count]);

  fill(0);
  rect(0, 0, 100, 100);
  fill(204, 102, 0);
  textSize(15);
  text(str(dato), 10, 70);
  dato = map(dato, 0, 500, 200, height/2);

  // draw the line:
  stroke(255, 255, 0);
  strokeWeight(2);
  line(xPos - inc , y1, xPos, y2);

  y1 = y2;
  y2 = height - dato;

  // at the edge of the screen, go back to the beginning:
  if (xPos >= width) {
    xPos = 0;
    background(0);
  } else {
    // increment the horizontal position:
    xPos= xPos + inc;
  }
}

void mousePressed() {
  count = count +1;
  String message  = "Hola desde UDP";    // Mensaje a enviar
  String ip       = "localhost";    // IP remota
  int port        = 8088;       // Puerto destino  
  udp.send( message, ip, port );
}
