import controlP5.*;
import javax.swing.*; 

/*
  Create a second window
*/
DetailsPane dp;


/* Create our visualizations */
ChordDiagram cd;
Histogram h;
Buckets b;

int programStart = 0;

void settings(){
  size(1440 ,800,P3D);
}

/*
  Processing program initialization
*/
void setup(){
  programStart = millis();
  frame.setTitle("Microarray Visualization");
  frame.setLocation(0, 0);
  
  
  ortho(-width/2, width/2, -height/2, height/2); // same as ortho()

  //String filename = "/home/mdshah/Desktop/LLVMSample/fullDot.dot";
  String filename = "output.dot";
  
  // Create the second window with the details pane
  dp = new DetailsPane();
  dp.setDataString("File Loaded: "+filename);
  
  // Our base visualizations
  cd = new ChordDiagram(400, filename,1);
  h = new Histogram(filename,20,height-30,0);
  b = new Buckets(filename,20,height-290,0);
  
  // Initialize our GUI after our data has been loaded
  initGUI();   
  
  println("setup time: " + (millis()-programStart));
  b.debug();
}

/* =============================================
     Main draw function in the visualization
   ============================================= */
void draw(){
  // Update the mouse Coordidinates with our camera
  MySimpleCamera.update(mouseX, mouseY);
  
  // Refresh the screen
  background(128);
   
   text("FPS :"+frameRate,5,height-40);
   text("Camera Position ("+MySimpleCamera.cameraX+","+MySimpleCamera.cameraY+","+MySimpleCamera.cameraZ+")",5,height-25);
   
   pushMatrix();
     translate(MySimpleCamera.cameraX,MySimpleCamera.cameraY,MySimpleCamera.cameraZ);
     cd.draw(drawMode);
     h.draw(0);
     b.draw(0);
   popMatrix();
}