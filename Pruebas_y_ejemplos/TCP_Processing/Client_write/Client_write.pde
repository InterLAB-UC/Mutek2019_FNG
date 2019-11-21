import processing.net.*; 
Client myClient; 
int clicks;

void setup() { 
  //Define cliente para conexion
  myClient = new Client(this, "127.0.0.1", 8088); 
  // Say hello
  myClient.write("Me he conectado");
} 

void mouseReleased() {
  // Envia numero de clicks
  clicks++;
  myClient.write("Mouse presionado " + clicks + " veces.\n");
}

void draw() { 
  // Change the background if the mouse is pressed
  if (mousePressed) {
    background(255);
  } else {
    background(0);
  }
} 
