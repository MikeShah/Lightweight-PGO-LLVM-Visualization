/*
    This is a class that other classes can extend from to get data from
    The goal of this class is to store all common information from a visualization.
    
    This class should not be instantiated (It should just be considered abstract with some functionality implemented)
*/
public class DataLayer implements VisualizationLayout{
  // The name of the visualization
  public String VisualizationName = "Data Layer";

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
  public float xBounds = 0;
  public float yBounds = 0;
  public float zBounds = 0;
    
  // Toggle for showing the Visualization
  boolean showData = true;
  // Store our dotGraph
  public DotGraph dotGraph;
  public ChordNodeList nodeList;  // All of the nodes, that will be loaded from the dotGraph
  // Create a stack of the nodes
  NodeListStack nodeListStack; 
  
  /*
      Function that constructs this object.
      This class should only be extended on, and serves as a base class for other visualizations.
  */
  public void init(String file, float xPosition, float yPosition, int layout){ //DataLayer(String file, float xPosition, float yPosition){
     this.xPosition = xPosition;
     this.yPosition = yPosition;

    // Load up data
    // Note that the dotGraph contains the entire node list, and all of the associated meta-data with it.
    dotGraph = new DotGraph(file);
    // Create a list of all of our nodes that will be in the visualization
    // We eventually push a copy of this to the stack
    nodeList = new ChordNodeList("Initial Data");
    
    // Plot the points in some default configuration
    this.regenerateLayout(layout);
    
    nodeListStack = new NodeListStack();
    // Push the nodeList onto the stack
    nodeListStack.push(nodeList);
    
  }
  
  public void sortNodesByCallee(){
    this.nodeListStack.peek().sortNodes();
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
    Iterator nodeListIter = dotGraph.fullNodeList.entrySet().iterator();
    while(nodeListIter.hasNext()){
      Map.Entry pair = (Map.Entry)nodeListIter.next();
      nodeMetaData m = (nodeMetaData)pair.getValue(); 
      ChordNode temp = new ChordNode(m.name,xPosition,yPosition,0);
      // Do a deep copy
      // This is annoying, but will work for now
      temp.metaData.callees           = m.callees;
      temp.metaData.attributes        = m.attributes;
      temp.metaData.annotations       = m.annotations;
      temp.metaData.metaData          = m.metaData;
      temp.metaData.OpCodes           = m.OpCodes;
      temp.metaData.PGOData           = m.PGOData;
      temp.metaData.PerfData          = m.PerfData;
      temp.metaData.ControlFlowData   = m.ControlFlowData;
      temp.metaData.extra_information = m.extra_information;
    
      nodeList.add(temp);
      nodeListIter.remove(); // Avoid ConcurrentModficiationException
    }
  }
  
  /*
      Sets the position of our visualization
  */
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
      nodeListStack.peek().get(i).metaData.callees = (int)map(nodeListStack.peek().get(i).metaData.callees, themin, themax, 0, maxHeight);
      
      // Our shapes are rectangular, so we need to set this in the ChordNode
      nodeListStack.peek().get(i).rectWidth = defaultWidth;
      nodeListStack.peek().get(i).rectHeight = nodeListStack.peek().get(i).metaData.callees;
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
      
/*     //Original 
      for(int i =0; i < nodeListStack.peek().size(); i++){
        // Search to see if our node has outcoming edges
        nodeMetaData nodeName = nodeListStack.peek().get(i).metaData;        // This is the node we are interested in finding sources
        nodeListStack.peek().get(i).LocationPoints.clear();                  // Clear our old Locations because we'll be setting up new ones
        if (dotGraph.graph.containsKey(nodeName)){     // If we find out that it exists as a key(i.e. it is not a leaf node), then it has targets
          // If we do find that our node is a source(with targets)
          // then search to get all of the destination names and their positions
          ArrayList<nodeMetaData> dests = (dotGraph.graph.get(nodeName));
          for(int j = 0; j < dests.size(); j++){
              for(int k =0; k < nodeListStack.peek().size(); k++){
                if(dests.get(j).name==nodeListStack.peek().get(k).metaData.name){
                  nodeListStack.peek().get(i).addPoint(nodeListStack.peek().get(k).x,nodeListStack.peek().get(k).y,nodeListStack.peek().get(k).metaData.name);          // Add to our source node the locations that we can point to
                  // Store some additional information
                  nodeListStack.peek().get(i).metaData.callees++;
                  break;
                }
              }
          }
        }
      }
*/     
      
      Map<String,ChordNode> topOfStackMap = nodeListStack.getTopStackMap();

      // Faster hacked version
      for(int i =0; i < nodeListStack.peek().size(); i++){
        
        // Search to see if our node has outcoming edges
        nodeMetaData nodeName = nodeListStack.peek().get(i).metaData;        // This is the node we are interested in finding sources
        nodeListStack.peek().get(i).LocationPoints.clear();                  // Clear our old Locations because we'll be setting up new ones
        if (dotGraph.graph.containsKey(nodeName)){                           // If we find out that it exists as a key(i.e. it is not a leaf node), then it has targets
        
          // If we do find that our node is a source(with targets)
          // then search to get all of the destination names and their positions
          LinkedHashSet<nodeMetaData> dests = (dotGraph.graph.get(nodeName));
          int stop = dests.size(); // if we add all of our destinations, then stop iterating.
          Iterator<nodeMetaData> it = dests.iterator();
          
          // Iterate through all of the callees in our current node
          // We already know what they are, but now we need to map
          // WHERE they are in the visualization screen space.
          
          while(it.hasNext()){
              nodeMetaData temp = it.next();
              // When we find the key, add the values points
              if(topOfStackMap.containsKey(temp.name)){
                  ChordNode value = topOfStackMap.get(temp.name);
                  nodeListStack.peek().get(i).addPoint(value.x,value.y,value.metaData.name);          // Add to our source node the locations that we can point to
                  // Store some additional information (i.e. update our callees count.
                  // TODO: This number is only of the visible callees, perhaps we want a maximum value?
                  nodeListStack.peek().get(i).metaData.callees++;
              }
              
              /*
              for(int k =0; k < nodeListStack.peek().size(); k++){                  // This loop can likely go
                  if(temp.name == nodeListStack.peek().get(k).metaData.name){
                    nodeListStack.peek().get(i).addPoint(nodeListStack.peek().get(k).x,nodeListStack.peek().get(k).y,nodeListStack.peek().get(k).metaData.name);          // Add to our source node the locations that we can point to
                    // Store some additional information
                    nodeListStack.peek().get(i).metaData.callees++;
                    stop--;
                    //break;
                  }
                  // break out of the while loop if we've added all of our destinations.
                  if(stop<=0){
                    break;
                  }
              }
              // Increment our iterator
              */
              
          }
        }
      }
      
  }
  
  
  /*
      Pushes all of the selected nodes onto a stack
      This is the most generic way to push nodes onto a stack.
  
      Ideally this is tied to some keypress(Enter key)
  */
  public void pushSelectedNodes(){
      String name = "Selected Nodes";
    
      ChordNodeList selectedNodes = new ChordNodeList(name);
      for(int i =0; i < nodeListStack.peek().size();i++){
        if(nodeListStack.peek().get(i).selected){
          selectedNodes.add(nodeListStack.peek().get(i));
        }
      }
      nodeListStack.push(selectedNodes);
  }
  
  /*
      Unselects all nodes.
      
      This is a convenience function
  
      Ideally this is tied to some keypress(Space key)
  */
  public void deselectAllNodes(){
      for(int i =0; i < nodeListStack.peek().size();i++){
        nodeListStack.peek().get(i).selected = false;
        nodeListStack.peek().get(i).highlighted = false;
      }
  }
    
  
    /*
      Filter Design pattern
      
      1.) Create a new ArrayList<ChordNode>
      2.) Loop through all nodes that are on the top of the stack
      3.) If they do not meet the criteria, then do not add them to the list.
      4.) Push the arrayList we have built on top of the stack
  */
  public void filterCallSites(int min, int max){
      String name = "Callsites "+callSiteMin+"-"+callSiteMax;
    
      ChordNodeList filteredNodes = new ChordNodeList(name);
      for(int i =0; i < nodeListStack.peek().size();i++){
        if(nodeListStack.peek().get(i).metaData.callees >= min && nodeListStack.peek().get(i).metaData.callees <= max){
          filteredNodes.add(nodeListStack.peek().get(i));
        }
      }
      nodeListStack.push(filteredNodes);
  }
  
  /*
      GUI Controls for this component to filter.
  */
  public void GUIControls(){
    
  }
  
  
  /* *******************************
          Data Link Routines
     ******************************* */  
/*  The purpose of these commands are to share data between visualizations.
    Early on I decided that I wanted each visualization to be able to be explored
    independently of the others, and leave the microarray as the key diagram.
    
    However, it has become useful to use visualizations such as 'Buckets' to
    quickly filter the microarray for particular criteria.
*/

  // This command takes in a ChordNodeList from one visualization
  // and then highlights the other visualizations nodes on the top of its stack.
  //
  // We can also unhighlight nodes by passing in a value of 'false'
  //
  public void highlightNodes(ChordNodeList cnl, boolean value){
      // It's possible that cnl or the top of the nodeListStack has been filtered
      // so we need to make sure we check every node against each other.
      // Unfortunately, since we have lists as data structures, this mean O(N^2) time.
      // TODO: Possibly convert everything to map's so we can reduced this to O(N) time.
      // WORKAROUND: Once we find the index of the first item, since they are sorted,
      // we should be able to just linearly scan from that starting point instead of always
      // starting from the beginning. Note this could lead to a bug if the nodes are unsorted
      // or in some random order.
      int firstIndex = 0;
      for(int i =0; i < cnl.size(); ++i){
          for(int j = firstIndex; j < nodeListStack.peek().size(); ++j){
            if(cnl.get(i).metaData.name.equals(nodeListStack.peek().get(j).metaData.name)){
              nodeListStack.peek().get(j).highlighted = value;
              firstIndex = j;
              break;
            }
          }
      }
  }
  
  /* 
      Highlight exactly one node
      
      This function is useful if you're working on a very fine grained
      level, such as a long bargraph with many functions.
  */
  public void highlightNode(ChordNode cn, boolean value){
    for(int j = 0; j < nodeListStack.peek().size(); ++j){
        if(cn.metaData.name.equals(nodeListStack.peek().get(j).metaData.name)){
          nodeListStack.peek().get(j).highlighted = value; // Modify the node we have found. 
          break;
        }
      }
  }
  
  /*
    public void highlightNodes(ChordNodeList cnl, boolean value){
      // It's possible that cnl or the top of the nodeListStack has been filtered
      // so we need to make sure we check every node against each other.
      // Unfortunately, since we have lists as data structures, this mean O(N^2) time.
      // TODO: Possibly convert everything to map's so we can reduced this to O(N) time.

      // Put everything into a hashmap from the cnl list (items we're trying to highlight,
      // and then modify the nodes in another loop
      HashMap<String, ChordNode> quickConvert = new HashMap<String, ChordNode>();
      for(int i =0; i < nodeListStack.peek().size(); ++i){
        quickConvert.put(nodeListStack.peek().get(i).metaData.name,nodeListStack.peek().get(i));
      }
      
      
      for(int i = 0; i < cnl.size(); ++i){
        quickConvert.get(cnl.get(i).metaData.name).selected = value;
        
        if((nodeListStack.peek().get(j).metaData.name)){
          nodeListStack.peek().get(j).highlighted = value;
          break;
        }
      }

  }
  
  */
  
    // This command takes in a ChordNodeList from one visualization
    // and then toggles the other visualizations nodes being active.
    public void toggleActiveNodes(ChordNodeList cnl){
      // It's possible that cnl or the top of the nodeListStack has been filtered
      // so we need to make sure we check every node against each other.
      // Unfortunately, since we have lists as data structures, this mean O(N^2) time.
      // TODO: Possibly convert everything to map's so we can reduced this to O(N) time.
      for(int i =0; i < cnl.size(); ++i){
        
          for(int j = 0; j < nodeListStack.peek().size(); ++j){
            if(cnl.get(i).metaData.name.equals(nodeListStack.peek().get(j).metaData.name)){
              nodeListStack.peek().get(j).selected = !nodeListStack.peek().get(j).selected; // Modify the node we have found. 
              break;
            }
          }
      }
  }
  
  
  /* 
      Select exactly one node

      This function is useful if you're working on a very fine grained
      level, such as a long bargraph with many functions.
  */
  public void toggleActiveNode(ChordNode cn){
    for(int j = 0; j < nodeListStack.peek().size(); ++j){
        if(cn.metaData.name.equals(nodeListStack.peek().get(j).metaData.name)){
          nodeListStack.peek().get(j).selected = !nodeListStack.peek().get(j).selected; // Modify the node we have found. 
          break;
        }
      }
  }
  
  
  // Generally this method should be overridden.
  // It is called whenver we need to update what data is active
  // on the visualization. Generally after filtering we would want
  // to call this.
  public void update(){
  }
  
  /* *******************************
          Drawing Routines
     ******************************* */  
  
  // Draw a rectangle around our visualization
  // Useful for knowing where we can draw and position our visualization
  public void drawBounds(float r, float g, float b, float xPosition, float yPosition){
    fill(r,g,b);
    stroke(r,g,b);
    rect(xPosition+1,yPosition+1,xBounds,yBounds);
  }
  
  
  // Draw our actual visualization
  public void draw(int mode){
    // Do nothing, this method needs to be overridden
    rect(xPosition,yPosition,5,5);
    text("Visualization not rendering",xPosition,yPosition);
  }
  


  
}