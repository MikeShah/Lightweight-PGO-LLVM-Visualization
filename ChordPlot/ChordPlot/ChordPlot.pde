import controlP5.*;

/* Create our visualizations */
ChordDiagram cd;
Histogram h;





/*
  Processing program initialization
*/
void setup(){
  size(1440 ,800,P3D);
  ortho(-width/2, width/2, -height/2, height/2); // same as ortho()

  //String filename = "/home/mdshah/Desktop/LLVMSample/fullDot.dot";
  String filename = "output.dot";
  
  cd = new ChordDiagram(400, filename,1);
  h = new Histogram(filename,20,height-100,0);
  
  // Initialize our GUI after our data has been loaded
  initGUI();   
}


/* =============================================
     Main draw function in the visualization
   ============================================= */
void draw(){
  // Update the mouse Coordidinates with our camera
  MySimpleCamera.update(mouseX, mouseY);
  hello();
  // Refresh the screen
  background(128);
   
  if (!mousePressed) {
    hint(ENABLE_DEPTH_SORT);
  } else {
    hint(DISABLE_DEPTH_SORT);
  }
   
   text("FPS :"+frameRate,5,height-40);
   text("Camera Position ("+MySimpleCamera.cameraX+","+MySimpleCamera.cameraY+","+MySimpleCamera.cameraZ+")",5,height-25);
   
   pushMatrix();
     translate(MySimpleCamera.cameraX,MySimpleCamera.cameraY,MySimpleCamera.cameraZ);
     cd.draw(drawMode);
     h.draw(0);
   popMatrix();
}