// Represents a point in space
class LocPoint{
 float x;
 float y;
 float z;
 LocPoint(float x, float y){
   this.x = x;
   this.y = y;
   this.z = 0;
 }
 
  LocPoint(float x, float y, float z){
   this.x = x;
   this.y = y;
   this.z = z;
 }
}

// Node class consits of a source
class ChordNode{
  float x;
  float y;
  public nodeMetaData metaData;
  int nodeSize = 3;

  
  boolean selected = false;
  
  ArrayList<LocPoint> LocationPoints;
  
  public ChordNode(String name, float x, float y){
    this.metaData = new nodeMetaData(name);
    this.x = x;
    this.y = y;
    
    LocationPoints = new ArrayList<LocPoint>();
  }
  
  // for 2D
  void addPoint(float x, float y){
    LocationPoints.add(new LocPoint(x,y));
  }
  
  // For 3D
  void addPoint(float x, float y, float z){
    LocationPoints.add(new LocPoint(x,y,z));
  }
  
  public void render(){
       
     if( dist(x,y,mouseX,mouseY) < nodeSize || selected){
        fill(0);
        if(selected){fill(0,255,0);}
        ellipse(x,y,nodeSize*2,nodeSize*2);
        
        fill(0,255,0);
        drawToCallees();
        fill(255);
        text(metaData.name,x,y);
        text("Here's the meta-data for "+metaData.name+": "+metaData.extra_information,0,height-20);
        
        if(mousePressed && dist(x,y,mouseX,mouseY) < nodeSize){
          selected = !selected;
        }
     }
     else{
        // Color nodes based on callees
        
        fill(255-metaData.c);
        ellipse(x,y,nodeSize*2,nodeSize*2);
     }
     
  }
  
  // Draw to all of the callee locations
  public void drawToCallees(){
    fill(255,0,0);
    for(int i =0; i < LocationPoints.size();i++){
      line(x,y,LocationPoints.get(i).x,LocationPoints.get(i).y);
    }
  }
  
    
}