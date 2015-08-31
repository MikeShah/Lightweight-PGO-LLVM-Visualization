

// Purpose of this class is to
// 
class ChordDiagram extends DataLayer{
  
  float radius;
  float nodeSteps = 6;
     
  public ChordDiagram(float radius, String file,int layout){
    this.VisualizationName = "Chord Diagram";
    this.radius = radius;
    this.layout = layout;
    // Calls init() which is from the DataLayer class, and basically runs as a constructor
    super.init(file,0,0,layout);
    // Set a layout
    this.setLayout(layout);
    // Compute initial statistics
    nodeListStack.computeSummaryStatistics();
  }
  
  /*
      
  */
  void generateHeatForCalleeAttribute(){
    // Find the max and min from the ChordNode metadata
    float themin = 0;
    float themax =0;
    for(int i =0; i < nodeListStack.peek().size();i++){
      themin = min(themin,nodeListStack.peek().get(i).metaData.callees);
      themax = max(themax,nodeListStack.peek().get(i).metaData.callees);
    }
    println("themin:"+themin);
    println("themax:"+themax);
    // Then map that value into the ChordNode so that it can render correctly.
    // We scale from 
    for(int i =0; i < nodeListStack.peek().size();i++){
      // Get our callees and map it agains the min and max of other callees so we know how to make it stand out
      nodeListStack.peek().get(i).metaData.c = map(nodeListStack.peek().get(i).metaData.callees, themin, themax, 0, 255);
    }
    
  }
  
  /*
   h = center
   k = center
   r = radius
   numberOfPoints = How many points to draw on the circle
   
  */
  private void plotPointsOnCircle(float numberOfPoints){
    
    float steps = 360/numberOfPoints; // Based on how many points we have, 
                                      // draw a new point at each step
    float theta = 0; // angle to increase each loop
    
    int counter = 0;
    
    float xPos = 0;
    float yPos = 0;
    while(theta<360){
      xPos = centerx + radius*cos(theta);
      yPos = centery - radius*sin(theta);

      theta = theta + steps;

      if(counter < nodeListStack.peek().size()){
        nodeListStack.peek().get(counter).x = xPos;
        nodeListStack.peek().get(counter).y = yPos;
      }
      counter++;
    }
    println("Nodes edited:"+counter);
    
  }
  
  /*
      Plot points in the microarary
  */
  private void plotPointsOnGrid(float numberOfPoints, float steps){
    println("Calling plotPointsOnGrid");  
    float padding = 10; // padding on the screen
    // Compute the proper aspect ratio so that the visualization is more square.
    
    // Adjust the aspect ratio
    int pixelsNeeded = (int)(sqrt( steps * nodeListStack.peek().size()));
    
    float xSize = pixelsNeeded * steps; //(width-padding-200); // FIXME: 200 is because the GUI's width is 200, there needs to be a better way to reference this
    // If our aspect ratio gets messed up, set it to the maximum
    if(xSize > width-padding-200){
      xSize = width-padding-200;
    }
    
    float ySize = height-padding;
    
    xBounds = xSize+padding; // Set the bounds
    
    println("======About to replot=========");
    int counter = 0; // draw a new point at each step
    for(  float yPos = padding; yPos < ySize; yPos+=steps){
      for(float xPos = padding; xPos < xSize; xPos+=steps){
        if(counter < nodeListStack.peek().size()){
          nodeListStack.peek().get(counter).x = xPos;
          nodeListStack.peek().get(counter).y = yPos;
          if(nodeListStack.peek().size()<5){
              println("(x,y)=> ("+xPos+","+yPos+")");
          }
          // Set the size of our visualization here
          nodeListStack.peek().get(counter).nodeSize = (int)(steps/2); // Integer division
          nodeListStack.peek().get(counter).rectWidth = steps;
          nodeListStack.peek().get(counter).rectHeight = steps;
          
          yBounds = yPos+padding; // Set the bounds to the last yPos we find (which would be the maximum Y Value)
          counter++;
        }
      }
    }
    println("xbounds:"+xBounds);
    println("ybounds:"+yBounds);
  }
  
  /*
    Plot Points on a Sphere
  */
  private void plotPointsOnSphere(float numberOfPoints){   
    float steps = 360/numberOfPoints; // Based on how many points we have, 
                                      // draw a new point at each step
    float theta = 0; // angle to increase each loop

    int counter = 0;
    while(counter < nodeListStack.peek().size()){
      
      float p = radius;
      float phi = PI/3;
      
      float xPos = centerx + p*sin(phi)*cos(theta);
      float yPos = centery + p*sin(phi)*sin(theta);
      float zPos = p*cos(phi);
      /*
      float xPos = centerx + radius*cos(theta);
      float yPos = centery - radius*sin(theta);
      float zPos = radius*sin(theta);
      */
      nodeListStack.peek().get(counter).x = xPos;
      nodeListStack.peek().get(counter).y = yPos;
      nodeListStack.peek().get(counter).z = zPos;
      
      theta = theta + steps;
      counter++;
    }
    
  }

  public void setLayout(int layout){
    // Set our layout
    this.layout = layout;

    println("Setting a new layout");
    // Quick hack so the visualization can render quickly, also calculates the number of callees from the caller
    // This is called after we have positioned all of our nodes in the visualization
    storeLineDrawings();
    
    // Quick hack so the visualization can render quickly, also calculates the number of callees from the caller
    // This is called after we have positioned all of our nodes in the visualization
    // Draw the mapping of the visualization (Different layouts may need different 
    // functions called.
    // This function cycles through all of the nodes and generates a numerical value that can be sorted by
    // for some attribute that we care about
    generateHeatForCalleeAttribute();
    
    sortNodesByCallee();
    
    // Modify all of the physical locations in our nodeList
    fastUpdate();
       
    // Quick hack so the visualization can render quickly, also calculates the number of callees from the caller
    // This is called after we have positioned all of our nodes in the visualization
    storeLineDrawings();
    
  }

  /*
      Useful for being used in update where we don't need to do anything else with the data.
      This means setLayout should only be called once initially.
      
      Fast layout will layout the nodes. It is nice to have this abstracted away
      into its own function so we can quickly re-plot the nodes without doing additional
      computations.
  */
  public void fastUpdate(){
    println("Calling fastUpdate");
    // Modify all of the positions in our nodeList
    if(this.layout <=0 ){
      plotPointsOnCircle(nodeListStack.peek().size()); // Plot points on the circle
    }else if(this.layout == 1){
      plotPointsOnGrid(nodeListStack.peek().size(),nodeSteps);
    }else if(this.layout >= 2){
      plotPointsOnSphere(nodeListStack.peek().size());
    }
  }

  // After we filter our data, make an update
  // so that our visualization is reset based on the
  // active data.
  @Override
  public void update(){
     this.setLayout(this.layout);
  }

  @Override
  public void setPosition(float x, float y){
    centerx = x;
    centery = y;
  }
  
  public void draw(int mode){
    if(showData){
         // Draw a background
          pushMatrix();
            translate(0,0,MySimpleCamera.cameraZ-1);
            drawBounds(0,64,128, xPosition, yPosition);
          popMatrix();
          
          fill(0);
          
          if(this.layout==0){
            ellipse(centerx,centery,radius*2,radius*2);
          }
          
          // What is interesting about the drawing, is that it is all happening in the
          // ChordNode itself. This way we can have any arbritrary shape in ChordNode
          // drawn and handle all of the selection there. It also would allow us to have
          // different types of shaped nodes mixed in a visualization much more easily.
          for(int i =0; i < nodeListStack.peek().size();i++){
            ChordNode temp = (ChordNode)nodeListStack.peek().get(i);
            temp.render(mode);
          }
      }
  }
}