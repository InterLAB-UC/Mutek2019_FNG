void trigger(float x, float y, color c, float message, String name){
 
  float lar = 250 + message;
  fill(c);
  noStroke();
  ellipse(x,y,lar,lar);
  fill(0);
    textSize(20);
  text(name,x,y);
  //HH.trigger();

}

void triggerHH(float x, float y, color c, float message, String name){
  float lar = 250 + (message * 100);
  fill(c);
  noStroke();
  ellipse(x,y,lar,lar);
  fill(0);
  textSize(20);
  text(name,x,y);
  if(message > 0.5){
  HH.trigger();
  }
}

void triggerChord(float x, float y, color c, float message, String name){
 
 float lar = 250 + (message * 100);
  fill(c);
  noStroke();
  ellipse(x,y,lar,lar);
  fill(0);
  textSize(20);
  text(name,x,y);
  if(message > 0.5) Chord.trigger();
}

void triggerClap(float x, float y, color c, float message, String name){
  
 float lar = 250 + (message * 100);
  fill(c);
  noStroke();
  ellipse(x,y,lar,lar);
  fill(0);
  textSize(20);
  text(name,x,y);
  if(message > 0.5)Clap.trigger();
}

void triggerKick(float x, float y, color c, float message, String name){
  
  float lar = 250 + (message * 100);
  fill(c);
  noStroke();
  ellipse(x,y,lar,lar);
  fill(0);
  textSize(20);
  text(name,x,y);
 if(message > 0.5) Kick.trigger();
}


void triggerKick2(float x, float y, color c, float message, String name){
  
  float lar = 250 + (message * 100);
  fill(c);
  noStroke();
  ellipse(x,y,lar,lar);
  textSize(20);
  text(name,x,y);
 if(message > 0.5) kick2.trigger();
}


void triggerWater(float x, float y, color c, float message, String name){
  
   float lar = 250 + (message * 100);
  fill(c);
  noStroke();
  ellipse(x,y,lar,lar);
  fill(0);
  textSize(20);
  text(name,x,y);
  Water.trigger();
}
