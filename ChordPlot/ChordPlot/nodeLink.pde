/*
  An individual node in the nodeLink System

*/

public class nodeLink{
 
  String name;
  /*
    If the node is a source, then we
    can draw from it.
    
    If it is a receiver, then we can attach to it.
  */
  boolean source;
  boolean receive;
  
  // Position in 3D space
  float x,y,z;
  // Size of the node text
  float rectWidth,rectHeight;
  // connector Size pixels
  float connectorSize = 5;
  
  // drawFrom determines if we are actively drawing to a node
  boolean drawFrom = false;
  
  // Reference to the node link we are connected to or from
  nodeLink connectedTo;  // the receiver we connect to
  nodeLink connectedFrom; // a source that is connected to this node
  
  public nodeLink(){
  }
  
  public nodeLink(String name, float x, float y, float z, boolean source, boolean receive){
      this.name = name;  
    
      this.x = x;
      this.y = y;
      this.z = 0;
      
      this.source = source;
      this.receive = receive;
      
      rectWidth = 100;
      rectHeight = 60;
      
      connectedTo = null;
      connectedFrom = null;
  }
  

  
  
}