class Histogram extends DataLayer{
  
  // Default Constructor for the Histogram
  public Histogram(String file, float xPosition, float yPosition, int layout){
    init(file, xPosition, yPosition,layout);
  }
  

  // Get all of the points into our node list
  private void plotPoints2D(){
    float xPos = xPosition;
    
    for(int i =0; i < nodeList.size();i++){
      nodeList.get(i).x = xPos;
      nodeList.get(i).y = yPosition;
      xPos += defaultWidth;
    }
  }
  
  
  public void regenerateLayout(int layout){
    nodeList.clear();
    this.layout = layout;
    
    // Populate the node list
    // Get access to all of our nodes
    Iterator<nodeMetaData> nodeListIter = dotGraph.fullNodeList.iterator();
    while(nodeListIter.hasNext()){
      nodeMetaData m = nodeListIter.next();
      ChordNode temp = new ChordNode(m.name,xPosition,yPosition,0);
      temp.metaData.callees = m.callees;
      nodeList.add(temp);
    }
      
    if(layout<=0){
      plotPoints2D();
    }else{
    }
    
    // Quick hack so the visualization can render quickly as well as calculates the callees
    // This needs to be called after we've replotted our visualization
    storeLineDrawings();
    // Draw the mapping of the visualization (Different layouts may need different 
    generateHeatForCalleeAttribute(500);
  }
  
  
  // Here maxHeight represents how many pixels we scale to (
  // (i.e. the maximum value in the set will equal this)
  void generateHeatForCalleeAttribute(float maxHeight){
    // Find the max and min from the ChordNode metadata
    float themin = 0;
    float themax = 0;
    for(int i =0; i < nodeList.size();i++){
      themin = min(themin,nodeList.get(i).metaData.callees);
      themax = max(themax,nodeList.get(i).metaData.callees);
    }
    println("themin:"+themin);
    println("themax:"+themax);
    // Then map that value into the ChordNode so that it can render correctly.
    // We scale from 
    for(int i =0; i < nodeList.size();i++){
      // Get our callees and map it agains the min and max of other callees so we know how to make it stand out
      nodeList.get(i).metaData.callees = (int)map(nodeList.get(i).metaData.callees, themin, themax, 0, maxHeight);
      
      // Our shapes are rectangular, so we need to set this in the ChordNode
      nodeList.get(i).rectWidth = defaultWidth;
      nodeList.get(i).rectHeight = nodeList.get(i).metaData.callees;
    }
  }
  
  
  // Draw using our rendering modes
  public void draw(int mode){
      // What is interesting about the drawing, is that it is all happening in the
      // ChordNode itself. This way we can have any arbritrary shape in ChordNode
      // drawn and handle all of the selection there. It also would allow us to have
      // different types of shaped nodes mixed in a visualization much more easily.
      for(int i =0; i < nodeList.size();i++){
        ChordNode temp = (ChordNode)nodeList.get(i);
        temp.render(2);
      }

  }
  
}