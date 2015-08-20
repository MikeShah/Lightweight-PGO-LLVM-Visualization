class Histogram extends DataLayer{
  
  // Default Constructor for the Histogram
  public Histogram(String file, float xPosition, float yPosition, int layout){
    this.VisualizationName = "Histogram";
    super.init(file, xPosition, yPosition,layout);
    // Set a layout
    this.setLayout(layout);
    // Compute initial statistics
    nodeListStack.computeSummaryStatistics();
  }
  

  // Get all of the points into our node list
  private void plotPoints2D(){
    float xPos = xPosition;
    
    for(int i =0; i < nodeListStack.peek().size();i++){
      nodeListStack.peek().get(i).x = xPos;
      nodeListStack.peek().get(i).y = yPosition;
      xPos += defaultWidth+1;
      xBounds = xPos;
    }
  }
  
  
  /*
      Currently there is only one layout supported.
  */
  public void setLayout(int layout){
    this.layout = layout;
        
    // Quick hack so the visualization can render quickly, also calculates the number of callees from the caller
    // This is called after we have positioned all of our nodes in the visualization
    storeLineDrawings();
    // Draw the mapping of the visualization (Different layouts may need different 
    // functions called.
    // This function cycles through all of the nodes and generates a numerical value that can be sorted by
    // for some attribute that we care about
    this.generateHeatForCalleeAttribute(350);
    
    sortNodesByCallee();
    
    if(layout<=0){
      plotPoints2D();
    }else{
      plotPoints2D();
    }
    
    // Quick hack so the visualization can render quickly, also calculates the number of callees from the caller
    // This is called after we have positioned all of our nodes in the visualization
    storeLineDrawings();
  }
    
  
  // Here maxHeight represents how many pixels we scale to (
  // (i.e. the maximum value in the set will equal this)
  void generateHeatForCalleeAttribute(float maxHeight){
    // Find the max and min from the ChordNode metadata
    float themin = 0;
    float themax = 0;
    for(int i =0; i < nodeListStack.peek().size();i++){
      themin = min(themin,nodeListStack.peek().get(i).metaData.callees);
      themax = max(themax,nodeListStack.peek().get(i).metaData.callees);
    }
    
    // Set the yBounds to the max value that our visualization scales to.
    yBounds = (int)map(themax, themin, themax, 0, maxHeight);
    
    println("themin:"+themin);
    println("themax:"+themax);
    // Then map that value into the ChordNode so that it can render correctly.
    // We scale from 
    for(int i =0; i < nodeListStack.peek().size();i++){
      // Get our callees and map it agains the min and max of other callees so we know how to make it stand out
      nodeListStack.peek().get(i).metaData.callees = (int)map(nodeListStack.peek().get(i).metaData.callees, themin, themax, 0, maxHeight);
      nodeListStack.peek().get(i).metaData.c = nodeListStack.peek().get(i).metaData.callees;
      // Our shapes are rectangular, so we need to set this in the ChordNode
      nodeListStack.peek().get(i).rectWidth = defaultWidth;
      nodeListStack.peek().get(i).rectHeight = nodeListStack.peek().get(i).metaData.callees;
    }
  }
  
  // After we filter our data, make an update
  // so that our visualization is reset based on the
  // active data.
  @Override
  public void update(){
     this.setLayout(layout);
  }
  

  
  // Draw using our rendering modes
  public void draw(int mode){
    if(showData){
           // Draw a background
          pushMatrix();
            drawBounds(0,64,128, xPosition,yPosition-yBounds);
          popMatrix();
          // What is interesting about the drawing, is that it is all happening in the
          // ChordNode itself. This way we can have any arbritrary shape in ChordNode
          // drawn and handle all of the selection there. It also would allow us to have
          // different types of shaped nodes mixed in a visualization much more easily.
          for(int i =0; i < nodeListStack.peek().size();i++){
            ChordNode temp = (ChordNode)nodeListStack.peek().get(i);
            temp.render(2);
          }
    
      }
  }
}