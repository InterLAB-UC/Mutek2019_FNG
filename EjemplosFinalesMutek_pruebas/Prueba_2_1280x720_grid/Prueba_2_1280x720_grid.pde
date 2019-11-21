//Dar clic con el mouse para agregar disparadores que dibujen lineas.
import processing.video.*;
import ddf.minim.*;
import de.looksgood.ani.*;

//Arreglo de Disparadores
ArrayList<Trigger_line> triggers = new ArrayList<Trigger_line>();
int limite = 10; //Límite de disparadores
boolean flag_generate_grid = false;
boolean flag_draw_triggers = true;
boolean flag_stop = true;
PImage[] grid;
int cols, rows, frame_width, frame_height;
boolean flag_circle = false;
int loc, loc_des;
IntList index_shuffle, index_orig;


int num_grids = 9;
int line_div = 3;
int pos_xy[][] = {
  {0, 0}, {426, 0}, {852, 0}, 
  {0, 240}, {426, 240}, {852, 240}, 
  {0, 480}, {426, 480}, {852, 480}
};
/*
int num_grids = 16;
 int line_div = 4;
 int pos_xy[][] = {
 {0, 0}, {320, 0}, {640, 0}, {960, 0}, 
 {0, 180}, {320, 180}, {640, 180}, {960, 180}, 
 {0, 360}, {320, 360}, {640, 360}, {960, 360}, 
 {0, 540}, {320, 540}, {640, 540}, {960, 540}
 };
 
 int num_grids = 25;
 int line_div = 5;
 int pos_xy[][] = {
 {0, 0}, {256, 0}, {512, 0}, {768, 0}, {1024, 0}, 
 {0, 144}, {256, 144}, {512, 144}, {768, 144}, {1024, 144}, 
 {0, 288}, {256, 288}, {512, 288}, {768, 288}, {1024, 288}, 
 {0, 432}, {256, 432}, {512, 432}, {768, 432}, {1024, 432}, 
 {0, 576}, {256, 576}, {512, 576}, {768, 576}, {1024, 576},
 };
 */

//Variable para capturar el video
Capture video;
Minim minim, minim_f;
AudioPlayer player, player_f;


void setup() {  
  size(1280, 720);
  //size(640, 480);
  background(255);
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, cameras[63]);
  frame_width = width;
  frame_height = height;
  cols = int(frame_width/line_div);
  rows = int(frame_height/line_div);

  println("Resolución de video: " + frame_width + "x" + frame_height);

  grid = new PImage[num_grids];
  for (int i=0; i< grid.length; i++)
  {
    grid[i] = createImage(cols, rows, RGB);
  }

  println("Número de grids : " + grid.length);

  video.start();
  index_shuffle = new IntList();
  index_orig = new IntList();
  for (int i=0; i< grid.length; i++)
  {
    index_shuffle.append(i);
    index_orig.append(i);
  }
  index_shuffle.shuffle();
  println(index_orig);
  println(index_shuffle);

  for (int i=0; i<limite; i++) 
  {
    triggers.add(new Trigger_line(random(frame_width), random(frame_height)));
    delay(int(random(2000)));
  }

  minim = new Minim(this);
  player = minim.loadFile("final.mp3");
  player.play();

  minim_f = new Minim(this);
  player_f = minim.loadFile("final.mp3");
}

void captureEvent(Capture video) {  
  //Lee la imagen de la camara
  video.read();
}

void draw() {
  video.loadPixels();
  if (flag_draw_triggers == true)
  {
    for (int k = 0; k < triggers.size(); k++)
    {
      Trigger_line item = triggers.get(k);
      item.next_line();
      item.display();
    }
  }
  if (!player.isPlaying() && flag_draw_triggers == true)
  {
    background(0);
    player_f.play();
    while (triggers.size() != 0)
    {
      triggers.remove(0);
    }
    flag_draw_triggers = false;
  }
  if (!player_f.isPlaying() && flag_draw_triggers == false && flag_stop == true)
  {
    flag_generate_grid = true;
    delay(2000);
    flag_stop = false;
  }

  if (flag_generate_grid == true)
  {
    for (int x = 0; x < frame_width; x++) {
      for (int y = 0; y < frame_height; y++ ) {
        update_grids(x, y);
      }
    }

    for (int i = 0; i < grid.length; i++)
    {
      grid[i].updatePixels();
    }

    //display_grid();
    display_grid_random();
  }
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
    strokeWeight(int(random(1, 3)));  
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

void update_grids(int x, int y)
{
  loc = x + y * frame_width;
  for (int i=0; i<grid.length; i++)
  {
    if (x>=pos_xy[index_orig.get(i)][0] && x<pos_xy[index_orig.get(i)][0]+cols && y>=pos_xy[index_orig.get(i)][1] && y<pos_xy[index_orig.get(i)][1]+rows)
    {
      loc_des = (x-pos_xy[index_orig.get(i)][0]) + (y-pos_xy[index_orig.get(i)][1]) * cols;
      grid[i].pixels[loc_des] =video.pixels[loc];
      break;
    }
  }
}

void display_grid()
{
  for (int i=0; i<grid.length; i++)
  {
    image(grid[i], pos_xy[index_orig.get(i)][0], pos_xy[index_orig.get(i)][1]);
    //image(grid[8], pos_xy[index_orig.get(8)][0], pos_xy[index_orig.get(8)][1]);
  }
}

void display_grid_random()
{
  for (int i=0; i<grid.length; i++)
  {
    image(grid[i], pos_xy[index_shuffle.get(i)][0], pos_xy[index_shuffle.get(i)][1]);
  }
}
