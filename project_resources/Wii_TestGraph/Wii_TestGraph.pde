import oscP5.*;
import netP5.*;

OscP5 osc;


PFont font;
int screenwidth = 640;
int screenheight = 480;
boolean mGraph = true;
boolean xGraph = true;
boolean yGraph = true;
boolean zGraph = true;
boolean updateGraph = true;

WiiPlot graph1 = new WiiPlot (screenwidth, 150);


void keyPressed() {
  if (key== 'M' || key == 'm'){
      if (mGraph) mGraph = false;
      else mGraph = true;
  }
    if (key== 'X' || key == 'x'){
      if (xGraph) xGraph = false;
      else xGraph = true;
  } 
     if (key== 'Y' || key == 'y'){
      if (yGraph) yGraph = false;
      else yGraph = true;
  }  
  if (key== 'Z' || key == 'z'){
      if (zGraph) zGraph = false;
      else zGraph = true;
  }
  if (key == ' '){
    if (updateGraph) updateGraph = false;
    else updateGraph = true;
  }
}


void setup() {

  size(screenwidth, screenheight);
  osc = new OscP5(this,9000);
  osc.plug(this,"xyz","/wii/1/accel/xyz");

  font = loadFont("Delicious-Roman-24.vlw");
  textAlign(RIGHT);

  background(255);
  smooth();
  noFill();
  stroke(0);

}

int x, y, z;

void xyz(float _x, float _y, float _z) {
  x = int((_x-.5) * 1000);
  y = int((_y-.5) * 1000);
  z = int((_z-.5) * 1000);
  //print ("xyz "+x+" "+y+" "+z+"\n"); 
}

void draw(){
  background(0);
  textFont(font, 12);
  text ("press m, x, y, or z keys to toggle graph displays. press space to freeze graphing.", 25, 20);
  graph1.update(x, y, z, xGraph, yGraph, zGraph, mGraph);
}



