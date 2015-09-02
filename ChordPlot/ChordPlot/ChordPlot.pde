import controlP5.*;
import javax.swing.*; 

/*
  Create a second window
*/
DetailsPane dp;

/* Create our visualizations */
ChordDiagram cd;
//Histogram h;

HistogramWindow hw;
BucketsWindow bw;


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
  
  
  ortho(-width/2, width/2, -height/2, height/2); // same as ortho()

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
  // Initialize our GUI after our data has been loaded
  initGUI();   
  
  println("setup time: " + (millis()-programStart));
  bw.m_buckets.debug();
  
  
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
   text("Enter - Push nodes | Space - Deselect/Unhighlihgt all | Arrowkeys for Camera | Left-Mouse select/deselect | Right-Mouse more Info | Hold 's' or 'e' to select/deselect node you hover over",5,height-30);
   
   pushMatrix();
     translate(MySimpleCamera.cameraX,MySimpleCamera.cameraY,MySimpleCamera.cameraZ);
     cd.draw(drawMode);
     //h.draw(0);
   popMatrix();
}