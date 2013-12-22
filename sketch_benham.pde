int HS_HEIGHT = 20;
float MAX_RPS = 10;

int SIZE = 480;
int LINENUM = 3;
int THICKNESS = 5;

float r = 0;
float rps = 1;

HScrollbar hs;

void setup() {
  size(SIZE, SIZE);
  background(255);
  stroke(0);
  frameRate(30);
  smooth();
  
  hs = new HScrollbar(0, height - (HS_HEIGHT / 2), width, HS_HEIGHT, 4);
}

void draw() {
  rps = map(hs.getPos(), 0, width, -MAX_RPS, MAX_RPS);
  r = (r + rps * (TWO_PI / 30)) % TWO_PI;
  
  pushMatrix();
  translate(width / 2, height / 2);
  rotate(r);
  background(255);
  stroke(0);
  benham(SIZE, LINENUM, THICKNESS, 0);
  popMatrix();
  
  fill(50);
  text(rps + " r/sec.", 10, height - HS_HEIGHT - 10);

  fill(255);
  hs.update();
  hs.display();
}

void arct(float a, float b, float c, float d, 
    float start, float stop, int t) {
  strokeWeight(t);
  strokeCap(SQUARE);
  arc(a, b, c, d, start, stop);
}

void benham(int size, int lineNum, int thickness, float r) {
  int cord = 0;
  int ellipseSize = size - 80;

  strokeWeight(1);
  noFill();
  ellipse(cord, cord, ellipseSize, ellipseSize);

  fill(0);
  arc(cord, cord, ellipseSize, ellipseSize, 0 + r, PI + r, PIE);

  fill(255);
  ellipse(cord, cord, thickness / 2, thickness / 2);

  noFill();
  for (int j = 0; j < 4; j++) {
    for (int i = 0; i < lineNum; i++) {
      ellipseSize -= thickness * 4;
      arct(cord, cord, ellipseSize, ellipseSize, 
      PI + (j *  QUARTER_PI) + r, 
      PI + QUARTER_PI + (j * QUARTER_PI) + r,
      thickness);
    }
  }
} 

// http://processing.org/examples/scrollbar.html
class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}
