/*
  
    The purpose of this class is to take in a metaDataNode
    
    From that metaData node we can see what fields it has available.
    
    Of those fields, we can assign them to different properties that will
    
    affect the rest of the visualization.

*/

class nodeLinkDiagram extends commonWidget{
   
  public nodeLinkDiagram(){
  }

  public void settings() {
    size(300, 300, P3D);
    smooth();
  }
    
  public void setup() {
      surface.setTitle(windowTitle);
      surface.setLocation(1440, 0);
  }
  
  
  public void draw() {
  }  
  
}