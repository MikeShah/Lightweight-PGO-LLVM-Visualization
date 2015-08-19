/*

  Any interaction with the user interface through keyboard is currently here

*/


int drawMode = 0;

/* =============================================
  Camera Controls with Arrowkeys, Ctrl, and Shift
   ============================================= */
int keyIndex = 0;
// Determine how deep in the tree we go.
void keyPressed() {
  
  if (key >= '0' && key <= '9') {
    keyIndex = key - '0';
    println(key-'0');
    cd.setLayout(keyIndex);
    
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