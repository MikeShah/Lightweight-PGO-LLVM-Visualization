

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
   h = center
   k = center
   r = radius
   numberOfPoints = How many points to draw on the circle
   
  */
  /*
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
  */
  
  /*
      Plot points in the microarary
  */
  private void plotPointsOnGrid(float numberOfPoints){
    println("Calling plotPointsOnGrid");  
    float padding = 10; // padding on the screen
    float pixelsAvailable = (width-padding-padding)*(height-padding-padding);
    // Since we need a square, take the sqrt
    float optimalSize = (sqrt(pixelsAvailable/ nodeListStack.peek().size()));
    
    //float xSize = pixelsNeeded * optimalSize; 
    float xSize = (sqrt(nodeListStack.peek().size()) * optimalSize); 
    // By default, always try to use the ySize.
    float ySize = height-padding-padding; 
    // We will lose the optimalSize * the number of rows we have, so we need
    // to adjust the optimalSize to make up for this.
    
    // recompute once more if we have more than one node
    // WHY: If the size is 1, then (width-padding-padding) - optimalSize will equal 0, thus hiding our node
    if(nodeListStack.peek().size()!=1){
      pixelsAvailable = (width-padding-padding-optimalSize)*(height-padding-padding-optimalSize);
      // Since we need a square, take the sqrt
      optimalSize = (sqrt(pixelsAvailable/ nodeListStack.peek().size()));
    }


    
    println("==============plotPointsOnGrid==============");println("nodeListStack.peek().size():"+nodeListStack.peek().size());
    println("width:"+width);println("padding:"+padding);println("xSize:"+xSize); println("ySize:"+ySize); println("OptimalSize is:"+optimalSize);
    println("==============plotPointsOnGrid==============");
    
    // Set the bounds of our visualization
    xBounds = xSize+padding+optimalSize; 
    
    // We can set a default steps(that is passed in the parameter)
    // But we can re-adjust it to fit the xBo
    println("======About to replot========="+nodeListStack.peek().size());
    rectMode(CORNER);
    int counter = 0; // draw a new point at each step
    float xPos = 0;
    float yPos = optimalSize;
    while(counter <  nodeListStack.peek().size()){
        nodeListStack.peek().get(counter).nodeSize = (int)(optimalSize/2); // Integer division // DEPRECATED, in the sense that we only render rects. If we render ellipse/spheres, this could be valuable.
        //println("Positioning "+nodeListStack.peek().get(counter).metaData.name+": ("+(xPos*optimalSize)+","+yPos+")");
        nodeListStack.peek().get(counter).x = padding+xPos*optimalSize;
        nodeListStack.peek().get(counter).y = padding+yPos;
        
        nodeListStack.peek().get(counter).rectWidth = optimalSize;
        nodeListStack.peek().get(counter).rectHeight = optimalSize;
        
        xPos++;;
        // If the next node we are trying to place is going to go off the screen,
        // then we need to move down a row.
        if(xPos*optimalSize > xSize-optimalSize){
          xPos = 0;
          yPos+=optimalSize;
        }
        yBounds = yPos+padding+optimalSize; // Set the bounds to the last yPos we find (which would be the maximum Y Value)
        counter++;
    }

  }
  
  /*
    Plot Points on a Sphere
  */
  /*
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

      nodeListStack.peek().get(counter).x = xPos;
      nodeListStack.peek().get(counter).y = yPos;
      nodeListStack.peek().get(counter).z = zPos;
      
      theta = theta + steps;
      counter++;
    }
    
  }
  */


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
    // Note we do not want to use the heat for setting te size of any attribute
    generateHeatForCalleeAttribute(0,false);
    
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
    //generateHeatForCalleeAttribute(CALLEE);  // FIXME: Is this a bug, why am I always passing in by CALLEE?
    //// Modify all of the positions in our nodeList
    if(this.layout <=0 ){
      // DEPRECATED function call plotPointsOnCircle(nodeListStack.peek().size()); // Plot points on the circle
    }else if(this.layout == 1){
      plotPointsOnGrid(nodeListStack.peek().size());
    }else if(this.layout >= 2){
      // DEPRECATED function call plotPointsOnSphere(nodeListStack.peek().size());
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