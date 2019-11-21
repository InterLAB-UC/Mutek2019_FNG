import hypermedia.net.*;    // import UDP library


UDP udp;  // define the UDP object (sets up)

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
  String[] list = split(message, ";");
  //[9]:Giroscopio
  //[10]: Giroscopio
  //[11]:Giroscopio
  println(list[4]);
  
}


void draw() {
}

void mousePressed() {
  String message  = "Hola desde UDP";    // Mensaje a enviar
  String ip       = "localhost";    // IP remota
  int port        = 8088;       // Puerto destino  
  udp.send( message, ip, port );
}
