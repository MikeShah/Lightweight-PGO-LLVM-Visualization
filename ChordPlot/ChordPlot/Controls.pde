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
  

  
  // Need to check for Enter and Return so application is cross
  // platform: https://processing.org/reference/keyCode.html
  if(keyCode == ENTER || keyCode == RETURN){
      
      String FilterString = cd.nodeListStack.peek().name;
      
      // Apply the relevant filters
      cd.pushSelectedNodes();
      cd.update(); // Make a call to update the visualization
      
      hw.m_histogram.pushSelectedNodes();
      hw.m_histogram.update(); // Make a call to update the visualization
      hw.updateFunctionList();
      
      bw.m_buckets.pushSelectedNodes();
      bw.m_buckets.update();
      bw.updateFunctionList();
      
      // Add our item to the list
      breadCrumbsBar.addItem(FilterString,cd.nodeListStack.size()-1);
  }
  
  // De-select nodes if space is pressed.
  if(key== ' '){
      // Apply the relevant filters
      cd.deselectAllNodes();
      hw.m_histogram.deselectAllNodes();  bw.selectedBuckets.clear();
      bw.m_buckets.deselectAllNodes();    hw.selectedNodes.clear();
  }
  
  // Invert all of the nodes that have been selected
  if(key== 'i'){
      // Apply the relevant filters
      cd.invertSelectAllNodes();
      hw.m_histogram.invertSelectAllNodes();  bw.selectedBuckets.clear();
      bw.m_buckets.invertSelectAllNodes();    hw.selectedNodes.clear();
  }
  
}