int size = 480;
float rps = 1;
int lineNum = 3;
int thickness = 10;

float r = 0;

void setup() {
  size(size, size, P2D);
  background(255);
  stroke(0);
  frameRate(30);
  smooth(4);
  
  benham(size, lineNum, thickness, r);
}

void mouseClicked() {
 rps = map(mouseX, 0, width, -10, 10);
}

void draw() {
  background(255);
  fill(50);
  text(rps + " r/sec.", 10, 20);
  
  benham(size, lineNum, thickness, r);
  r = (r + rps * (TWO_PI / 30)) % TWO_PI;
}

void arct(float a, float b, float c, float d, 
    float start, float stop, int t) {
  for (int i = 0; i < t; i++) {
    arc(a, b, c - i, d - i, start, stop);
  }
}

void benham(int size, int lineNum, int thickness, float r) {
  int cord = size / 2;
  int ellipseSize = size - 10;

  noFill();
  ellipse(cord, cord, ellipseSize, ellipseSize);

  fill(0);
  arc(cord, cord, ellipseSize, ellipseSize, 0 + r, PI + r, PIE);

  fill(255);
  ellipse(cord, cord, thickness / 2, thickness / 2);

  noFill();
  for (int j = 0; j < 4; j++) {
    for (int i = 0; i < lineNum; i++) {
      ellipseSize -= thickness * 2;
      arct(cord, cord, ellipseSize, ellipseSize, 
      PI + (j *  QUARTER_PI) + r, 
      PI + QUARTER_PI + (j * QUARTER_PI) + r,
      thickness);
    }
  }
} 

