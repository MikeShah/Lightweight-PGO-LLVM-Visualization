
import java.util.*;
import javax.swing.*;  //<>//

ChildApplet DataView;
TreeMap myTreeMap;

int keyIndex = 9;

void settings(){
  size(640, 360,P3D);
}

void setup() {

  frame.setTitle("Primary Visualization - Explore");
  frame.setLocation(0, 0);
  
  DataView = new ChildApplet();
  
  if(frame != null){
    frame.setResizable(true);
  }
  
  myTreeMap = new TreeMap(0,0,200,200);
  //myTreeMap.loadFile();
  println("about to load");
  myTreeMap.loadJSON("small.json");
  println("finsihe."); //<>//
  //myTreeMap.walkTree();
  
  myTreeMap.drawTreeMap(myTreeMap.root,0,0,width,height,0,0,0,keyIndex);

}

boolean startFade = true;
int fadeCounter = 0;
int transitionsFrames = 0;
int transitionFramesMax = 24;

// Main drawing routine for the treemap
void draw() {
  // No need to refresh yet...
  //background(0);
  
  // Pass a data string to our child applet
  DataView.setDataString(myTreeMap.dataString.getString());
  
  if(startFade){
    fadeCounter++;
    if(fadeCounter > 5){
      myTreeMap.drawTreeMap(myTreeMap.root,0,0,width,height,0,1,0,keyIndex);
      fadeCounter = 0;
      transitionsFrames++;
    }
  }else{
    myTreeMap.drawTreeMap(myTreeMap.root,0,0,width,height,0,1,0,keyIndex);
  }
  
  if(transitionsFrames > transitionFramesMax){
    startFade = false;
    transitionsFrames = 0;
    fadeCounter = 0;
  }
  

    
}

// Determine how deep in the tree we go.
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