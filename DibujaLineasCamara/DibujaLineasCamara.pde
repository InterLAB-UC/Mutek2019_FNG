import processing.video.*;

//Arreglo de Disparadores
ArrayList<Trigger_line> triggers = new ArrayList<Trigger_line>();
int limite = 15; //Límite de disparadores
boolean flag_inc = true;
boolean flag_dec = false;

//Variable para capturar el video
Capture video;

void setup() {  
  size(320, 240);  
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
  video.loadPixels();

  for (int k = 0; k < triggers.size(); k++)
  {
    Trigger_line item = triggers.get(k);
    item.next_line();
    item.display();
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
    triggers.add(new Trigger_line(width/2, height/2));
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
  float x;
  float y;
  float newx;
  float newy;
  color c;

  // Constructor
  Trigger_line(float tempX, float tempY) { 
    x = tempX;
    y = tempY;
  }

  //Dibuja disparador
  void display() {
    stroke(c);  
    strokeWeight(3);  
    line(x, y, newx, newy);

    // Save (newx,newy) in (x,y)  
    x = newx;  
    y = newy;
  }

  //Calcula trayectoria de linea
  void next_line() {
    newx = constrain(x + random(-20, 20), 0, width);   
    newy = constrain(y + random(-20, 20), 0, height-1);

    // Find the midpoint of the line
    int midx = int((newx + x) / 2);
    int midy = int((newy + y) / 2);

    // Pick the color from the video, reversing x
    int index = (width-1-midx) + midy*video.width;
    if (index<0)
    { 
      index = 0;
    }
    c = video.pixels[index];
  }
}
