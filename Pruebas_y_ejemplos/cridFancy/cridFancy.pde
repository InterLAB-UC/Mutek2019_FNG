int w = 213;
int h = 160;
int c0, c1, c2, c3, c4, c5, c6, c7, c8;

void setup() {
  size(640, 480);

  c0 = h;
  c1 = h;
  c2 = h;
  c3 = h+h;
  c4 = h+h;
  c5 = h+h;
  c6 = height;
  c7 = height;
  c8 = height;
  //cam.start();
}

void draw() {

  lineas();
  noStroke();
  fill(21, 196, 6, 100);
  rect(0, 0, width, height);
  gridFancy();
}

void gridFancy() {
  noFill();
  stroke(0);
  strokeWeight(5);
  rect(0, 0, w, h);
  rect(w, 0, w, h);
  rect(w+w, 0, w, h);
  rect(0, h, w, h);
  rect(w, h, w, h);
  rect(w+w, h, w, h);
  rect(0, h+h, w, h);
  rect(w, h+h, w, h);
  rect(w+w, h+h, w, h);
}

void lineas() {
  strokeWeight(random(1, 3));
  if (c0 <= h ) {
    c0 -= 10;
  }
  if (c0 == 0) {
    c0 = h;
  }
  stroke(255);
  line(0, c0, w, c0);
  if (c1 <= h ) {
    c1 -= random(1, 10);
  }
  if (c1 < 0) {
    c1 = h;
  }
  stroke(255);
  line(w, c1, w+w, c1);
  if (c2 <= h ) {
    c2 -= random(1, 10);
  }
  if (c2 < 0) {
    c2 = h;
  }
  stroke(255);
  line(w+w, c2, width, c2);
  if (c3 <= h+h ) {
    c3 -= random(0, 10);
  }
  if (c3 < h) {
    c3 = h+h;
  }
  stroke(255);
  line(0, c3, w, c3);
  if (c4 <= h+h ) {
    c4 -= random(0, 10);
  }
  if (c4 < h) {
    c4 = h+h;
  }
  stroke(255);
  line(w, c4, w+w, c4);
  if (c5 <= h+h ) {
    c5 -= random(0, 10);
  }
  if (c5 < h) {
    c5 = h+h;
  }
  stroke(255);
  line(w+w, c5, width, c5);

  if (c6 <= height ) {
    c6 -= random(0, 10);
  }
  if (c6 < h+h) {
    c6 = height;
  }
  stroke(255);
  line(0, c6, w, c6);
  if (c7 <= height ) {
    c7 -= random(0, 10);
  }
  if (c7 < h+h) {
    c7 = height;
  }
  stroke(255);
  line(w, c7, w+w, c7);
  if (c8 <= height ) {
    c8 -= random(0, 10);
  }
  if (c8 < h+h) {
    c8 = height;
  }
  stroke(255);
  line(w+w, c8, width, c8);
}
