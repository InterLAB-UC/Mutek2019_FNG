import ddf.minim.*;

AudioPlayer player;
Minim minim;

boolean fading = false;

void setup() {
  size(400, 300, P2D);
  minim = new Minim(this);
  player = minim.loadFile("audio_3.mp3");
  player.loop();
}


void draw() {
  background(255);
  stroke(0);
  line(100,0,100,height);
  stroke(0);
  line(300,0,300,height);
  
  float currentVolume = player.getGain();
  
  fill(0);
  if (mouseX > 300 && !fading) {
    player.shiftGain(currentVolume,13,1000); 
    fading = true;
  } else if (mouseX < 100 && !fading) {
    player.shiftGain(currentVolume,-50,1000);
    fading = true;
  } else if (mouseX > 100 && mouseX < 300) {
    fading = false; 
  }
  
  float h = map(player.getGain(),-80,13,0,height/2);
  rect(width/2-10,height-h,20,h);
  
  textAlign(CENTER);
  text("fade down",50,50);
  text("fade up",350,50);
  
  
}
