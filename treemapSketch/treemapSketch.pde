
import java.util.*;
import javax.swing.*; 
 //<>//


/*
public class PFrame extends JFrame {
  
  public PFrame(int width, int height) {
    setBounds(100, 100, width, height);
    //s = new SecondApplet();
    //add(s);
    //s.init();
    //show();
  }
}

public class SecondApplet extends PApplet {
  int ghostX, ghostY;
  public void setup() {
    background(0);
    noStroke();
  }

  public void draw() {
    background(50);
    fill(255);
    ellipse(mouseX, mouseY, 10, 10);
    fill(0);
    ellipse(ghostX, ghostY, 10, 10);
  }
  public void setGhostCursor(int ghostX, int ghostY) {
    this.ghostX = ghostX;
    this.ghostY = ghostY;
  }
}
*/

//SecondApplet s;
TreeMap myTreeMap;

int keyIndex = 9;


void setup() {

  size(640, 360,P3D);
  background(102);
  
  frame.setTitle("first window");
  
  if(frame != null){
    frame.setResizable(true);
  }
  
  myTreeMap = new TreeMap(0,0,200,200);
  //myTreeMap.loadFile();
  myTreeMap.loadJSON("test.json");
  //myTreeMap.walkTree();
  
  float[] P = new float[2];
  float[] Q = new float[2];
  
  P[0] = 0;    P[1] = 0;
  Q[0] = 480;  Q[1] = 240;
  
  myTreeMap.drawTreeMap(myTreeMap.root,0,0,width,height,0,0,0,keyIndex);
  
  //myTreeMap.drawTreeMap2(myTreeMap.root,P,Q,0,0,0);
  
  // Setup the second window
  //PFrame f = new PFrame(width, height);
  //f.setTitle("second window");
}

boolean startFade = true;
int fadeCounter = 0;
int transitionsFrames = 0;
int transitionFramesMax = 24;

void draw() {
  //s.setGhostCursor(mouseX, mouseY);
  
  //background(0);
  
  if(startFade){
    fadeCounter++;
    if(fadeCounter > 5){
      myTreeMap.drawTreeMap(myTreeMap.root,0,0,width,height,0,1,0,keyIndex);
      fadeCounter = 0;
      transitionsFrames++;
    }
  }
  
  if(transitionsFrames > transitionFramesMax){
    startFade = false;
    transitionsFrames = 0;
    fadeCounter = 0;
  }
  
  
}

void keyPressed() {
  
  if (key >= '0' && key <= '9') {
    keyIndex = key - '0';
    println(key='0');
  } else if (key >= 'a' && key <= 'z') {
    keyIndex = key - '0';
    println(key-'0');
  }
  
  startFade = true;
  
    
}