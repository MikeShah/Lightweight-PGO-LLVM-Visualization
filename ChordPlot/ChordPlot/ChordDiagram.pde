

// Purpose of this class is to
// 
class ChordDiagram extends DataLayer{
  
  float radius;
  float nodeSteps = 4;
     
  public ChordDiagram(float radius, String file,int layout){
    this.visualizationName = "Chord Diagram";
    this.radius = radius;
    this.layout = layout;
    // Calls init() which is from the DataLayer class, and basically runs as a constructor
    super.init(file,0,0,layout);
    // Set a layout
    this.setLayout(layout);
    // Compute initial statistics
    // FIXME: Put this back in the code nodeListStack.computeSummaryStatistics();
  }
  
  /*
      
  */
  void generateHeatForCalleeAttribute(){
    // Find the max and min from the ChordNode metadata
    float minCallees = 0;
    float maxCallees = 0;
    
    float minCallers = 0;
    float maxCallers = 0;
    
    float minPGO = 0;
    float maxPGO = 0;
    
    float minBitCodeSize = 0;
    float maxBitCodeSize = 0;
        
    for(int i =0; i < nodeListStack.peek().size();i++){
      minCallees = min(minCallees,nodeListStack.peek().get(i).metaData.callees);
      maxCallees = max(maxCallees,nodeListStack.peek().get(i).metaData.callees);
      
      minCallers = min(minCallers,nodeListStack.peek().get(i).metaData.callers);
      maxCallers = max(maxCallers,nodeListStack.peek().get(i).metaData.callers);
      
      minPGO = min(minPGO,parseInt(nodeListStack.peek().get(i).metaData.PGOData));
      maxPGO = max(maxPGO,parseInt(nodeListStack.peek().get(i).metaData.PGOData));
      
      minBitCodeSize = min(minBitCodeSize,nodeListStack.peek().get(i).metaData.bitCodeSize);
      maxBitCodeSize = max(maxBitCodeSize,nodeListStack.peek().get(i).metaData.bitCodeSize);
      
    }
    println("themin:"+minCallees);
    println("themax:"+maxCallees);
    // Then map that value into the ChordNode so that it can render correctly.
    // We scale from 
    for(int i =0; i < nodeListStack.peek().size();i++){
      switch(this.colorizeBy){
        case CALLEE:
              nodeListStack.peek().get(i).metaData.c = map(nodeListStack.peek().get(i).metaData.callees, minCallees, maxCallees, 0, 255);
              break;
        case CALLER:
              nodeListStack.peek().get(i).metaData.c = map(nodeListStack.peek().get(i).metaData.callers, minCallers, maxCallers, 0, 255);
              break;
        case PGODATA:
              nodeListStack.peek().get(i).metaData.c = map(nodeListStack.peek().get(i).metaData.PGOData, minPGO, maxPGO, 0, 255);
              break;
        case BITCODESIZE:
              nodeListStack.peek().get(i).metaData.c = map(nodeListStack.peek().get(i).metaData.bitCodeSize, minBitCodeSize, maxBitCodeSize, 0, 255);
              break;
        case RECURSIVE:
              nodeListStack.peek().get(i).metaData.c = map(nodeListStack.peek().get(i).metaData.recursive, 0, 1, 0, 255);
              break;
      }

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
  private void plotPointsOnGrid(float numberOfPoints){
    println("Calling plotPointsOnGrid");  
    float padding = 20; // padding on the screen
    float pixelsAvailable = (width-padding-padding)*(height-padding-padding);
  
    float optimalSize = pixelsAvailable/ nodeListStack.peek().size();
    // Since we need a square, take the sqrt
    optimalSize = (sqrt(optimalSize)); // Cast to an int to make things simple
    // Compute the proper aspect ratio so that the visualization is more square.     
    // Adjust the aspect ratio
    //int pixelsNeeded = (int)(sqrt( optimalSize * nodeListStack.peek().size()));
    
    //float xSize = pixelsNeeded * optimalSize; 
    float xSize = sqrt(nodeListStack.peek().size()) * optimalSize; 
        
    // If our aspect ratio gets messed up, set it to the maximum
    if(xSize > width-padding-optimalSize){
       xSize = width-padding-optimalSize;
    }
    
    float ySize = height-padding-padding; 
    
    // If we exceed our ySize, then we need to de-squarify the xSize by
    // making it more rectangular.
    float tempValue = sqrt(nodeListStack.peek().size()) * (optimalSize);
    while(tempValue > ySize){
      tempValue--;
      xSize++;
    }
    println("==============plotPointsOnGrid==============");
    println("nodeListStack.peek().size():"+nodeListStack.peek().size());
    println("width:"+width);
    println("padding:"+padding);
    println("xSize:"+xSize);
    println("OptimalSize is:"+optimalSize);
    println("==============plotPointsOnGrid==============");
    
    
    // Set the bounds of our visualization
    xBounds = xSize+padding+optimalSize; 
    
    // We can set a default steps(that is passed in the parameter)
    // But we can re-adjust it to fit the xBo
    
    println("======About to replot=========");
    int counter = 0; // draw a new point at each step
    for(  float yPos = optimalSize; yPos <= ySize; yPos+=optimalSize){
      for(float xPos = padding; xPos <= xSize; xPos+=optimalSize){
        if(counter < nodeListStack.peek().size()){
          nodeListStack.peek().get(counter).x = xPos;
          nodeListStack.peek().get(counter).y = yPos;

          // Set the size of our visualization here
          nodeListStack.peek().get(counter).nodeSize = (int)(optimalSize/2); // Integer division
          nodeListStack.peek().get(counter).rectWidth = optimalSize;
          nodeListStack.peek().get(counter).rectHeight = optimalSize;
          
          yBounds = yPos+padding+optimalSize; // Set the bounds to the last yPos we find (which would be the maximum Y Value)
          counter++;
        }
      }
    }
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
    // (1) Calculates the number of callees from the caller 
    // Quick hack so the visualization can render quickly, also calculates the number of callees from the caller
    // This is called after we have positioned all of our nodes in the visualization
    // Draw the mapping of the visualization (Different layouts may need different 
    // functions called.
    storeLineDrawings();
    
    // (2) This function cycles through all of the nodes and generates a numerical value that can be sorted by
    // for some attribute that we care about
    generateHeatForCalleeAttribute();
    
    // (3) Sort all of the callees in their respective list by some criteria
    // TODO: Make this sorting be due to the Encoding Engine or NodeLinkSystem
    sortNodesBy();
    
    // (4) Modify all of the physical locations in our nodeList
    fastUpdate();
       
    // (5) Quick hack so the visualization can render quickly, also calculates the number of callees from the caller
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
    println("ChordDiagram fastUpdate");
    generateHeatForCalleeAttribute(CALLEE);
    // Modify all of the positions in our nodeList
    if(this.layout <=0 ){
      plotPointsOnCircle(nodeListStack.peek().size()); // Plot points on the circle
    }else if(this.layout == 1){
      plotPointsOnGrid(nodeListStack.peek().size());
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