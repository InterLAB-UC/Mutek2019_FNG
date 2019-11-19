//Dar clic con el mouse para agregar disparadores que dibujen lineas.
import processing.video.*;
import ddf.minim.*;
import de.looksgood.ani.*;
import oscP5.*;

//Arreglo de Disparadores
ArrayList<Trigger_line> triggers = new ArrayList<Trigger_line>();
int limite = 10; //Límite de disparadores
boolean flag_generate_grid = false;
boolean flag_activa_end = false;
boolean flag_draw_triggers = true;
boolean flag_stop = true;
boolean flag_start_audios = true;
boolean flag_move_grid = true;
boolean flag_draw_red_target = true;
PImage[] grid;
int cols, rows, frame_width, frame_height;
boolean flag_circle = false;
int loc, loc_des;
IntList index_shuffle, index_orig;
int h_grid = 0;
float des_z = 0;
float zoom = 4.5; //1.5 para la pantalla
int pos_target = -1;
float mic_1 = 0, mic_2 = 0, mic_3 = 0, mic_4 =0, x_shimmer = 0, y_shimmer = 0, z_shimmer = 0, pulse_shimmer = 0;
int w = 213;
int h = 160;
int c0, c1, c2, c3, c4, c5, c6, c7, c8;
float vol_audio_1 = 0, vol_audio_2 = 0, vol_audio_3 = 0, vol_audio_4 = 0, vol_audio_5 = 0, vol_audio_6 = 0;

/*int num_grids = 4;
 int line_div = 2;
 int pos_xy[][] = {
 {0, 0}, {320, 0},
 {0, 240}, {320, 240}
 };*/

int num_grids = 9;
int line_div = 3;
int pos_xy[][] = {
  {0, 0}, {213, 0}, {426, 0}, 
  {0, 160}, {213, 160}, {426, 160}, 
  {0, 320}, {213, 320}, {426, 320}
};
/*
 int num_grids = 16;
 int line_div = 4;
 int pos_xy[][] = {
 {0, 0},   {160, 0},   {320, 0},  {480,0}, 
 {0, 120}, {160, 120}, {320, 120},{480,120}, 
 {0, 240}, {160, 240}, {320, 240},{480,240},
 {0, 360}, {160, 360}, {320, 360},{480,360}
 };
 
 int num_grids = 25;
 int line_div = 5;
 int pos_xy[][] = {
 {0, 0}, {128, 0}, {256, 0}, {384, 0}, {512, 0}, 
 {0, 96}, {128, 96}, {256, 96}, {384, 96}, {512, 96}, 
 {0, 192}, {128, 192}, {256, 192}, {384, 192}, {512, 192}, 
 {0, 288}, {128, 288}, {256, 288}, {384, 288}, {512, 288}, 
 {0, 384}, {128, 384}, {256, 384}, {384, 384}, {512, 384}, 
 };*/

//Variable para capturar el video
Capture video;
Minim minim, minim_f, minim_1, minim_2, minim_3, minim_4, minim_5, minim_6;
AudioPlayer player, player_f, audio_1, audio_2, audio_3, audio_4, audio_5, audio_6;
AudioInput in;
OscP5 oscP5;


void setup() {
  //size(1920, 2160, P3D);
  //size(640, 480, P3D);
  size(displayWidth, displayHeight, P3D);
  background(0);
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, cameras[18]);
  frame_width = 640;
  frame_height = 480;
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
    //delay(int(random(2000)));
  }

  minim = new Minim(this);
  player = minim.loadFile("20_Lira_Mutek.mp3");
  player.play();

  minim_f = new Minim(this);
  player_f = minim_f.loadFile("final.mp3");

  minim_1 = new Minim(this);
  audio_1 = minim_1.loadFile("22_Lira_Mutek.mp3");

  minim_2 = new Minim(this);
  audio_2 = minim_2.loadFile("23_Lira_Mutek.mp3");

  minim_3 = new Minim(this);
  audio_3 = minim_3.loadFile("29_Lira_Mutek.mp3");

  minim_4 = new Minim(this);
  audio_4 = minim_4.loadFile("26_Lira_Mutek.mp3");

  minim_5 = new Minim(this);
  audio_5 = minim_5.loadFile("27_Lira_Mutek.mp3");

  minim_6 = new Minim(this);
  audio_6 = minim_6.loadFile("28_Lira_Mutek.mp3");

  in = minim.getLineIn( Minim.STEREO, 512);

  oscP5 = new OscP5(this, 12001);
  Ani.init(this);

  c0 = h;
  c1 = h;
  c2 = h;
  c3 = h+h;
  c4 = h+h;
  c5 = h+h;
  c6 = rows;
  c7 = rows;
  c8 = rows;
}

void captureEvent(Capture video) {  
  //Lee la imagen de la camara
  video.read();
}

void draw() {
  pushMatrix();
  translate(width/3, height/4, width/zoom);
  //translate(width/3, height/4+300, width/zoom);
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
    delay(2000);
    flag_generate_grid = true;
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
    draw_white_lines();
    draw_black_grid();
    draw_green_screen();

    if (y_shimmer < 0 && flag_draw_red_target == true)
    {
      draw_red_target();
    } else
    {
      if (pos_target == -1)
      {
        draw_new_target(0);
      }
      else
      {
        draw_new_target(pos_target);
      }
    }
    if(index_shuffle.get(0) == 0 && index_shuffle.get(1) == 1 && index_shuffle.get(2) == 2 && index_shuffle.get(3) == 3 && index_shuffle.get(4) == 4 &&
    index_shuffle.get(5) == 5 && index_shuffle.get(6) == 6 && index_shuffle.get(7) == 7 && index_shuffle.get(8) == 8)
    {
      flag_activa_end = true;
      flag_generate_grid = false;
    }

    //display_grid();
    //display_grid_random();
  }
   if (flag_activa_end == true)
  {
    background(0);
  }
  popMatrix();

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
      if(y_shimmer > 0)
      {
        mic_1 = 0;
        mic_2 = 0;
        mic_3 = 0;
        mic_4 = 0;
      }
      move_pixels(i, loc_des_x, loc_des_y, des_z, mic_1, mic_2, mic_3, mic_4);
      break;
    }
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
  if (y>=0 && y<3) {
    inc=1.1;
  }
  if (y>=3 && y<6) {
    inc=0.2;
  }
  if (y>=6 && y<9) {
    inc=0.8;
  }
  if (y>9 && y<12) {
    inc=0.4;
  }
  if (y>=12 && y<15) {
    inc=1.5;
  }
  if (y>=15 && y<18) {
    inc=0.1;
  }
  if (y>=18 && y<21) {
    inc=0.5;
  }
  if (y>=21 && y<24) {
    inc=1.3;
  }
  if (y>=24 && y<27) {
    inc=1.6;
  }
  if (y>=27 && y<30) {
    inc=0.7;
  }
  if (y>=30 && y<33) {
    inc=1.1;
  }
  if (y>=33 && y<36) {
    inc=0.3;
  }
  if (y>=36 && y<39) {
    inc=0.9;
  }
  if (y>=39 && y<42) {
    inc=1.4;
  }
  if (y>=42 && y<45) {
    inc=0.2;
  }
  if (y>=45 && y<48) {
    inc=0.2;
  }
  if (y>=48 && y<51) {
    inc=1.3;
  }
  if (y>=51 && y<54) {
    inc=1.6;
  }
  if (y>=54 && y<57) {
    inc=0.4;
  }
  if (y>=57 && y<60) {
    inc=1.3;
  }
  if (y>60 && y<63) {
    inc=0.2;
  }
  if (y>=63 && y<66) {
    inc=0.7;
  }
  if (y>=66 && y<69) {
    inc=0.3;
  }
  if (y>=69 && y<72) {
    inc=0.6;
  }
  if (y>=72 && y<75) {
    inc=1.6;
  }
  if (y>=75 && y<78) {
    inc=1.0;
  }
  if (y>=78 && y<81) {
    inc=0.6;
  }
  if (y>=81 && y<84) {
    inc=0.1;
  }
  if (y>=84 && y<87) {
    inc=0.4;
  }
  if (y>=87 && y<90) {
    inc=1.4;
  }
  if (y>=90 && y<93) {
    inc=0.2;
  }
  if (y>=93 && y<96) {
    inc=0.2;
  }
  if (y>=96 && y<99) {
    inc=0.7;
  }
  if (y>=99 && y<102) {
    inc=1.1;
  }
  if (y>=102 && y<105) {
    inc=0.3;
  }
  if (y>=105 && y<108) {
    inc=0.9;
  }
  if (y>=108 && y<111) {
    inc=1.4;
  }
  if (y>=111 && y<114) {
    inc=0.2;
  }
  if (y>=114 && y<117) {
    inc=0.2;
  }
  if (y>=117 && y<120) {
    inc=1.3;
  }
  if (y>=120 && y<123) {
    inc=1.6;
  }
  if (y>=123 && y<126) {
    inc=0.4;
  }
  if (y>=126 && y<129) {
    inc=1.1;
  }
  if (y>=129 && y<132) {
    inc=0.2;
  }
  if (y>=132 && y<135) {
    inc=0.8;
  }
  if (y>135 && y<138) {
    inc=0.4;
  }
  if (y>=138 && y<141) {
    inc=1.5;
  }
  if (y>=141 && y<144) {
    inc=0.1;
  }
  if (y>=144 && y<147) {
    inc=0.5;
  }
  if (y>=147 && y<150) {
    inc=1.3;
  }
  if (y>=150 && y<153) {
    inc=1.6;
  }
  if (y>=153 && y<156) {
    inc=0.9;
  }
  if (y>=156 && y<160) {
    inc=1.4;
  }

  if ((y>=0 && y<120) && (i == 0 || i ==1 || i==2)) {
    translate(x+int(mic1*inc), y, z);
    if (x+int(mic1*inc)>=cols) 
    {
      c=0;
    }
  }
  if ((y>=120 && y<160) && (i == 0 || i ==1 || i==2)) {
    translate(x-int(mic2*inc), y, z);
    if (x-int(mic2*inc)<=0) 
    {
      c=0;
    }
  }
  if ((y>=0 && y<80) && (i == 3|| i == 4 || i == 5)) {
    translate(x-int(mic2*inc), y, z);
    if (x-int(mic2*inc)<=0) 
    {
      c=0;
    }
  }
  if ((y>=80 && y<160) && (i == 3 || i ==4 || i==5)) {
    translate(x+int(mic3*inc), y, z);
    if (x+int(mic3*inc)>=cols) 
    {
      c=0;
    }
  }
  if ((y>=0 && y<40) && (i == 6 || i ==7 || i == 8)) {
    translate(x+int(mic3*inc), y, z);
    if (x+int(mic3*inc)>=cols) 
    {
      c=0;
    }
  }
  if ((y>=40 && y<160) && (i == 6|| i == 7 || i == 8)) {
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
  if (key == 's' && flag_generate_grid == true)
  {
    draw_red_target();
  }

  if (key == 'm' && flag_generate_grid == true)
  {
    move_grid();
  }

  if (key == 'o' && flag_generate_grid == true)
  {
    Ani.to(this, 1.0, "des_z", 700);
  }

  if (key == 'i' && flag_generate_grid == true)
  {
    Ani.to(this, 1.0, "des_z", 0);
  }

  if (key == 'r')
  {
    background(0);
    flag_activa_end = false;
    flag_generate_grid = false;
    flag_draw_triggers = true;
    flag_stop = true;
    flag_start_audios = true;
    player.rewind();
    player.play();
    player_f.rewind();
    audio_1.pause();
    audio_2.pause();
    audio_3.pause();
    audio_4.pause();
    audio_5.pause();
    audio_6.pause();
    for (int i=0; i<limite; i++) 
    {
      triggers.add(new Trigger_line(random(frame_width), random(frame_height)));
      //delay(int(random(2000)));
    }
  }
}

void draw_target(int i)
{
  noFill();
  stroke(255, 0, 0);
  strokeWeight(3);
  rectMode(CORNER);
  rect(pos_xy[index_orig.get(i)][0], pos_xy[index_orig.get(i)][1], cols, rows, 10);
}

void draw_new_target(int i)
{
  noStroke();
  fill(255, 0, 0, 100);
  rect(pos_xy[index_orig.get(i)][0], pos_xy[index_orig.get(i)][1], cols, rows);
}

void draw_red_target()
{
  pos_target++;
  if (pos_target < grid.length)
  {
    //draw_target(pos_target);
    draw_new_target(pos_target);
  } else {
    pos_target = 0;
    draw_new_target(pos_target);
    //draw_target(pos_target);
  }
}

void draw_black_grid()
{
  noFill();
  stroke(0, 0, 0);
  strokeWeight(13);
  rectMode(CORNER);
  for (int i=0; i<grid.length; i++)
  {
    rect(pos_xy[index_orig.get(i)][0], pos_xy[index_orig.get(i)][1], cols, rows, 10);
  }
}

void move_grid()
{
  if (pos_target == -1)
  {
    pos_target=0;
  }
  int a = pos_target;
  int b = pos_target + 1;
  int a_index = 0, b_index = 0;
  if (b == grid.length)
  {
    b=0;
  }
  for (int k=0; k<grid.length; k++)
  {
    if (a == index_shuffle.get(k))
    {
      a_index = k;
    }
    if (b == index_shuffle.get(k))
    {
      b_index = k;
    }
  }
  index_shuffle.set(a_index, b);
  index_shuffle.set(b_index, a);
  pos_target++;
  if (pos_target==grid.length)
  {
    pos_target=0;
  }
  println(index_shuffle);
}

void draw_green_screen()
{
  noStroke();
  fill(0, 180);
  rect(0, 0, frame_width, frame_height);
}
void oscEvent(OscMessage theOscMessage) {

  if (theOscMessage.checkAddrPattern("/mic1")==true) 
  {
    int firstValue = theOscMessage.get(0).intValue();  
    mic_1 = firstValue;

    if (flag_generate_grid == true || flag_activa_end == true)
    {
      if (flag_start_audios == true)
      {
        audio_1.loop();
        audio_2.loop();
        audio_3.loop();
        flag_start_audios =false;
      }

      vol_audio_1 = audio_1.getGain();
      vol_audio_2 = audio_2.getGain();
      vol_audio_3 = audio_3.getGain();

      if (mic_1>=0 && mic_1<100)
      {
        audio_1.shiftGain(vol_audio_1, 13, 1000);
        audio_2.shiftGain(vol_audio_2, -50, 1000);
        audio_3.shiftGain(vol_audio_3, -50, 1000);
      }

      if (mic_1>=100 && mic_1<200)
      {
        audio_1.shiftGain(vol_audio_1, -50, 1000);
        audio_2.shiftGain(vol_audio_2, 13, 1000);
        audio_3.shiftGain(vol_audio_3, -50, 1000);
      }

      if (mic_1>=200 && mic_1<300)
      {
        audio_1.shiftGain(vol_audio_1, -50, 1000);
        audio_2.shiftGain(vol_audio_2, -50, 1000);
        audio_3.shiftGain(vol_audio_3, 13, 1000);
      }
    }
  } 
  if (theOscMessage.checkAddrPattern("/mic2")==true) 
  {
    int firstValue = theOscMessage.get(0).intValue();  
    mic_2 = firstValue;

    if (flag_generate_grid == true || flag_activa_end == true)
    {
      if (flag_start_audios == true)
      {
        audio_4.loop();
        audio_5.loop();
        audio_6.loop();
        flag_start_audios =false;
      }

      vol_audio_4 = audio_4.getGain();
      vol_audio_5 = audio_5.getGain();
      vol_audio_6 = audio_6.getGain();

      if (mic_2>=0 && mic_2<100)
      {
        audio_4.shiftGain(vol_audio_4, 13, 1000);
        audio_5.shiftGain(vol_audio_5, -50, 1000);
        audio_6.shiftGain(vol_audio_6, -50, 1000);
      }

      if (mic_2>=100 && mic_2<200)
      {
        audio_4.shiftGain(vol_audio_4, -50, 1000);
        audio_5.shiftGain(vol_audio_5, 13, 1000);
        audio_6.shiftGain(vol_audio_6, -50, 1000);
      }

      if (mic_2>=200 && mic_2<300)
      {
        audio_4.shiftGain(vol_audio_4, -50, 1000);
        audio_5.shiftGain(vol_audio_5, -50, 1000);
        audio_6.shiftGain(vol_audio_6, 13, 1000);
      }
    }
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
  if (theOscMessage.checkAddrPattern("/x_shimmer")==true)
  {
    float value = theOscMessage.get(0).floatValue();
    x_shimmer = value;
  }
  if (theOscMessage.checkAddrPattern("/y_shimmer")==true)
  {
    float value = theOscMessage.get(0).floatValue();
    y_shimmer = value;

    if (y_shimmer > 0 && flag_draw_red_target == true && flag_generate_grid == true)
    {
      flag_draw_red_target = false;
    }
    if (y_shimmer < 0 && flag_draw_red_target == false)
    {
      flag_draw_red_target = true;
    }
  }
  if (theOscMessage.checkAddrPattern("/z_shimmer")==true)
  {
    float value = theOscMessage.get(0).floatValue();
    z_shimmer = value;

    if (z_shimmer > 0 && flag_move_grid == true && flag_generate_grid == true)
    {
      move_grid();
      flag_move_grid = false;
    } 
    if (z_shimmer < 0 && flag_move_grid == false)
    {
      flag_move_grid = true;
    }
  }

  if (theOscMessage.checkAddrPattern("/pulse_shimmer")==true)
  {
    float value = theOscMessage.get(0).floatValue();
    pulse_shimmer = value;
  }
}

void draw_white_lines() {
  int mul=3;
  strokeWeight(random(1, 3));
  if (c0 <= h ) {
    c0 -= random(1, 10)*mul;
  }
  if (c0 < 0) {
    c0 = h;
  }
  stroke(21, 200, 6);
  line(0, c0, w, c0);

  if (c1 <= h ) {
    c1 -= random(1, 10)*mul;
  }
  if (c1 < 0) {
    c1 = h;
  }
  stroke(21, 200, 6);
  line(w, c1, w+w, c1);

  if (c2 <= h ) {
    c2 -= random(1, 10)*mul;
  }
  if (c2 < 0) {
    c2 = h;
  }
  stroke(21, 200, 6);
  line(w+w, c2, w+w+w, c2);

  if (c3 <= h+h ) {
    c3 -= random(0, 10)*mul;
  }
  if (c3 < h) {
    c3 = h+h;
  }
  stroke(21, 200, 6);
  line(0, c3, w, c3);

  if (c4 <= h+h ) {
    c4 -= random(0, 10)*mul;
  }
  if (c4 < h) {
    c4 = h+h;
  }
  stroke(21, 200, 6);
  line(w, c4, w+w, c4);

  if (c5 <= h+h ) {
    c5 -= random(0, 10)*mul;
  }
  if (c5 < h) {
    c5 = h+h;
  }
  stroke(21, 200, 6);
  line(w+w, c5, w+w+w, c5);

  if (c6 <= h+h+h ) {
    c6 -= random(0, 10)*mul;
  }
  if (c6 < h+h) {
    c6 = h+h+h;
  }
  stroke(21, 200, 6);
  line(0, c6, w, c6);

  if (c7 <= h+h+h ) {
    c7 -= random(0, 10)*mul;
  }
  if (c7 < h+h) {
    c7 = h+h+h;
  }
  stroke(21, 200, 6);
  line(w, c7, w+w, c7);

  if (c8 <= h+h+h ) {
    c8 -= random(0, 10)*mul;
  }
  if (c8 < h+h) {
    c8 = h+h+h;
  }
  stroke(21, 200, 6);
  line(w+w, c8, w+w+w, c8);
}
