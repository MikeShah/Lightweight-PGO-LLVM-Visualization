class LocPoint{
 float x;
 float y;
 LocPoint(float x, float y){
   this.x = x;
   this.y = y;
 }
}

// Node class consits of a source
class ChordNode{
  float x;
  float y;
  public nodeMetaData metaData;
  int nodeSize = 4;
  
  boolean selected = false;
  
  ArrayList<LocPoint> LocationPoints;
  
  public ChordNode(String name, float x, float y){
    this.metaData = new nodeMetaData(name);
    this.x = x;
    this.y = y;
    
    LocationPoints = new ArrayList<LocPoint>();
  }
  
  void addPoint(float x, float y){
    LocationPoints.add(new LocPoint(x,y));
  }
  
  public void render(){
       
     if( dist(x,y,mouseX,mouseY) < nodeSize || selected){
        fill(0);
        if(selected){fill(255,0,0);}
        ellipse(x,y,nodeSize*2,nodeSize*2);
        
        fill(255,0,0);
        drawToCallees();
        fill(255);
        text(metaData.name,x,y);
        
        if(mousePressed && dist(x,y,mouseX,mouseY) < nodeSize){
          selected = !selected;
        }
     }
     else{
        fill(192);
        ellipse(x,y,8,8);
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


class ChordDiagram{
  
  float radius = 300;
  float centerx = width/2;
  float centery = height/2;
  
  DotGraph dotGraph;
  ArrayList<ChordNode> nodeList;  // All of the nodes, that will be loaded from the dotGraph
      
  public ChordDiagram(String file){
    // Load up data
    dotGraph = new DotGraph(file);
    // Print out to console (for debugging-purposes only)
 //   dotGraph.printGraph();
    // Create a list of all of our nodes that will be in the visualization
    nodeList = new ArrayList<ChordNode>();
    // Plot points on the circle
    plotPointsOnCircle(dotGraph.fullNodeList.size());
    // Quick hack so the visualization can render quickly
    storeLineDrawings();
  }
  
    /*
  
   h = center
   k = center
   r = radius
   numberOfPoints = How many points to draw on the circle
   
  */
  public void plotPointsOnCircle(float numberOfPoints){
    
    float steps = 360/numberOfPoints; // Based on how many points we have, 
                                      // draw a new point at each step
    float theta = 0; // angle to increase each loop
    
    
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
                  break;
                }
              }
          }
        }
      }
  }
  
  public void draw(){
      fill(192);
      ellipse(centerx,centery,radius*2,radius*2);
      for(int i =0; i < nodeList.size();i++){
        ChordNode temp = (ChordNode)nodeList.get(i);
        temp.render();
      }
  }
  
}