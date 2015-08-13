ChordDiagram cd;
Histogram h;


void setup(){
  size(1200 , 900,P3D);
  String filename = "output.dot";

  cd = new ChordDiagram(400, filename,1);
  h = new Histogram(filename,20,height-100);   
}

int drawMode =0 ;

void draw(){
  println("FPS :"+frameRate);
   background(192);
   
   pushMatrix();
     translate(MySimpleCamera.cameraX,MySimpleCamera.cameraY,MySimpleCamera.cameraZ);
     cd.draw(drawMode);
     
     h.draw(0);
   popMatrix();
}

int keyIndex = 0;
// Determine how deep in the tree we go.
void keyPressed() {
  
  if (key >= '0' && key <= '9') {
    keyIndex = key - '0';
    println(key-'0');
    cd.regenerateLayout(keyIndex);
    
    // Reset the camera
    MySimpleCamera.cameraX = 0;
    MySimpleCamera.cameraY = 0;
    MySimpleCamera.cameraZ = 0;
    
    if(keyIndex==2){
      drawMode = 1;
    }
    else{
      drawMode = 0;
    }
  } else if (key >= 'a' && key <= 'z') {
    keyIndex = key - '0';
    println(key-'0');
  }
  
  // Simple camera
  if(keyCode == LEFT){
    MySimpleCamera.moveLeft();
  }
  if(keyCode == RIGHT){
    MySimpleCamera.moveRight();
  }
  if(keyCode == UP){
    MySimpleCamera.moveForward();
  }
  if(keyCode == DOWN){
    MySimpleCamera.moveBack();
  }
  if(keyCode == CONTROL){
    MySimpleCamera.moveUp();
  }
  if(keyCode == SHIFT){
    MySimpleCamera.moveDown();
  }
  
}