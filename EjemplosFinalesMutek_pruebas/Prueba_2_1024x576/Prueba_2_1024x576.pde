//Dar clic con el mouse para agregar disparadores que dibujen lineas.
import processing.video.*;
import ddf.minim.*;
import de.looksgood.ani.*;
import oscP5.*;

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
int h_grid = 0;
float des_z = 0;
int pos_target = -1;
float mic_1 = 0, mic_2 = 0, mic_3 = 0, mic_4 =0;

int num_grids = 9;
int line_div = 3;
int pos_xy[][] = {
  {0, 0}, {341, 0}, {682, 0}, 
  {0, 192}, {341, 192}, {682, 192}, 
  {0, 384}, {341, 384}, {682, 384}
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
AudioInput in;
OscP5 oscP5;


void setup() {  
  size(1024, 576, P3D);
  background(255);
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, cameras[61]);
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
  player = minim.loadFile("audio_corte.mp3");
  player.play();

  minim_f = new Minim(this);
  player_f = minim.loadFile("final.mp3");

  in = minim.getLineIn( Minim.STEREO, 512);

  oscP5 = new OscP5(this, 12001);
  Ani.init(this);
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
    background(0);
    for (int x = 0; x < frame_width; x++) {
      for (int y = 0; y < frame_height; y++ ) {
        update_grids(x, y);
      }
    }

    for (int i = 0; i < grid.length; i++)
    {
      grid[i].updatePixels();
    }

    display_grid();
    //display_grid_random();
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
    newx = constrain(x + random(-20, 20), 0, frame_width);   
    newy = constrain(y + random(-20, 20), 0, frame_height-1);

    // Find the midpoint of the line
    int midx = int((newx + x) / 2);
    int midy = int((newy + y) / 2);

    // Pick the color from the video, reversing x
    int index = (frame_width-1-midx) + midy*frame_width;
    if (index<0)
    { 
      index = 0;
    }
    c = video.pixels[index];
  }
}

void update_grids(int x, int y)
{
  //Calcula el pixel del video original
  loc = x + y * frame_width;

  for (int i=0; i<grid.length; i++)
  {
    if (x>=pos_xy[index_orig.get(i)][0] && x<pos_xy[index_orig.get(i)][0]+cols && y>=pos_xy[index_orig.get(i)][1] && y<pos_xy[index_orig.get(i)][1]+rows)
    {
      //Calcula el pixel destino para cada grid
      int loc_des_x = x-pos_xy[index_orig.get(i)][0];
      int loc_des_y = y-pos_xy[index_orig.get(i)][1];
      loc_des = loc_des_x + loc_des_y * cols;

      //Copia el pixel del video original a su grid correspondiente
      grid[i].pixels[loc_des] =video.pixels[loc];

      //Pixelea un grid en particular
      //highlight_pixels(4, loc_des_x, loc_des_y);
      move_pixels(i, loc_des_x, loc_des_y, des_z, mic_1, mic_2, mic_3, mic_4);
      break;
    }
  }
}

void display_grid()
{
  for (int i=0; i<grid.length; i++)
  {
    //image(grid[i], pos_xy[index_orig.get(i)][0], pos_xy[index_orig.get(i)][1]);
  }
}

void display_grid_random()
{
  for (int i=0; i<grid.length; i++)
  {
    image(grid[i], pos_xy[index_shuffle.get(i)][0], pos_xy[index_shuffle.get(i)][1]);
  }
}

void highlight_pixels(int i, int x, int y)
{
  int loc = x + y * cols;

  color c = grid[i].pixels[loc];       // Toma el color del pixel

  float z = random((mouseX/2/(float)(cols/3))) * brightness(grid[i].pixels[loc]);

  //Traslada los pixeles
  pushMatrix();
  translate(x, y, z);
  fill(c);
  noStroke();
  rectMode(CENTER);
  rect(pos_xy[index_shuffle.get(i)][0], pos_xy[index_shuffle.get(i)][1], 2, 2);
  popMatrix();
}
void move_pixels(int i, int x, int y, float zz, float mic1, float mic2, float mic3, float mic4)
{
  int loc = x + y * cols;
  color c = grid[i].pixels[loc];

  float z = random((zz/2/(float)(cols/3))) * brightness(grid[i].pixels[loc]);
  float inc =0;

  // Traslada los pixeles
  pushMatrix();
  if (y>=0 && y<10) {
    inc=1.1;
  }
  if (y>=10 && y<20) {
    inc=0.2;
  }
  if (y>=20 && y<30) {
    inc=0.8;
  }
  if (y>=30 && y<40) {
    inc=0.4;
  }
  if (y>=40 && y<50) {
    inc=1.5;
  }
  if (y>=50 && y<60) {
    inc=0.1;
  }
  if (y>=60 && y<70) {
    inc=0.5;
  }
  if (y>=70 && y<80) {
    inc=1.3;
  }
  if (y>=80 && y<90) {
    inc=1.6;
  }
  if (y>=90 && y<100) {
    inc=0.7;
  }
  if (y>=100 && y<110) {
    inc=1.1;
  }
  if (y>=110 && y<120) {
    inc=0.3;
  }
  if (y>=120 && y<130) {
    inc=0.9;
  }
  if (y>=130 && y<140) {
    inc=1.4;
  }
  if (y>=140 && y<150) {
    inc=0.4;
  }
  if (y>=150 && y<160) {
    inc=0.2;
  }
  if (y>=160 && y<170) {
    inc=1.2;
  }
  if (y>=170 && y<180) {
    inc=1.6;
  }
  if (y>=180 && y<190) {
    inc=0.6;
  }
  if (y>=190 && y<200) {
    inc=1.7;
  }
  if (y>=200 && y<210) {
    inc=0.9;
  }
  if (y>=210 && y<220) {
    inc=0.2;
  }
  if (y>=220 && y<230) {
    inc=1.2;
  }
  if (y>=230 && y<240) {
    inc=0.5;
  }

  if ((y>=0 && y<180) && (i == 0 || i ==1 || i==2)) {
    translate(x+int(mic1*inc), y, z);
    if (x+int(mic1*inc)>=cols) 
    {
      c=0;
    }
  }
  if ((y>=180 && y<240) && (i == 0 || i ==1 || i==2)) {
    translate(x-int(mic2*inc), y, z);
    if (x-int(mic2*inc)<=0) 
    {
      c=0;
    }
  }
  if ((y>=0 && y<120) && (i == 3|| i == 4 || i == 5)) {
    translate(x-int(mic2*inc), y, z);
    if (x-int(mic2*inc)<=0) 
    {
      c=0;
    }
  }
  if ((y>=120 && y<240) && (i == 3 || i ==4 || i==5)) {
    translate(x+int(mic3*inc), y, z);
    if (x+int(mic3*inc)>=cols) 
    {
      c=0;
    }
  }
  if ((y>=0 && y<60) && (i == 6 || i ==7 || i == 8)) {
    translate(x+int(mic3*inc), y, z);
    if (x+int(mic3*inc)>=cols) 
    {
      c=0;
    }
  }
  if ((y>=60 && y<240) && (i == 6|| i == 7 || i == 8)) {
    translate(x-int(mic4*inc), y, z);
    if (x-int(mic4*inc)<=0) 
    {
      c=0;
    }
  }

  fill(c);
  noStroke();
  rectMode(CENTER);
  rect(pos_xy[index_shuffle.get(i)][0], pos_xy[index_shuffle.get(i)][1], 2, 2);
  popMatrix();
}

void mouseReleased() {
}
void keyPressed()
{
  if (key == 's')
  {
    pos_target++;
    if (pos_target < grid.length)
    {
      draw_target(pos_target);
    } else {
      pos_target = 0;
      draw_target(pos_target);
    }
  }
  if (key == 'o')
  {
    Ani.to(this, 1.0, "des_z", 700);
  }
  if (key == 'i')
  {
    Ani.to(this, 1.0, "des_z", 0);
  }
}

void draw_target(int i)
{
  noFill();
  stroke(255, 0, 0);
  strokeWeight(3);
  rectMode(CORNER);
  rect(pos_xy[index_orig.get(i)][0], pos_xy[index_orig.get(i)][1], cols, rows);
}
void oscEvent(OscMessage theOscMessage) {

  if (theOscMessage.checkAddrPattern("/mic1")==true) 
  {
    int firstValue = theOscMessage.get(0).intValue();  
    println(firstValue);
    mic_1 = firstValue;
  } 
  if (theOscMessage.checkAddrPattern("/mic2")==true) 
  {
    int firstValue = theOscMessage.get(0).intValue();  
    mic_2 = firstValue;
  }
  if (theOscMessage.checkAddrPattern("/mic3")==true) 
  {
    int firstValue = theOscMessage.get(0).intValue();  
    mic_3 = firstValue;
  }
  if (theOscMessage.checkAddrPattern("/mic4")==true) 
  {
    int firstValue = theOscMessage.get(0).intValue();  
    mic_4 = firstValue;
  }
}
