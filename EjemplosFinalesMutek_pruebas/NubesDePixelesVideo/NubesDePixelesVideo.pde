//Mover el mouse sobre el eje X y Y para generar una nube de pixeles en la imagen.
import processing.video.*;

int cellsize = 2; // Dimensiones de cada celda en la cuadricula
int cols, rows;   // Columnas y filas
int squares = 4;  // Division de la imagen 
float z = 0;      // Traslado
int inc = 0;

// Variable para la captura de video
Capture video;

void setup() { 
  size(640, 480, P3D);
  // Constructor para la captura de video
  cols = width/cellsize;               // Calcula el número de columnas
  rows = height/cellsize;              // Calcula el número de filas
  video = new Capture(this, width, height);  
  video.start();
}

void captureEvent(Capture video) {  
  video.read();
}

void draw() {  
  background(0);
  video.loadPixels();  
  // Columnas
  for ( int i = 0; i < cols; i++) {
    // Filas
    for ( int j = 0; j < rows; j++) {
      int x = i*cellsize + cellsize/2; // Posición X
      int y = j*cellsize + cellsize/2; // Pocisión Y
      int loc = x + y*width;           // Localización de pixeles
      color c = video.pixels[loc];       // Toma el color del pixel

      // Cuadrante 1
      if (i>=0 && i<= int(cols/squares) && j>=0 && j<=int(rows/squares))
      {
        z = (mouseX/(float)width) * brightness(video.pixels[loc]*6-500);
        //z=mouseX;
      }
      // Cuadrante 2
      else if (i>int(cols/squares) && i<= cols && j>=0 && j<=int(rows/squares)) {
        z = (mouseY/(float)width) * brightness(video.pixels[loc]*6-500);
      } 
      // Cuadrante 3
      else if (i>=0 && i<= int(cols/squares) && j>int(rows/squares) && j<=rows) {
        z = (mouseX/(float)width) * brightness(video.pixels[loc]*6-500);
      } 
      // Cuadrante 4
      else {
        z = (mouseY/(float)width) * brightness(video.pixels[loc]*6-500);
      }

      // Traslada los pixeles
      pushMatrix();
      translate(x, y, z);
      fill(c);
      noStroke();
      rectMode(CENTER);
      rect(0, 0, cellsize, cellsize);
      popMatrix();
    }
  }
}  
