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
  float z;
  public nodeMetaData metaData;
  int nodeSize = 3; // needed if we are rendering 2D circles or spheres
  float rectWidth = 0; // needed if we are rendering 2D rectangular shapes
  float rectHeight =0; // needed if we are rendering 2D rectangular shapes

  
  boolean selected = false;
  
  ArrayList<LocPoint> LocationPoints;
  
  public ChordNode(String name, float x, float y, float z){
    this.metaData = new nodeMetaData(name);
    this.x = x;
    this.y = y;
    this.z = z;
    
    LocationPoints = new ArrayList<LocPoint>();
  }
  
  void getMetaData(nodeMetaData n){
    metaData.copyMetaData(metaData);
  }
  
  // for 2D
  void addPoint(float x, float y){
    LocationPoints.add(new LocPoint(x,y,0));
  }
  
  // For 3D
  void addPoint(float x, float y, float z){
    LocationPoints.add(new LocPoint(x,y,z));
  }
  
  /*
    A Mode of 0 (by default) if we render in 2D as ellipses
    A mode of 1 if we would like to render in 3D as spheres.
    A mode of 2 renders as lines
  */
  public void render(int mode){
    if(mode<=0){
      render2D(0);
    }else if(mode==1){
      sphereDetail(6);
      render3D();
    }
    else if(mode==2){
      render2DRects(rectWidth,rectHeight);
    }
  }
  
  // Render 2D Ellipses
  // Implements onHover and Selection for 2D Cirlces
  // renderShape (0) = ellipse
  // renderShape (1) = rect
  private void render2D(int renderShape){
     if( dist(x,y,mouseX,mouseY) < nodeSize || selected){
        fill(0);
        if(selected){fill(0,255,0);}
        if (renderShape==0){
          ellipse(x,y,nodeSize*2,nodeSize*2);
        }else{
          rect(x,y,nodeSize*2,nodeSize*2);
        }
        
        fill(0,255,0);
        drawToCallees();
        fill(0);
        text(metaData.name,x,y);
        text("Here's the meta-data for "+metaData.name+": "+metaData.extra_information,0,height-20);
        
        if(mousePressed && dist(x,y,mouseX,mouseY) < nodeSize){
          selected = !selected;
        }
     }
     else{
        // Color nodes based on callees
        fill(255-metaData.c);
        stroke(255-metaData.c);
        
        if (renderShape==0){
          ellipse(x,y,nodeSize*2,nodeSize*2);
        }else{
          rect(x,y,nodeSize*2,nodeSize*2);
        }
     }
  }
  
  // Imlements selection and onHover for 3D spheres
  private void render3D(){
     if( dist(x,y,0,mouseX,mouseY,0) < nodeSize || selected){
        fill(0);
        if(selected){fill(0,255,0);}
        
        pushMatrix();
        translate(x,y,z);
          sphere(nodeSize);
        popMatrix();
        
        fill(0,255,0);
        drawTo3DCallees();
        fill(0);
        text(metaData.name,x,y);
        text("Here's the meta-data for "+metaData.name+": "+metaData.extra_information,0,height-20);
        
        if(mousePressed && dist(x,y,z,mouseX,mouseY,0) < nodeSize){
          selected = !selected;
        }
     }
     else{
        // Color nodes based on callees
        fill(255-metaData.c);
        pushMatrix();
        translate(x,y,z);
          sphere(nodeSize);
        popMatrix();
     }
  }
  
  
  // Implements onHover and Selection for 2D Rectangles
  private void render2DRects(float rectWidth, float rectHeight){
     if( (mouseX > x && mouseX < (x+rectWidth) && mouseY < y && mouseY > (y-rectHeight)) || selected){ 
        fill(0);
        if(selected){fill(0,255,0);}
        rect(x,y-rectHeight,rectWidth,rectHeight);
        
        drawToCallees();
        fill(255);
        text(metaData.name,x,y-rectHeight);
        text("Here's the meta-data for "+metaData.name+": "+metaData.extra_information,0,height-20);
        
        if(mousePressed &&  (mouseX > x && mouseX < (x+rectWidth) && mouseY < y && mouseY > (y-rectHeight))){
          selected = !selected;
        }
     }
     else{
        // Color nodes based on callees
        fill(255-metaData.c);
        stroke(255-metaData.c);
        rect(x,y-rectHeight,rectWidth,rectHeight);
     }
  }
  
  // Draw to all of the callee locations in 2D
  public void drawToCallees(){
    fill(0,0,0);
    stroke(0);
    for(int i =0; i < LocationPoints.size();i++){
      line(x,y,LocationPoints.get(i).x,LocationPoints.get(i).y);
    }
  }
  
  // Draw to all of the callee locations in 3D
  public void drawTo3DCallees(){
    fill(255,0,0);
    for(int i =0; i < LocationPoints.size();i++){
      line(x,y,z,LocationPoints.get(i).x,LocationPoints.get(i).y,LocationPoints.get(i).z);
    }
  }
  
    
}