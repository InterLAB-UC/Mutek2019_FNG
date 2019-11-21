PImage img;       // Imagen
int cellsize = 2; // Dimensiones de cada celda en la cuadricula
int cols, rows;   // Columnas y filas
int squares = 2;  // Division de la imagen 
float z = 0;      // Traslado

void setup() {
  size(500, 500, P3D);
  img  = loadImage("cara500x500.jpg"); // Carga la imagen
  cols = width/cellsize;               // Calcula el número de columnas
  rows = height/cellsize;              // Calcula el número de filas
}

void draw() {
  background(0);
  loadPixels();
  // Columnas
  for ( int i = 0; i < cols; i++) {
    // Filas
    for ( int j = 0; j < rows; j++) {
      int x = i*cellsize + cellsize/2; // Posición X
      int y = j*cellsize + cellsize/2; // Pocisión Y
      int loc = x + y*width;           // Localización de pixeles
      color c = img.pixels[loc];       // Toma el color del pixel

      // Cuadrante 1
      if (i>=0 && i<= int(cols/squares) && j>=0 && j<=int(rows/squares))
      {
        z = (mouseX/(float)width) * brightness(img.pixels[loc]*6+100);
      }
      // Cuadrante 2
      else if (i>int(cols/squares) && i<= cols && j>=0 && j<=int(rows/squares)) {
        z = (mouseY/(float)width) * brightness(img.pixels[loc]*6+100);
      } 
      // Cuadrante 3
      else if (i>=0 && i<= int(cols/squares) && j>int(rows/squares) && j<=rows) {
        z = (mouseX/(float)width) * brightness(img.pixels[loc]*6+100);
      } 
      // Cuadrante 4
      else {
        z = (mouseY/(float)width) * brightness(img.pixels[loc]*6+100);
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
