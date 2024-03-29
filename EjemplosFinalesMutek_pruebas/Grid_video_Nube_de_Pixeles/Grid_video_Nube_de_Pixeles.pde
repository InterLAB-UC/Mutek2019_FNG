//Mover el mouse sobre el eje X y Y para generar una nube de pixeles en la imagen.
import processing.video.*;

PImage video_grid;
PImage[] grid;
int cols, rows;
int loc, loc_des;
IntList index, index_orig;
float z = 0;      // Traslado
int cellsize = 2; // Dimensiones de cada celda en la cuadricula
int pos_xy[][] = {{0, 0}, {213, 0}, {426, 0}, {0, 160}, {213, 160}, {426, 160}, {0, 320}, {213, 320}, {426, 320}};

// Variable para la captura de video
Capture video;

void setup() { 
  size(640, 480, P3D);
  // Constructor para la captura de video
  video = new Capture(this, width, height); 
  cols = width;
  rows = height;
  video_grid = createImage(cols, rows, RGB);

  grid = new PImage[9];
  for (int i=0; i< grid.length; i++)
  {
    grid[i] = createImage(cols/3, rows/3, RGB);
  }

  video.start();
  index = new IntList();
  index_orig = new IntList();
  for (int i=0; i< grid.length; i++)
  {
    index.append(i);
    index_orig.append(i);
  }
  index.shuffle();
  println(index_orig);
  println(index);
}

void captureEvent(Capture video) {  
  video.read();
}

void draw() {  
  background(0);
  video.loadPixels();
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++ ) {
      update_grids(x, y);
    }
  }

  for (int i = 0; i < grid.length; i++)
  {
    grid[i].updatePixels();
  }


  for ( int x = 0; x < cols/3; x++) {
    // Filas
    for ( int y = 0; y < rows/3; y++) {
      int loc = x + y*(cols/3);           // Localización de pixeles
      for (int i=0; i<grid.length; i++)
      {
        color c = grid[i].pixels[loc];       // Toma el color del pixel

        z = random((mouseX/2/(float)(cols/3))) * brightness(grid[i].pixels[loc]);

        // Traslada los pixeles
        pushMatrix();
        translate(x, y, z);
        fill(c);
        noStroke();
        rectMode(CENTER);
        rect(pos_xy[index.get(i)][0], pos_xy[index.get(i)][1], cellsize, cellsize);
        popMatrix();
      }
    }
  }
}

void update_grids(int x, int y)
{
  //Grid01
  loc = x + y * cols;
  if (x>=0 && x<213 && y>=0 && y<160)
  {
    loc_des = x + y * (cols/3);
    grid[0].pixels[loc_des] = video.pixels[loc];
  }

  //Grid02
  if (x>=213 && x<426 && y>=0 && y<160)
  {
    loc_des = (x-213) + (y) * (cols/3);
    grid[1].pixels[loc_des] = video.pixels[loc];
  }

  //Grid03
  if (x>=426 && x<639 && y>=0 && y<160)
  {
    loc_des = (x-426) + (y) * (cols/3);
    grid[2].pixels[loc_des] = video.pixels[loc];
  }

  //Grid04
  if (x>=0 && x<213 && y>=160 && y<320)
  {
    loc_des = (x) + (y-160) * (cols/3);
    grid[3].pixels[loc_des] = video.pixels[loc];
  }

  //Grid05
  if (x>=213 && x<426 && y>=160 && y<320)
  {
    loc_des = (x-213) + (y-160) * (cols/3);
    grid[4].pixels[loc_des] = video.pixels[loc];
  }

  //Grid06
  if (x>=426 && x<639 && y>=160 && y<320)
  {
    loc_des = (x-426) + (y-160) * (cols/3);
    grid[5].pixels[loc_des] = video.pixels[loc];
  }

  //Grid07
  if (x>=0 && x<213 && y>=320 && y<480)
  {
    loc_des = (x) + (y-320) * (cols/3);
    grid[6].pixels[loc_des] = video.pixels[loc];
  }

  //Grid08
  if (x>=213 && x<426 && y>=320 && y<480)
  {
    loc_des = (x-213) + (y-320) * (cols/3);
    grid[7].pixels[loc_des] = video.pixels[loc];
  }

  //Grid09
  if (x>=426 && x<639 && y>=320 && y<480)
  {
    loc_des = (x-426) + (y-320) * (cols/3);
    grid[8].pixels[loc_des] = video.pixels[loc];
  }
}

void display_grid()
{
  for (int i=0; i<grid.length; i++)
  {
    image(grid[i], pos_xy[index_orig.get(i)][0], pos_xy[index_orig.get(i)][1]);
  }
}

void display_grid_random()
{
  for (int i=0; i<grid.length; i++)
  {
    image(grid[i], pos_xy[index.get(i)][0], pos_xy[index.get(i)][1]);
  }
}

void mouseReleased() {
  index.shuffle();
  println("Shuffle index" + index);
}
