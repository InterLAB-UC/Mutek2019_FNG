int NB_FRAMES = 40;

int w = 500;
int h = 500;

int scl = 1;

int cols,rows;

float contrast(float val){
  return (1.0-cos(PI*val))/2.0;
}

float kcontrast(float val,float k){
  for(int i=0;i<k;i++){
    val = contrast(val);
  }
  return val;
}

void setup() {
  noiseSeed(6);
  
  size(500, 500);
  cols = w / scl;
  rows = h/ scl;
}


void draw() {
  
  float t = 1.0*(frameCount % NB_FRAMES)/NB_FRAMES;
  
  //println(t);

  background(0);
  noStroke();
  fill(255);

  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      int xx = x*scl;
      int yy = y*scl;
      
      float nx = map(x,0,cols,0,1);
      float ny = map(y,0,rows,0,2);
      
      float ns = noise(nx,ny);
      
      float col = 255.0/2+255.0/2*sin(TWO_PI*t + 200*ns);
      
      float col2 = col>255/2?255:0;
      
      float col3 = kcontrast(col/255.0,2)*255;
      
      float scl2 = floor(map(col,0,255,0,scl+1));
      
      //fill(col2);
      fill(col3);
      //stroke(255);
      
      //rect(x*scl+floor((scl-scl2+1)/2), y*scl+floor((scl-scl2+1)/2), scl2, scl2);
      rect(x*scl,y*scl,1,1);
    }
  }/*
  if(frameCount<=NB_FRAMES){
    saveFrame("test11-#####.png");
  }*/
  
  
}
