/*
    This is a class that other classes can extend from to get data from
    The goal of this class is to store all common information from a visualization.
*/
public class DataLayer implements VisualizationLayout{
  
  // Where to draw the visualization
  public float xPosition;
  public float yPosition;
  // The layout of the nodes within the visualization
  public int layout;
  
  public float centerx = width/2;
  public float centery = height/2;
  
  public float defaultWidth = 4; // The default width of the bars in the histogram
  // Bounds
  // Stores how big the visualization is. Useful if we need to select items
  // or draw a background panel
  float xBounds = 0;
  float yBounds = 0;
  float zBounds = 0;
  
  // Toggle for showing the Visualization
  boolean showData = true;
  
  public DotGraph dotGraph;
  public ArrayList<ChordNode> nodeList;  // All of the nodes, that will be loaded from the dotGraph
       
  public void init(String file, float xPosition, float yPosition, int layout){ //DataLayer(String file, float xPosition, float yPosition){
     this.xPosition = xPosition;
     this.yPosition = yPosition;

    // Load up data
    // Note that the dotGraph contains the entire node list, and all of the associated meta-data with it.
    dotGraph = new DotGraph(file);
    // Create a list of all of our nodes that will be in the visualization
    nodeList = new ArrayList<ChordNode>();
    
    // Plot the points in some default configuration
    this.regenerateLayout(layout);

  }
  
  public void sortNodesByCallee(){
    Collections.sort(nodeList, new Comparator<ChordNode>(){
      @Override
      public int compare(ChordNode item1, ChordNode item2){
          Integer val1 = item1.metaData.callees;
          Integer val2 = item2.metaData.callees;
          
          // Descending order (reverse comare to do ascending order)
          return val2.compareTo(val1);
          //return item1.metaData.name.compareTo(item2.metaData.name); // uncomment this to sort based on 'string' value
      }
    });
    
      
  }
  
  /*
      This function is responsible for being called at initialization
      This populates nodeList which we can then use
      
      // What it does is
  */
  public void regenerateLayout(int layout){
    // Empty our list if it has not previously been emptied
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
  public void storeLineDrawings(){
    
      for(int i =0; i < nodeList.size(); i++){
        // Search to see if our node has outcoming edges
        nodeMetaData nodeName = nodeList.get(i).metaData;        // This is the node we are interested in finding sources
        nodeList.get(i).LocationPoints.clear();                       // Clear our old Locations because we'll be setting up new ones
        if (dotGraph.graph.containsKey(nodeName)){     // If we find out that it exists as a key(i.e. it is not a leaf node), then it has targets
          // If we do find that our node is a source(with targets)
          // then search to get all of the destination names and their positions
          ArrayList<nodeMetaData> dests = (dotGraph.graph.get(nodeName));
          for(int j = 0; j < dests.size(); j++){
              for(int k =0; k < nodeList.size(); k++){
                if(dests.get(j).name==nodeList.get(k).metaData.name){
                  nodeList.get(i).addPoint(nodeList.get(k).x,nodeList.get(k).y);          // Add to our source node the locations that we can point to
                  // Store some additional information
                  nodeList.get(i).metaData.callees++;
                  break;
                }
              }
          }
        }
      }
  }
  
  public void drawBounds(float r, float g, float b){
    fill(r,g,b);
    stroke(r,g,b);
    rect(xPosition+1,yPosition+1,xBounds,yBounds);
  }
  
  public void draw(int mode){
    // Do nothing, this method needs to be overridden
    rect(xPosition,yPosition,5,5);
    text("Visualization not rendering",xPosition,yPosition);
  }
  

  
}