

// Purpose of this class is to
// 
class ChordDiagram{
  
  float radius;
  int layout;
  float centerx = width/2;
  float centery = height/2;
  
  DotGraph dotGraph;
  ArrayList<ChordNode> nodeList;  // All of the nodes, that will be loaded from the dotGraph
      
  public ChordDiagram(float radius, String file,int layout){
    // How are we going to render the scene.
    this.layout = layout;
    // Set the size of our visualization
    this.radius = radius;
    // Load up data
    dotGraph = new DotGraph(file);
    // Print out to console (for debugging-purposes only)
 //   dotGraph.printGraph();
    // Create a list of all of our nodes that will be in the visualization
    nodeList = new ArrayList<ChordNode>();
    regenerateLayout(layout);
  }
  
  void generateHeatForCalleeAttribute(){
    // Find the max and min from the ChordNode metadata
    float themin = 0;
    float themax =0;
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
      nodeList.get(i).metaData.c = map(nodeList.get(i).metaData.callees, themin, themax, 0, 255);
    }
    
  }
  
    /*
  
   h = center
   k = center
   r = radius
   numberOfPoints = How many points to draw on the circle
   
  */
  public void plotPointsOnCircle(float numberOfPoints){
    // Emptry the nodeList;
    nodeList.clear();
    
    float steps = 360/numberOfPoints; // Based on how many points we have, 
                                      // draw a new point at each step
    float theta = 0; // angle to increase each loop
    
    println("before iterator");
    Iterator<nodeMetaData> nodeListIter = dotGraph.fullNodeList.iterator();
    println("Items:"+dotGraph.fullNodeList.size());
    while(theta<360){
      float xPos = centerx + radius*cos(theta);
      float yPos = centery - radius*sin(theta);
      nodeList.add(new ChordNode(nodeListIter.next().name,xPos,yPos));
      theta = theta + steps;
      println("iterations");
    }
    
  }
  
  public void plotPointsOnGrid(float numberOfPoints){
    // Emptry the nodeList;
    nodeList.clear();
    
    float xSize = 800;
    float ySize = 800;
    
    float steps = 8; // Based on how many points we have, 
                                              // draw a new point at each step
    
    Iterator<nodeMetaData> nodeListIter = dotGraph.fullNodeList.iterator();

    for(  float yPos = 0; yPos < ySize; yPos+=steps){
      for(float xPos = 0; xPos < xSize; xPos+=steps){
        if(nodeListIter.hasNext()){
          nodeList.add(new ChordNode(nodeListIter.next().name,xPos+20,yPos+20));
        }
      }
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
  
  public void regenerateLayout(int layout){
    this.layout = layout;
      // Plot points on the circle
      
    if(layout<=0){
      plotPointsOnCircle(dotGraph.fullNodeList.size());
    }else if(layout==1){
      plotPointsOnGrid(dotGraph.fullNodeList.size());
    }
    
    // Quick hack so the visualization can render quickly
    storeLineDrawings();
    // Draw the mapping of the visualization (Different layouts may need different 
    generateHeatForCalleeAttribute();
  }
  
  public void draw(){
      fill(192);
      
      if(layout==0){
        ellipse(centerx,centery,radius*2,radius*2);
      }
      
      for(int i =0; i < nodeList.size();i++){
        ChordNode temp = (ChordNode)nodeList.get(i);
        temp.render();
      }
  }
  
}