import controlP5.*;
import javax.swing.*; 
import java.io.*;

/*
  Create a second window
*/
DetailsPane dp;

/* Create our visualizations */
ChordDiagram cd;
//Histogram h;

HistogramWindow hw;
BucketsWindow bw;

nodeLinkSystem encodings;

int programStart = 0;

void settings(){
  size(1240 ,800, P3D);
}

/*
    Processing program initialization
*/
void setup(){  
  programStart = millis();
  surface.setTitle("Microarray Visualization");
  surface.setLocation(0, 0);
  
  
  ortho(-width/2.0, width/2.0, -height/2.0, height/2.0); // same as ortho()

  //String filename = "/home/mdshah/Desktop/LLVMSample/fullDot.dot";
  //String filename = "output.dot"; // legacy version of dot file loader
  String filename = "horde3d.dot";

  // Our base visualizations
  // It is best practice to intialize this first since we reference 'cd' across
  // the entire codebase.
  cd = new ChordDiagram(400, filename,1);
  
  //h = new Histogram(filename,20,height-30,0);

  // Create the second window with the details pane
  dp = new DetailsPane();
  dp.setDataString("File Loaded: "+filename);
  
  hw = new HistogramWindow(filename);
  bw = new BucketsWindow(filename);
  
  encodings = new nodeLinkSystem();
  
  /* What we are encoding(the attribute), and how it is decoded(the visual presentation)*/
  nodeLink recursive_enc =   new nodeLink("recursive",0,0,0,true,false);       encodings.addNode(recursive_enc);
  nodeLink callsite_enc =    new nodeLink("Callsite",0,80,0,true,false);       encodings.addNode(callsite_enc);
  nodeLink bitcode_enc =     new nodeLink("BitCode Size",0,160,0,true,false);  encodings.addNode(bitcode_enc);
  
  nodeLink heat_dec =       new nodeLink("heatmap",200,0,0,false,true);           encodings.addNode(heat_dec);
  nodeLink symbol_dec =     new nodeLink("symbol",200,80,0,false,true);           encodings.addNode(symbol_dec);
  nodeLink stroke_dec =     new nodeLink("stroke color",200,160,0,false,true);    encodings.addNode(stroke_dec);
  nodeLink rectangle_dec =  new nodeLink("Rectangle",200,240,0,false,true);       encodings.addNode(rectangle_dec);
  nodeLink rectspin_dec =   new nodeLink("Rectangle Spin",200,320,0,false,true);  encodings.addNode(rectspin_dec);

  
  bw.m_buckets.debug();
  
  // Initialize our GUI after our data has been loaded
  initGUI();  
  
  println("setup time: " + (millis()-programStart));
}

/* =============================================
     Main draw function in the visualization
   ============================================= */
void draw(){
  // Update the mouse Coordidinates with our camera
  MySimpleCamera.update(mouseX, mouseY);
  
  // Refresh the screen
  background(128);
   
   text("FPS :"+frameRate,width-100,height-20);
   text("Camera Position ("+MySimpleCamera.cameraX+","+MySimpleCamera.cameraY+","+MySimpleCamera.cameraZ+")",5,height-20);
   text("Enter - Push nodes | Space - Deselect/Unhighlihgt all | Arrowkeys for Camera | Left-Mouse select/deselect | Right-Mouse more Info | Hold 's' or 'e' to select/deselect node you hover over",5,height-50);
   text("'a' - select all callees of current node | 'h' to hide lines being drawn | 'c' - Show callers of node | 'b' selects all caller nodes | 'o' open source in editor",5,height-30);
   
   pushMatrix();
     translate(MySimpleCamera.cameraX,MySimpleCamera.cameraY,MySimpleCamera.cameraZ);
     cd.draw(drawMode);
     //h.draw(0);
   popMatrix();
}