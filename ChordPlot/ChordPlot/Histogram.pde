class Histogram implements VisualizationLayout{
  
  // Where to draw the visualization
  float xPosition;
  float yPosition;
  // The layout of the nodes within the visualization
  int layout;
  
  float defaultWidth = 4; // The default width of the bars in the histogram
  
  DotGraph dotGraph;
  ArrayList<ChordNode> nodeList;  // All of the nodes, that will be loaded from the dotGraph
       
  public Histogram(String file, float xPosition, float yPosition){
     this.xPosition = xPosition;
     this.yPosition = yPosition;
     
     layout = 0;
    
    // Load up data
    // Note that the dotGraph contains the entire node list, and all of the associated meta-data with it.
    dotGraph = new DotGraph(file);
    // Create a list of all of our nodes that will be in the visualization
    nodeList = new ArrayList<ChordNode>();
    
    // Populate the node list
    // Get access to all of our nodes
    Iterator<nodeMetaData> nodeListIter = dotGraph.fullNodeList.iterator();
    while(nodeListIter.hasNext()){
      nodeMetaData m = nodeListIter.next();
      ChordNode temp = new ChordNode(m.name,xPosition,yPosition,0);
      temp.metaData.callees = m.callees;
        nodeList.add(temp);
    }
    
    // Plot the points in some default configuration
    this.regenerateLayout(layout);
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
    this.layout = layout;
      // Plot points on the circle
      
    if(layout<=0){
      plotPoints2D();
    }else{
    }
    
    // Quick hack so the visualization can render quickly as well as calculates the callees
    storeLineDrawings();
    // Draw the mapping of the visualization (Different layouts may need different 
    generateHeatForCalleeAttribute(500);
  }
  
  public void setPosition(float x, float y){
     this.xPosition = x;
     this.yPosition = y;
     // A bit ugly, but we have to regenerate the layout
     // everytime we move the visualization for now
     regenerateLayout(layout);
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
  
  // The goal of this function is to look through every node
  // in the DotGraph that is a source.
  // For each of the nodes that are a destination in the source
  // figure out which position they have been assigned in 'plotPointsOnCircle'
  // Then we need to store each of these in that ChordNode's list of lines to draw
  // so that when we render we can do it quickly.
  //
  private void storeLineDrawings(){
    
      for(int i =0; i < nodeList.size(); i++){
        // Search to see if our node has outcoming edges
        nodeMetaData nodeName = nodeList.get(i).metaData;        // This is the node we are interested in finding sources
        if (dotGraph.graph.containsKey(nodeName)){     // If we find out that it exists as a key(i.e. it is not a leaf node), then it has targets
          // If we do find that our node is a source(with targets)
          // then search to get all of the destination names and their positions
          ArrayList<nodeMetaData> dests = (dotGraph.graph.get(nodeName));
          for(int j = 0; j < dests.size(); j++){
              for(int k =0; k < nodeList.size(); k++){
                if(dests.get(j).name==nodeList.get(k).metaData.name){
                  nodeList.get(i).addPoint(nodeList.get(k).x,nodeList.get(k).y);          // Add to our source node the locations
                  // Store some additional information
                  nodeList.get(i).metaData.callees++;
                  break;
                }
              }
          }
        }
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