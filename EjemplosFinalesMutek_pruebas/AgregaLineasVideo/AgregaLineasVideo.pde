//Dar clic con el mouse para agregar disparadores que dibujen lineas.
import processing.video.*;

//Arreglo de Disparadores
ArrayList<Trigger_line> triggers = new ArrayList<Trigger_line>();
int limite = 200; //Límite de disparadores
boolean flag_inc = true;
boolean flag_dec = false;

//Variable para capturar el video
Capture video;

void setup() {  
  size(640, 480);  
  background(255);  
  //Inicia el proceso de captura de video
  video = new Capture(this, width, height);  
  video.start();
}

void captureEvent(Capture video) {  
  //Lee la imagen de la camara
  video.read();
}

void draw() {
  background(video);

  for (int k = 0; k < triggers.size(); k++)
  {
    Trigger_line item = triggers.get(k);
    item.display();
    item.move();
  }
}
void mouseReleased() {

  if (flag_dec == true)
  {
    triggers.remove(0);
    if (triggers.size() == 0)
    {
      flag_inc = true;
      flag_dec = false;
      background(255);
    }
  }

  if (flag_inc == true)
  {
    triggers.add(new Trigger_line(random(height)));
    if (triggers.size() == limite)
    {
      flag_inc = false;
      flag_dec = true;
    }
  }

  int total = triggers.size();
  println("Total de disparadores : " + total);
}

//Clase de Disparadores para dibujar lineas 
class Trigger_line { 
  float y;
  int r;
  int g;
  int b;

  // Constructor
  Trigger_line(float tempY) { 
    y = tempY;
    r = int(random(0, 255));
    g = int(random(0, 255));
    b = int(random(0, 255));
  }

  //Dibuja disparador
  void display() {
    stroke(r, g, b);
    line(0, y, width, y);
  }

  //Calcula trayectoria de linea
  void move() {
    y++;
    if (y > height) {
      y = 0;
    }
  }
}
