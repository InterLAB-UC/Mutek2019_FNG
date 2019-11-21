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
int cols, rows;
int xx=0, yy=0, zz=00;
boolean flag_circle = false;
int loc, loc_des;
IntList index, index_orig;
int pos_xy[][] = {{0, 0}, {213, 0}, {426, 0}, {0, 160}, {213, 160}, {426, 160}, {0, 320}, {213, 320}, {426, 320}};

//Variable para capturar el video
Capture video;
Minim minim, minim_f;
AudioPlayer player, player_f;

Cirlce[] cirlces = new Cirlce[20];

color from = color(255, 8, 8);
color to = color(8, 187, 255);

void setup() {  
  //size(1280, 720);  
  size(640, 480);
  background(255);
  String[] cameras = Capture.list();
  //printArray(cameras);
  //video = new Capture(this, cameras[0]);
  video = new Capture(this, width, height);
  cols = width;
  rows = height;

  println("Resolución de video: " + cols + "x" + rows);

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

  for (int i=0; i<limite; i++) 
  {
    triggers.add(new Trigger_line(random(width), random(height)));
    delay(int(random(2000)));
  }

  minim = new Minim(this);
  player = minim.loadFile("final.mp3");
  player.play();

  minim_f = new Minim(this);
  player_f = minim.loadFile("final.mp3");

  Ani.init(this);

  for (int i=0; i<cirlces.length; i++) {
    cirlces[i] = new Cirlce();
  }
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
    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++ ) {
        update_grids(x, y);
      }
    }

    for (int i = 0; i < grid.length; i++)
    {
      grid[i].updatePixels();
    }

    //display_grid();
    display_grid_random();
    if (flag_circle == true)
    {
      smooth();
      noStroke();
      for (int i=0; i<cirlces.length; i++) cirlces[i].draw();
    }
  }
}
void mouseReleased() {
  flag_circle = true;
}

void keyPressed()
{
  flag_circle =false;
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
  //Grid01
  loc = x + y * cols;

  if (x>=0 && x<213 && y>=0 && y<160)
  {
    loc_des = x + y * (cols/3);
    grid[0].pixels[loc_des] =video.pixels[loc];


    float inc = 0;
    if (y>=0 && y<10)
    { 
      inc = 0.9;
      if (int(mouseX*inc)>x)
      {
        grid[0].pixels[loc_des] = video.pixels[loc+mouseX];
      }
    }
    if (y>=10 && y<20)
    { 
      inc = 0.1;
      if (int(mouseX*inc)>x)
      {
        grid[0].pixels[loc_des] = video.pixels[loc];
      }
    }
    if (y>=20 && y<30)
    { 
      inc = 0.1;
      if (int(mouseX*inc)>x)
      {
        grid[0].pixels[loc_des] = video.pixels[loc+mouseX];
      }
    }
    if (y>=30 && y<40)
    { 
      inc = 1.2;
      if (int(mouseX*inc)>x)
      {
        grid[0].pixels[loc_des] = video.pixels[loc];
      }
    }
    if (y>=40 && y<50)
    { 
      inc = 1.3;
      if (int(mouseX*inc)>x)
      {
        grid[0].pixels[loc_des] = video.pixels[loc+mouseX];;
      }
    }
    if (y>=50 && y<60)
    { 
      inc = random(0,1.5);
      if (int(mouseX*inc)>x)
      {
        grid[0].pixels[loc_des] = 0;
      }
    }
    if (y>=60 && y<70)
    { 
      inc = random(0,1.5);
      if (int(mouseX*inc)>x)
      {
        grid[0].pixels[loc_des] = 0;
      }
    }
    if (y>=70 && y<80)
    { 
      inc = random(0,1.5);
      if (int(mouseX*inc)>x)
      {
        grid[0].pixels[loc_des] = 0;
      }
    }
    if (y>=80 && y<90)
    { 
      inc = random(0,1.5);
      if (int(mouseX*inc)>x)
      {
        grid[0].pixels[loc_des] = 0;
      }
    }
    if (y>=90 && y<100)
    { 
      inc = random(0,1.5);
      if (int(mouseX*inc)>x)
      {
        grid[0].pixels[loc_des] = 0;
      }
    }
    if (y>=100 && y<110)
    { 
      inc = random(0,1.5);
      if (int(mouseX*inc)>x)
      {
        grid[0].pixels[loc_des] = 0;
      }
    }
    if (y>=110 && y<120)
    { 
      inc = random(0,1.5);
      if (int(mouseX*inc)>x)
      {
        grid[0].pixels[loc_des] = 0;
      }
    }
  }

  //Grid02
  if (x>=213 && x<426 && y>=0 && y<160)
  {
    loc_des = (x-213) + (y) * (cols/3);
    grid[1].pixels[loc_des] = video.pixels[loc];

    float inc = 0;
    if (y>=0 && y<10)
    { 
      inc = 1.2;
      if (int(mouseX*inc)>x)
      {
        grid[1].pixels[loc_des] = 0;
      }
    }
    if (y>=10 && y<20)
    { 
      inc = 0.1;
      if (int(mouseX*inc)>x)
      {
        grid[1].pixels[loc_des] = 0;
      }
    }
    if (y>=20 && y<30)
    { 
      inc = 0.8;
      if (int(mouseX*inc)>x)
      {
        grid[1].pixels[loc_des] = 0;
      }
    }
    if (y>=30 && y<40)
    { 
      inc = 0.4;
      if (int(mouseX*inc)>x)
      {
        grid[1].pixels[loc_des] = 0;
      }
    }
    if (y>=40 && y<50)
    { 
      inc = 0.6;
      if (int(mouseX*inc)>x)
      {
        grid[1].pixels[loc_des] = 0;
      }
    }
    if (y>=50 && y<60)
    { 
      inc = 1.2;
      if (int(mouseX*inc)>x)
      {
        grid[1].pixels[loc_des] = 0;
      }
    }
    if (y>=60 && y<70)
    { 
      inc = 0.9;
      if (int(mouseX*inc)>x)
      {
        grid[1].pixels[loc_des] = 0;
      }
    }
    if (y>=70 && y<80)
    { 
      inc = 0.3;
      if (int(mouseX*inc)>x)
      {
        grid[1].pixels[loc_des] = 0;
      }
    }
    if (y>=80 && y<90)
    { 
      inc = 1.0;
      if (int(mouseX*inc)>x)
      {
        grid[1].pixels[loc_des] = 0;
      }
    }
    if (y>=90 && y<100)
    { 
      inc = 0.3;
      if (int(mouseX*inc)>x)
      {
        grid[1].pixels[loc_des] = 0;
      }
    }
    if (y>=100 && y<110)
    { 
      inc = 0.9;
      if (int(mouseX*inc)>x)
      {
        grid[1].pixels[loc_des] = 0;
      }
    }
    if (y>=110 && y<120)
    { 
      inc = 0.2;
      if (int(mouseX*inc)>x)
      {
        grid[1].pixels[loc_des] = 0;
      }
    }
  }

  //Grid03
  if (x>=426 && x<639 && y>=0 && y<160)
  {
    loc_des = (x-426) + (y) * (cols/3);
    grid[2].pixels[loc_des] = video.pixels[loc];

    float inc = 0;
    if (y>=0 && y<10)
    { 
      inc = 1.2;
      if (int(mouseX*inc)>x)
      {
        grid[2].pixels[loc_des] = 0;
      }
    }
    if (y>=10 && y<20)
    { 
      inc = 1.0;
      if (int(mouseX*inc)>x)
      {
        grid[2].pixels[loc_des] = 0;
      }
    }
    if (y>=20 && y<30)
    { 
      inc = 1.5;
      if (int(mouseX*inc)>x)
      {
        grid[2].pixels[loc_des] = 0;
      }
    }
    if (y>=30 && y<40)
    { 
      inc = 1.9;
      if (int(mouseX*inc)>x)
      {
        grid[2].pixels[loc_des] = 0;
      }
    }
    if (y>=40 && y<50)
    { 
      inc = 1.3;
      if (int(mouseX*inc)>x)
      {
        grid[2].pixels[loc_des] = 0;
      }
    }
    if (y>=50 && y<60)
    { 
      inc = 1.6;
      if (int(mouseX*inc)>x)
      {
        grid[2].pixels[loc_des] = 0;
      }
    }
    if (y>=60 && y<70)
    { 
      inc = 1.3;
      if (int(mouseX*inc)>x)
      {
        grid[2].pixels[loc_des] = 0;
      }
    }
    if (y>=70 && y<80)
    { 
      inc = 1.4;
      if (int(mouseX*inc)>x)
      {
        grid[2].pixels[loc_des] = 0;
      }
    }
    if (y>=80 && y<90)
    { 
      inc = 1.7;
      if (int(mouseX*inc)>x)
      {
        grid[2].pixels[loc_des] = 0;
      }
    }
    if (y>=90 && y<100)
    { 
      inc = 1.8;
      if (int(mouseX*inc)>x)
      {
        grid[2].pixels[loc_des] = 0;
      }
    }
    if (y>=100 && y<110)
    { 
      inc = 1.2;
      if (int(mouseX*inc)>x)
      {
        grid[2].pixels[loc_des] = 0;
      }
    }
    if (y>=110 && y<120)
    { 
      inc = 1.1;
      if (int(mouseX*inc)>x)
      {
        grid[2].pixels[loc_des] = 0;
      }
    }
  }

  //Grid04
  if (x>=0 && x<213 && y>=160 && y<320)
  {
    loc_des = (x) + (y-160) * (cols/3);
    grid[3].pixels[loc_des] = video.pixels[loc];

    float inc = 0;
    if (y>=160 && y<170)
    { 
      inc = 1.2;
      if (int(mouseX*inc)>x)
      {
        grid[3].pixels[loc_des] = 0;
      }
    }
    if (y>=170 && y<180)
    { 
      inc = 1.1;
      if (int(mouseX*inc)>x)
      {
        grid[3].pixels[loc_des] = 0;
      }
    }
    if (y>=180 && y<190)
    { 
      inc = 1.0;
      if (int(mouseX*inc)>x)
      {
        grid[3].pixels[loc_des] = 0;
      }
    }
    if (y>=190 && y<200)
    { 
      inc = 0.9;
      if (int(mouseX*inc)>x)
      {
        grid[3].pixels[loc_des] = 0;
      }
    }
    if (y>=200 && y<210)
    { 
      inc = 0.8;
      if (int(mouseX*inc)>x)
      {
        grid[3].pixels[loc_des] = 0;
      }
    }
    if (y>=210 && y<220)
    { 
      inc = 0.7;
      if (int(mouseX*inc)>x)
      {
        grid[3].pixels[loc_des] = 0;
      }
    }
    if (y>=220 && y<230)
    { 
      inc = 0.6;
      if (int(mouseX*inc)>x)
      {
        grid[3].pixels[loc_des] = 0;
      }
    }
    if (y>=230 && y<240)
    { 
      inc = 0.5;
      if (int(mouseX*inc)>x)
      {
        grid[3].pixels[loc_des] = 0;
      }
    }
    if (y>=240 && y<250)
    { 
      inc = 0.4;
      if (int(mouseX*inc)>x)
      {
        grid[3].pixels[loc_des] = 0;
      }
    }
    if (y>=250 && y<260)
    { 
      inc = 0.3;
      if (int(mouseX*inc)>x)
      {
        grid[3].pixels[loc_des] = 0;
      }
    }
    if (y>=260 && y<270)
    { 
      inc = 0.2;
      if (int(mouseX*inc)>x)
      {
        grid[3].pixels[loc_des] = 0;
      }
    }
    if (y>=270 && y<280)
    { 
      inc = 0.1;
      if (int(mouseX*inc)>x)
      {
        grid[3].pixels[loc_des] = 0;
      }
    }
  }

  //Grid05
  if (x>=213 && x<426 && y>=160 && y<320)
  {
    loc_des = (x-213) + (y-160) * (cols/3);
    grid[4].pixels[loc_des] = video.pixels[loc];

    float inc = 0;
    if (y>=160 && y<170)
    { 
      inc = 1.2;
      if (int(mouseX*inc)>x)
      {
        grid[4].pixels[loc_des] = 0;
      }
    }
    if (y>=170 && y<180)
    { 
      inc = 1.1;
      if (int(mouseX*inc)>x)
      {
        grid[4].pixels[loc_des] = 0;
      }
    }
    if (y>=180 && y<190)
    { 
      inc = 1.0;
      if (int(mouseX*inc)>x)
      {
        grid[4].pixels[loc_des] = 0;
      }
    }
    if (y>=190 && y<200)
    { 
      inc = 0.9;
      if (int(mouseX*inc)>x)
      {
        grid[4].pixels[loc_des] = 0;
      }
    }
    if (y>=200 && y<210)
    { 
      inc = 0.8;
      if (int(mouseX*inc)>x)
      {
        grid[4].pixels[loc_des] = 0;
      }
    }
    if (y>=210 && y<220)
    { 
      inc = 0.7;
      if (int(mouseX*inc)>x)
      {
        grid[4].pixels[loc_des] = 0;
      }
    }
    if (y>=220 && y<230)
    { 
      inc = 0.6;
      if (int(mouseX*inc)>x)
      {
        grid[4].pixels[loc_des] = 0;
      }
    }
    if (y>=230 && y<240)
    { 
      inc = 0.5;
      if (int(mouseX*inc)>x)
      {
        grid[4].pixels[loc_des] = 0;
      }
    }
    if (y>=240 && y<250)
    { 
      inc = 0.4;
      if (int(mouseX*inc)>x)
      {
        grid[4].pixels[loc_des] = 0;
      }
    }
    if (y>=250 && y<260)
    { 
      inc = 0.3;
      if (int(mouseX*inc)>x)
      {
        grid[4].pixels[loc_des] = 0;
      }
    }
    if (y>=260 && y<270)
    { 
      inc = 0.2;
      if (int(mouseX*inc)>x)
      {
        grid[4].pixels[loc_des] = 0;
      }
    }
    if (y>=270 && y<280)
    { 
      inc = 0.1;
      if (int(mouseX*inc)>x)
      {
        grid[4].pixels[loc_des] = 0;
      }
    }
  }

  //Grid06
  if (x>=426 && x<639 && y>=160 && y<320)
  {
    loc_des = (x-426) + (y-160) * (cols/3);
    grid[5].pixels[loc_des] = video.pixels[loc];
    float inc = 0;
    if (y>=160 && y<170)
    { 
      inc = 1.2;
      if (int(mouseX*inc)>x)
      {
        grid[5].pixels[loc_des] = 0;
      }
    }
    if (y>=170 && y<180)
    { 
      inc = 1.1;
      if (int(mouseX*inc)>x)
      {
        grid[5].pixels[loc_des] = 0;
      }
    }
    if (y>=180 && y<190)
    { 
      inc = 1.0;
      if (int(mouseX*inc)>x)
      {
        grid[5].pixels[loc_des] = 0;
      }
    }
    if (y>=190 && y<200)
    { 
      inc = 0.9;
      if (int(mouseX*inc)>x)
      {
        grid[5].pixels[loc_des] = 0;
      }
    }
    if (y>=200 && y<210)
    { 
      inc = 0.8;
      if (int(mouseX*inc)>x)
      {
        grid[5].pixels[loc_des] = 0;
      }
    }
    if (y>=210 && y<220)
    { 
      inc = 0.7;
      if (int(mouseX*inc)>x)
      {
        grid[5].pixels[loc_des] = 0;
      }
    }
    if (y>=220 && y<230)
    { 
      inc = 0.6;
      if (int(mouseX*inc)>x)
      {
        grid[5].pixels[loc_des] = 0;
      }
    }
    if (y>=230 && y<240)
    { 
      inc = 0.5;
      if (int(mouseX*inc)>x)
      {
        grid[5].pixels[loc_des] = 0;
      }
    }
    if (y>=240 && y<250)
    { 
      inc = 0.4;
      if (int(mouseX*inc)>x)
      {
        grid[5].pixels[loc_des] = 0;
      }
    }
    if (y>=250 && y<260)
    { 
      inc = 0.3;
      if (int(mouseX*inc)>x)
      {
        grid[5].pixels[loc_des] = 0;
      }
    }
    if (y>=260 && y<270)
    { 
      inc = 0.2;
      if (int(mouseX*inc)>x)
      {
        grid[5].pixels[loc_des] = 0;
      }
    }
    if (y>=270 && y<280)
    { 
      inc = 0.1;
      if (int(mouseX*inc)>x)
      {
        grid[5].pixels[loc_des] = 0;
      }
    }
  }

  //Grid07
  if (x>=0 && x<213 && y>=320 && y<480)
  {
    loc_des = (x) + (y-320) * (cols/3);
    grid[6].pixels[loc_des] = video.pixels[loc];

    float inc = 0;
    if (y>=320 && y<330)
    { 
      inc = 1.2;
      if (int(mouseX*inc)>x)
      {
        grid[6].pixels[loc_des] = 0;
      }
    }
    if (y>=330 && y<340)
    { 
      inc = 1.1;
      if (int(mouseX*inc)>x)
      {
        grid[6].pixels[loc_des] = 0;
      }
    }
    if (y>=340 && y<350)
    { 
      inc = 1.0;
      if (int(mouseX*inc)>x)
      {
        grid[6].pixels[loc_des] = 0;
      }
    }
    if (y>=350 && y<360)
    { 
      inc = 0.9;
      if (int(mouseX*inc)>x)
      {
        grid[6].pixels[loc_des] = 0;
      }
    }
    if (y>=360 && y<370)
    { 
      inc = 0.8;
      if (int(mouseX*inc)>x)
      {
        grid[6].pixels[loc_des] = 0;
      }
    }
    if (y>=370 && y<380)
    { 
      inc = 0.7;
      if (int(mouseX*inc)>x)
      {
        grid[6].pixels[loc_des] = 0;
      }
    }
    if (y>=380 && y<390)
    { 
      inc = 0.6;
      if (int(mouseX*inc)>x)
      {
        grid[6].pixels[loc_des] = 0;
      }
    }
    if (y>=390 && y<400)
    { 
      inc = 0.5;
      if (int(mouseX*inc)>x)
      {
        grid[6].pixels[loc_des] = 0;
      }
    }
    if (y>=400 && y<410)
    { 
      inc = 0.4;
      if (int(mouseX*inc)>x)
      {
        grid[6].pixels[loc_des] = 0;
      }
    }
    if (y>=410 && y<420)
    { 
      inc = 0.3;
      if (int(mouseX*inc)>x)
      {
        grid[6].pixels[loc_des] = 0;
      }
    }
    if (y>=420 && y<430)
    { 
      inc = 0.2;
      if (int(mouseX*inc)>x)
      {
        grid[6].pixels[loc_des] = 0;
      }
    }
    if (y>=430 && y<440)
    { 
      inc = 0.1;
      if (int(mouseX*inc)>x)
      {
        grid[6].pixels[loc_des] = 0;
      }
    }
  }

  //Grid08
  if (x>=213 && x<426 && y>=320 && y<480)
  {
    loc_des = (x-213) + (y-320) * (cols/3);
    grid[7].pixels[loc_des] = video.pixels[loc];

    float inc = 0;
    if (y>=320 && y<330)
    { 
      inc = 1.2;
      if (int(mouseX*inc)>x)
      {
        grid[7].pixels[loc_des] = 0;
      }
    }
    if (y>=330 && y<340)
    { 
      inc = 1.1;
      if (int(mouseX*inc)>x)
      {
        grid[7].pixels[loc_des] = 0;
      }
    }
    if (y>=340 && y<350)
    { 
      inc = 1.0;
      if (int(mouseX*inc)>x)
      {
        grid[7].pixels[loc_des] = 0;
      }
    }
    if (y>=350 && y<360)
    { 
      inc = 0.9;
      if (int(mouseX*inc)>x)
      {
        grid[7].pixels[loc_des] = 0;
      }
    }
    if (y>=360 && y<370)
    { 
      inc = 0.8;
      if (int(mouseX*inc)>x)
      {
        grid[7].pixels[loc_des] = 0;
      }
    }
    if (y>=370 && y<380)
    { 
      inc = 0.7;
      if (int(mouseX*inc)>x)
      {
        grid[7].pixels[loc_des] = 0;
      }
    }
    if (y>=380 && y<390)
    { 
      inc = 0.6;
      if (int(mouseX*inc)>x)
      {
        grid[7].pixels[loc_des] = 0;
      }
    }
    if (y>=390 && y<400)
    { 
      inc = 0.5;
      if (int(mouseX*inc)>x)
      {
        grid[7].pixels[loc_des] = 0;
      }
    }
    if (y>=400 && y<410)
    { 
      inc = 0.4;
      if (int(mouseX*inc)>x)
      {
        grid[7].pixels[loc_des] = 0;
      }
    }
    if (y>=410 && y<420)
    { 
      inc = 0.3;
      if (int(mouseX*inc)>x)
      {
        grid[7].pixels[loc_des] = 0;
      }
    }
    if (y>=420 && y<430)
    { 
      inc = 0.2;
      if (int(mouseX*inc)>x)
      {
        grid[7].pixels[loc_des] = 0;
      }
    }
    if (y>=430 && y<440)
    { 
      inc = 0.1;
      if (int(mouseX*inc)>x)
      {
        grid[7].pixels[loc_des] = 0;
      }
    }
  }

  //Grid09
  if (x>=426 && x<639 && y>=320 && y<480)
  {
    loc_des = (x-426) + (y-320) * (cols/3);
    grid[8].pixels[loc_des] = video.pixels[loc];

    float inc = 0;
    if (y>=320 && y<330)
    { 
      inc = 0.9;
      if (int(mouseX*inc)>x)
      {
        grid[8].pixels[loc_des] = 0;
      }
    }
    if (y>=330 && y<340)
    { 
      inc = 0.8;
      if (int(mouseX*inc)>x)
      {
        grid[8].pixels[loc_des] = 0;
      }
    }
    if (y>=340 && y<350)
    { 
      inc = 1.5;
      if (int(mouseX*inc)>x)
      {
        grid[8].pixels[loc_des] = 0;
      }
    }
    if (y>=350 && y<360)
    { 
      inc = 1.2;
      if (int(mouseX*inc)>x)
      {
        grid[8].pixels[loc_des] = 0;
      }
    }
    if (y>=360 && y<370)
    { 
      inc = 1.3;
      if (int(mouseX*inc)>x)
      {
        grid[8].pixels[loc_des] = 0;
      }
    }
    if (y>=370 && y<380)
    { 
      inc = 1.8;
      if (int(mouseX*inc)>x)
      {
        grid[8].pixels[loc_des] = 0;
      }
    }
    if (y>=380 && y<390)
    { 
      inc = 1.6;
      if (int(mouseX*inc)>x)
      {
        grid[8].pixels[loc_des] = 0;
      }
    }
    if (y>=390 && y<400)
    { 
      inc = 1.1;
      if (int(mouseX*inc)>x)
      {
        grid[8].pixels[loc_des] = 0;
      }
    }
    if (y>=400 && y<410)
    { 
      inc = 1.4;
      if (int(mouseX*inc)>x)
      {
        grid[8].pixels[loc_des] = 0;
      }
    }
    if (y>=410 && y<420)
    { 
      inc = 2.0;
      if (int(mouseX*inc)>x)
      {
        grid[8].pixels[loc_des] = 0;
      }
    }
    if (y>=420 && y<430)
    { 
      inc = 1.9;
      if (int(mouseX*inc)>x)
      {
        grid[8].pixels[loc_des] = 0;
      }
    }
    if (y>=430 && y<440)
    { 
      inc = 1.1;
      if (int(mouseX*inc)>x)
      {
        grid[8].pixels[loc_des] = 0;
      }
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
    image(grid[i], pos_xy[index.get(i)][0], pos_xy[index.get(i)][1]);
  }
}

void highlight_pixel(int x, int y) {
  color c = video.get(x, y);
  float b = brightness(c);
  b = map(b, 0, 255, 100, 50);
  smooth();
  fill(c);
  //noStroke();
  pushMatrix();
  translate(x, y, zz);
  ellipse(xx, yy, b, b+2);
  popMatrix();
  /*
  int loc = x+y*(cols/3);
   float r = red(video.pixels[loc]);
   float g = green(video.pixels[loc]);
   float b = blue(video.pixels[loc]);
   noStroke();
   
   // Draw an ellipse at that location with that color
   fill(r, g, b, 500);
   ellipse(x, y, 50, 50);*/
}

class Cirlce {
  float x = random(0, width);
  float y = random(0, height);
  int diameter = 3;
  Ani diameterAni;
  color c = color(0);

  Cirlce() {
    // diameter animation
    diameterAni = new Ani(this, random(1, 3), 0.5, "diameter", 50, Ani.EXPO_IN_OUT, "onEnd:randomize");
    // repeat yoyo style (go up and down)
    diameterAni.setPlayMode(Ani.YOYO);
    // repeat 3 times
    diameterAni.repeat(3);
  }

  void draw() {
    fill(c);
    ellipse(x, y, diameter, diameter);
    //fill(0);
    //text(diameterAni.getRepeatNumber()+" / "+diameterAni.getRepeatCount(), x, y+diameter);
  }

  void randomize(Ani _ani) {
    c = lerpColor(from, to, random(1));

    // new repeat count
    int newCount = 1+2*round(random(4));
    diameterAni.repeat(newCount);
    // restart
    diameterAni.start();

    // move to new position
    Ani.to(this, 0.8, "x", random(0, width), Ani.EXPO_IN_OUT);
    Ani.to(this, 0.8, "y", random(0, height), Ani.EXPO_IN_OUT);
  }
}
