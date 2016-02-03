


/*
    This is a class that other classes can extend from to get data from
    The goal of this class is to store all common information from a visualization.
    
    This class should not be instantiated (It should just be considered abstract with some functionality implemented)
*/
public class DataLayer implements VisualizationLayout{
   
  
  // The name of the visualization
  public String visualizationName = "Data Layer";

  // Where to draw the visualization
  public float xPosition;
  public float yPosition;
  // The layout of the nodes within the visualization
  public int layout;
  
  public float centerx = width/2.0;
  public float centery = height/2.0;
  
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
  public NodeListStack nodeListStack; 
  
  
  // Default sorting and colorize values of data
  int sortBy = CALLEE;
  int colorizeBy = CALLEE;
  
  // Store the max and min from the ChordNode metadata
  // Used primiarily when generateHeat is called
  float minCallees = 0;
  float maxCallees = 0;
  float minCallers = 0;
  float maxCallers = 0;
  float minPGO = 0;
  float maxPGO = 0;
  float minBitCodeSize = 0;
  float maxBitCodeSize = 0;

  
  
  /*
      Function that constructs this object.
      This class should only be extended on, and serves as a base class for other visualizations.
  */
  public void init(String file, float xPosition, float yPosition, int layout){ //DataLayer(String file, float xPosition, float yPosition){
     this.xPosition = xPosition;
     this.yPosition = yPosition;

    // Load up data
    // Note that the dotGraph contains the entire node list, and all of the associated meta-data with it.
    dotGraph = new DotGraph(file);     println("bbblah"); 
    // Create a list of all of our nodes that will be in the visualization
    // We eventually push a copy of this to the stack
    nodeList = new ChordNodeList("Initial Data");

    // Plot the points in some default configuration
    this.regenerateLayout(layout);
    nodeListStack = new NodeListStack();
    
    // Push the nodeList onto the stack
    nodeListStack.push(nodeList);
    println("after push nodeListStack.size(): "+nodeListStack.size());
    // nodeListStack.computeSummaryStatistics(); FIXME: Put this back in the code 
    
  }
  
  
  /*
      Sort the nodes
      
      TODO: Either make this function a 1-liner,
      or keep it as the way it is. If Processing decides
      to properly support Java enums, then the switch statement
      would make more sense.
  */
  public void sortNodesBy(){
    
      switch(sortBy){
        case CALLEE:
              this.nodeListStack.peek().sortNodesBy(sortBy);
              break;
        case CALLER:
              this.nodeListStack.peek().sortNodesBy(sortBy);
              break;
        case PGODATA:
              this.nodeListStack.peek().sortNodesBy(sortBy);
              break;
        case BITCODESIZE:
              this.nodeListStack.peek().sortNodesBy(sortBy);
              break;
        case RECURSIVE:
              this.nodeListStack.peek().sortNodesBy(sortBy);
              break;
      }   
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
      // Retrieve our pair from the dotgraph
      Map.Entry pair = (Map.Entry)nodeListIter.next();
      nodeMetaData m = (nodeMetaData)pair.getValue(); 
      ChordNode temp = new ChordNode(m.name,xPosition,yPosition,0);
      // Do a deep copy
      // This is annoying, but will work for now

      temp.metaData.callees           = m.callees;
      temp.metaData.max_callees       = m.max_callees;
      temp.metaData.callers           = m.callers;
      temp.metaData.max_callers       = m.max_callers;
      temp.metaData.recursive           = m.recursive;
      temp.metaData.maxNestedLoopCount  = m.maxNestedLoopCount;
      temp.metaData.attributes        = m.attributes;
      temp.metaData.annotations       = m.annotations;
      temp.metaData.metaData          = m.metaData;
      temp.metaData.OpCodes           = m.OpCodes;
      temp.metaData.PGOData           = parseMetaDataToPGO(temp.metaData.metaData); //m.PGOData;
      temp.metaData.PerfData          = m.PerfData;
      temp.metaData.ControlFlowData   = m.ControlFlowData;
      temp.metaData.bitCodeSize       = m.bitCodeSize;
      temp.metaData.extra_information = m.extra_information;
      
      temp.metaData.lineNumber   = m.lineNumber;
      temp.metaData.columnNumber = m.columnNumber;
      temp.metaData.sourceFile   = m.sourceFile;
      
      // Encoding information
      temp.metaData.stroke_encode   = m.stroke_encode;
      temp.metaData.strokeValue   = m.strokeValue;
      temp.metaData.blink_encode   = m.blink_encode;
      temp.metaData.blink_color   = m.blink_color;
      temp.metaData.symbol_encode   = m.symbol_encode;
      temp.metaData.symbol   = m.symbol;
      temp.metaData.rect_encode   = m.rect_encode;
      temp.metaData.small_rect_color   = m.small_rect_color;
      temp.metaData.spin_small_rect   = m.spin_small_rect;
      temp.metaData.spin_rotation   = m.spin_rotation;
            
      /*
          Copy all of the callee and caller information
      */
      temp.metaData.calleeLocations = m.calleeLocations;
      temp.metaData.callerLocations = m.callerLocations;     
//    println("temp.metaData.calleeLocations.size():"+temp.metaData.calleeLocations.size()+" | m.calleeLocations.size():"+m.calleeLocations.size());  
                  
      nodeList.add(temp);
      nodeListIter.remove(); // Avoid ConcurrentModficiationException
    }
  }
  
  /*
    Takes whatever metadata we have loaded,
    and specificially pulls out the functionentrycounts
  */
  public int parseMetaDataToPGO(String parseMe){

     int start = parseMe.indexOf("function_entry_counti64");
     if(start<0){
       return -1;
     }else{
       start += "function_entry_counti64".length();
     }
     int end = parseMe.length();
     
     return parseInt(parseMe.substring(start,end));
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
  
  /*
      Set which attribute to sort by
  */
  public void setSortBy(int sortBy){
    this.sortBy = sortBy;
  }
  
  /*
      Set which attribute to colorize by
  */
  public void setColorizeBy(int colorizeBy){
    this.colorizeBy = colorizeBy;
  }
  
  // Here maxHeight represents how many pixels we scale to (
  // (i.e. the maximum value in the set will equal this)
  void generateHeatForCalleeAttribute(float maxHeight, boolean setShape){
        
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
    // Then map that value into the ChordNode so that it can render correctly.
    // We scale from 
    for(int i =0; i < nodeListStack.peek().size();i++){

      switch(this.colorizeBy){
        case CALLEE:
              nodeListStack.peek().get(i).metaData.c = map(nodeListStack.peek().get(i).metaData.callees, minCallees, maxCallees, 0, 255);
              // Our shapes are rectangular, so we need to set this in the ChordNode
              if(setShape){
                nodeListStack.peek().get(i).rectWidth = defaultWidth;
                nodeListStack.peek().get(i).rectHeight = map(nodeListStack.peek().get(i).metaData.callees, minCallees, maxCallees, 0, maxHeight);
              }
              break;
        case CALLER:
              nodeListStack.peek().get(i).metaData.c = map(nodeListStack.peek().get(i).metaData.callers, minCallers, maxCallers, 0, 255);
              // Our shapes are rectangular, so we need to set this in the ChordNode
              if(setShape){
                nodeListStack.peek().get(i).rectWidth = defaultWidth;
                nodeListStack.peek().get(i).rectHeight = map(nodeListStack.peek().get(i).metaData.callers, minCallers, maxCallers, 0, maxHeight);
              }
              break;
        case PGODATA:
              nodeListStack.peek().get(i).metaData.c = map(nodeListStack.peek().get(i).metaData.PGOData, minPGO, maxPGO, 0, 255);
              // Our shapes are rectangular, so we need to set this in the ChordNode
              if(setShape){
                nodeListStack.peek().get(i).rectWidth = defaultWidth;
                nodeListStack.peek().get(i).rectHeight = map(nodeListStack.peek().get(i).metaData.PGOData, minPGO, maxPGO, 0, maxHeight);
              }
              break;
        case BITCODESIZE:
              nodeListStack.peek().get(i).metaData.c = map(nodeListStack.peek().get(i).metaData.bitCodeSize, minBitCodeSize, maxBitCodeSize, 0, 255);
              // Our shapes are rectangular, so we need to set this in the ChordNode
              if(setShape){
                nodeListStack.peek().get(i).rectWidth = defaultWidth;
                nodeListStack.peek().get(i).rectHeight = map(nodeListStack.peek().get(i).metaData.bitCodeSize, minBitCodeSize, maxBitCodeSize, 0, maxHeight);
              }
              break;
        case RECURSIVE:
              nodeListStack.peek().get(i).metaData.c = map(nodeListStack.peek().get(i).metaData.recursive, 0, 1, 0, 255);
              // Our shapes are rectangular, so we need to set this in the ChordNode
              if(setShape){
                nodeListStack.peek().get(i).rectWidth = defaultWidth;
                nodeListStack.peek().get(i).rectHeight = map(nodeListStack.peek().get(i).metaData.recursive, 0, 1, maxHeight/2, maxHeight);
              }
              break;
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
  //
  public void storeLineDrawings(){
   println("I think we might crash around here");                
   
   int iterations = nodeListStack.peek().size();
   
     // Get the top of the Stack and figure out which nodes actually exist.
     // We are only concerned with updating the nodes who are active.
      Map<String,ChordNode> topOfStackMap = nodeListStack.getTopStackMap();
      
      // Indexes
      // Create a map that is a string, and the value is the index into the top of the stack
      Map<String, Integer> topOfStackMapQuickAccess = new HashMap<String,Integer>();
      for(int i = 0; i < iterations; ++i){
        topOfStackMapQuickAccess.put(nodeListStack.peek().get(i).metaData.name,i);
        // Clear callees and callers because that gets mucked up
        nodeListStack.peek().get(i).metaData.calleeLocations.clear();
        nodeListStack.peek().get(i).metaData.callerLocations.clear();
      }
      
           
       /*
       // Update all of the positions of the callees from here quickly.
        int iterations = nodeListStack.peek().size();
        for(int i =0; i < iterations; i++){
            // Update all of the nodes.
            //nodeListStack.peek().get(i).
        }
        
        
           */
          
           
                // Faster hacked version
                println("callees storeLineDrawings size: "+nodeListStack.size());

                for(int i = 0; i < iterations; i++){      
                  
                      // Search to see if our node has outcoming edges
                      nodeMetaData nodeName = nodeListStack.peek().get(i).metaData;        // This is the node we are interested in finding sources
                      if (dotGraph.graph.containsKey(nodeName)){                           // If we find out that it exists as a key(i.e. it is not a leaf node), then it has targets
                        // If we do find that our node is a source(with targets)
                        // then search to get all of the destination names and their positions
                        LinkedHashSet<nodeMetaData> dests = (dotGraph.graph.get(nodeName));
                        Iterator<nodeMetaData> it = dests.iterator();
                        // Iterate through all of the callees in our current node
                        // We already know what they are, but now we need to map
                        // WHERE they are in the visualization screen space.
                        while(it.hasNext()){
                            nodeMetaData temp = it.next();
                            // When we find the key, add the values points
                            if(topOfStackMap.containsKey(temp.name)){
                                ChordNode value = topOfStackMap.get(temp.name);
                                nodeListStack.peek().get(i).metaData.addPoint(0,value.x,value.y,value.metaData.name, topOfStackMap.get(temp.name).metaData ,topOfStackMap.get(temp.name).metaData.calleeLocations );          // Add to our source node the locations that we can point to
                                //topOfStackMap.remove(temp); // Try to avoid ConcurrentModificationException Since top of stack is a temporary thing, this should be okay to do.
                                
                                // In theory there is a 1:1 relationship, so for every callee, it has a caller.
                                // TODO: Verify this pans out for leaf nodes, which might not have any callees(thus, dests.iterator() will return 0), but may have callers.
                                //       It is possible that this may not be a problem however.
                                float x_pos = nodeListStack.peek().get(i).x;
                                float y_pos = nodeListStack.peek().get(i).y;
                                String callerName = nodeListStack.peek().get(i).metaData.name;
                                
                                nodeMetaData n = topOfStackMap.get(nodeListStack.peek().get(i).metaData.name).metaData;
                                ChordNodeList cnl = topOfStackMap.get(nodeListStack.peek().get(i).metaData.name).metaData.callerLocations;
                                
                                // Add to our destination, a caller.
                                int dest_index = topOfStackMapQuickAccess.get(temp.name);
                                nodeListStack.peek().get(dest_index).metaData.addPoint(1,x_pos,y_pos,callerName,n,cnl);
                            }
                        }
                      }
                      
                   
                /*
                //println("callers storeLineDrawings size: "+nodeListStack.size());                      
                     // Search to see if our node has outcoming edges
                      nodeName = nodeListStack.peek().get(i).metaData;        // This is the node we are interested in finding sources
                      nodeListStack.peek().get(i).metaData.callerLocations.clear();    // Clear our old Locations because we'll be setting up new ones
                      for(int j=0; j < iterations; ++j){
                          nodeMetaData potentialCallerNode = nodeListStack.peek().get(j).metaData;        // Compare against this node
                          if (dotGraph.graph.containsKey(potentialCallerNode)){                           // If we find out that it exists as a key(i.e. it is not a leaf node), then it could have calls into our node
                                // If we do find that our node is a source(with targets)
                                // then search to get all of the destination names and their positions
                                // See if our potential caller contains the node we are interested in as a destination, thus
                                // it means we "call into" (caller) nodeName.
                                LinkedHashSet<nodeMetaData> dests = (dotGraph.graph.get(potentialCallerNode));
                                Iterator<nodeMetaData> it = dests.iterator();
                                // Iterate through all of the destinations, and see if the name matches the node we are intersted in.
                                while(it.hasNext()){
                                    nodeMetaData temp = it.next();
                                    // If a destination in our potential Caller matches our function, then we
                                    // know we call into our function 'nodeName'.
                                    if(temp.name.equals(nodeName.name)){
                                         //println("Adding a caller:"+potentialCallerNode.name+" to "+nodeName.name);
                                         ChordNode value = topOfStackMap.get(potentialCallerNode.name); // Retrieve the nodes values of the caller which contained a destination that matched our 'nodeName'
                                         nodeListStack.peek().get(i).metaData.addPoint(1,value.x,value.y,value.metaData.name, topOfStackMap.get(potentialCallerNode.name).metaData ,topOfStackMap.get(potentialCallerNode.name).metaData.callerLocations);
                                         break;
                                    }
                                }
                          }
                      }
                        
                  */
                  
                } // for(int i =0; i < iterations; i++){      

  }
  
  
  /*
      Pushes all of the selected nodes onto a stack
      This is the most generic way to push nodes onto a stack.
  
      Ideally this is tied to some keypress(Enter key)
  */
  synchronized public void pushSelectedNodes(){
      String name = "Selected Nodes";
     
      ChordNodeList selectedNodes = new ChordNodeList(name);
      
      int iterations = nodeListStack.peek().size();
      for(int i =0; i < iterations;i++){
        if(nodeListStack.peek().get(i).selected){
          // Do a deep copy of the nodes we are pushing
          nodeListStack.peek().get(i).selected = false; // deselect the node?
          ChordNode temp = nodeListStack.peek().get(i);
          //println(temp.printAll());
          selectedNodes.add(temp);
        }
      }
      
      if(selectedNodes.size()!=0){
      // Push the entire list
      nodeListStack.push(selectedNodes);
      }
  }
  
  /*
      Get selected Node Count
  */
  synchronized public int getSelectedNodeCount(){
      int result=0;
      int iterations = nodeListStack.peek().size();
      for(int i =0; i < iterations;i++){
          if(nodeListStack.peek().get(i).selected){
            result++;
          }

      }
      
      return result;
  }
  
    /*
      Pushes all of the selected nodes onto a stack
      This is the most generic way to push nodes onto a stack.
  
      Ideally this is tied to some keypress(Enter key)
      
      In this alternation, you can explicitly push onto your stack
      an arbritrary list of nodes. This is useful if you are linking
      together two visualizations and want to push on nodes from one
      visualization onto another.
  */
    synchronized public void pushSelectedNodes(ChordNodeList selectedNodes){
      //String name = "Selected Nodes";
      
      int iterations = nodeListStack.peek().size();
      for(int i =0; i < iterations;i++){
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
  synchronized public void deselectAllNodes(){
    int iterations = nodeListStack.peek().size();
    
      for(int i =0; i < iterations;i++){
        nodeListStack.peek().get(i).selected = false;
        nodeListStack.peek().get(i).highlighted = false;
      }
  }
    
    
    /*
      If a node is selected it will be deselected.
      
      If a node is not selected, it will be selected
  */
  synchronized public void invertSelectAllNodes(){
    int iterations = nodeListStack.peek().size();
    
      for(int i =0; i < iterations;i++){
        nodeListStack.peek().get(i).highlighted = false;
        
        if(nodeListStack.peek().get(i).selected){
          nodeListStack.peek().get(i).selected = false;
          continue;
        }
        
        if(!nodeListStack.peek().get(i).selected){
          nodeListStack.peek().get(i).selected = true;
          continue;
        }        
        
      }
      
      breadCrumbsString += "invertSelected";
  }  
    
  
  /*
      Filter Design pattern
      
      1.) Create a new ArrayList<ChordNode>
      2.) Loop through all nodes that are on the top of the stack
      3.) If they do not meet the criteria, then do not select them.
  */
  
  /*
  
  DEPRECATED: Replaced by 'selectRange'
  
  synchronized public void selectCallSites(int min, int max){
      String result = "Callsites "+selectionRangeMin+"-"+selectionRangeMax;

      int iterations = nodeListStack.peek().size();
      for(int i =0; i < iterations;i++){
        if(nodeListStack.peek().get(i).metaData.callees >= min && nodeListStack.peek().get(i).metaData.callees <= max){
          nodeListStack.peek().get(i).selected = true; 
        }
      }
      breadCrumbsString += result;
  }
  
  */
  
  /*
      Type - The encoding type
      
      Value - true or false if we are encoding
  */
  synchronized public void encodeNodesWith(int type, boolean value, String _symbol,boolean AnimateEncoding,boolean RectangleEncoding,boolean SymbolEncodoing){
      String result = "Callsites "+selectionRangeMin+"-"+selectionRangeMax;

      int iterations = nodeListStack.peek().size();
      
      for(int i =0; i < iterations;i++){
        if(nodeListStack.peek().get(i).selected && value==true){
            nodeListStack.peek().get(i).metaData.stroke_encode = true;
            nodeListStack.peek().get(i).metaData.strokeValue   = 255;
            nodeListStack.peek().get(i).metaData.blink_encode  = true;
            nodeListStack.peek().get(i).metaData.blink_color   = 255;
            nodeListStack.peek().get(i).metaData.symbol_encode = SymbolEncodoing;
            nodeListStack.peek().get(i).metaData.symbol        = _symbol;
            nodeListStack.peek().get(i).metaData.rect_encode   = RectangleEncoding;
            nodeListStack.peek().get(i).metaData.small_rect_color  = 255;
            nodeListStack.peek().get(i).metaData.spin_small_rect   = AnimateEncoding;
            nodeListStack.peek().get(i).metaData.spin_rotation     = 25;     
        }else if(nodeListStack.peek().get(i).selected && value==false){
            nodeListStack.peek().get(i).metaData.stroke_encode = false;
            nodeListStack.peek().get(i).metaData.strokeValue   = 255;
            nodeListStack.peek().get(i).metaData.blink_encode  = false;
            nodeListStack.peek().get(i).metaData.blink_color   = 255;
            nodeListStack.peek().get(i).metaData.symbol_encode = false;
            nodeListStack.peek().get(i).metaData.symbol        = "";
            nodeListStack.peek().get(i).metaData.rect_encode   = false;
            nodeListStack.peek().get(i).metaData.small_rect_color  = 255;
            nodeListStack.peek().get(i).metaData.spin_small_rect   = false;
            nodeListStack.peek().get(i).metaData.spin_rotation     = 25;              
        }
      }
      breadCrumbsString += result;
  }
  
  /*
      Selects all encoded nodes
  */
  synchronized public void selectEncodedNodes(){
      int iterations = nodeListStack.peek().size();
      
      for(int i =0; i < iterations;i++){
        if( nodeListStack.peek().get(i).metaData.stroke_encode || nodeListStack.peek().get(i).metaData.blink_encode || 
            nodeListStack.peek().get(i).metaData.symbol_encode || nodeListStack.peek().get(i).metaData.rect_encode || 
            nodeListStack.peek().get(i).metaData.spin_small_rect){
            // If we have an encoding, mark it as true
            nodeListStack.peek().get(i).selected=true;
            }
      }
  }
  
   /*
      Filter Design pattern
      
      1.) Create a new ArrayList<ChordNode>
      2.) Loop through all nodes that are on the top of the stack
      3.) If they do not meet the criteria, then do not select them.
      
      Takes an input that corresponds to the feature that we want to select.
  */
  synchronized public void selectRange(int input, int min, int max){
      String result = "Callsites "+selectionRangeMin+"-"+selectionRangeMax;

      int iterations = nodeListStack.peek().size();
      for(int i =0; i < iterations;i++){

            switch(input){
                case CALLEE:
                      if(nodeListStack.peek().get(i).metaData.callees >= min && nodeListStack.peek().get(i).metaData.callees <= max){
                        nodeListStack.peek().get(i).selected = true; 
                      }
                      break;
                case CALLER:
                      if(nodeListStack.peek().get(i).metaData.callers >= min && nodeListStack.peek().get(i).metaData.callers <= max){
                        nodeListStack.peek().get(i).selected = true; 
                      }
                      break;
                case PGODATA:
                      if(nodeListStack.peek().get(i).metaData.PGOData >= min && nodeListStack.peek().get(i).metaData.PGOData <= max){
                        nodeListStack.peek().get(i).selected = true; 
                      }
                      break;
                case BITCODESIZE:
                      if(nodeListStack.peek().get(i).metaData.bitCodeSize >= min && nodeListStack.peek().get(i).metaData.bitCodeSize <= max){
                        nodeListStack.peek().get(i).selected = true; 
                      }
                      break;
                case RECURSIVE:
                      if(nodeListStack.peek().get(i).metaData.recursive >= min && nodeListStack.peek().get(i).metaData.recursive <= max){
                        nodeListStack.peek().get(i).selected = true; 
                      }
                      break;
              }
        
        
      }
      breadCrumbsString += result;
  }
  
  
  /*
      Filter Design pattern
      
      1.) Create a new ArrayList<ChordNode>
      2.) Loop through all nodes that are on the top of the stack
      3.) If they do not meet the criteria, then do not select them.
  */
  synchronized public void selectCallers(int min, int max){
      String result = "Callsites "+selectionRangeMin+"-"+selectionRangeMax;

      int iterations = nodeListStack.peek().size();
      for(int i =0; i < iterations;i++){
        if(nodeListStack.peek().get(i).metaData.callers >= min && nodeListStack.peek().get(i).metaData.callers <= max){
          nodeListStack.peek().get(i).selected = true; 
        }
      }
      breadCrumbsString += result;
  }
  
  /*
      Functions that match the starting characters
      
      This will also return matches that 'contain' or are equal to the string
  */
  
    synchronized public void functionStartsWith(String text){
      String name = "Starts With: "+text;
      // The name we give to our list, so we can pop it off the stack by name if we need to.
      ChordNodeList filteredNodes = new ChordNodeList(name);
      
      int iterations = nodeListStack.peek().size();
      for(int i =0; i < iterations; i++){
        // Small hack we have to do for now, because all of our functions are
        // surrounded by quotes to work properly in the .dot format (because if we use
        // periods in the .dot format for function names, things break, thus we surround them
        // in quotes). Thus, the hack is we append a double quote to all searches.
        if(nodeListStack.peek().get(i).metaData.name.startsWith("\""+text) || nodeListStack.peek().get(i).metaData.name.contains(text)){
          filteredNodes.add(nodeListStack.peek().get(i));
          println("adding: "+nodeListStack.peek().get(i).metaData.name);
        }
      }
      nodeListStack.push(filteredNodes);
      
      breadCrumbsString += "functionsStartWith "+ text;
  }
  
  /*
      Functions that match the starting characters
      
      This will also return matches that 'contain' and just select them in the current visualization
  */
  
    synchronized public void functionStartsWithSelect(String text){
      //String name = "Select and Starts With: "+text;
      // The name we give to our list, so we can pop it off the stack by name if we need to.

      int iterations = nodeListStack.peek().size();
      for(int i =0; i < iterations; i++){
        // Small hack we have to do for now, because all of our functions are
        // surrounded by quotes to work properly in the .dot format (because if we use
        // periods in the .dot format for function names, things break, thus we surround them
        // in quotes). Thus, the hack is we append a double quote to all searches.
        if(nodeListStack.peek().get(i).metaData.name.startsWith("\""+text) || nodeListStack.peek().get(i).metaData.name.contains(text)){
          nodeListStack.peek().get(i).selected = true;
        }
      }
      
      breadCrumbsString += "functionStartWIth "+text;
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
  synchronized public void highlightNodes(ChordNodeList cnl, boolean value){
      // It's possible that cnl or the top of the nodeListStack has been filtered
      // so we need to make sure we check every node against each other.
      // Unfortunately, since we have lists as data structures, this mean O(N^2) time.
      // TODO: Possibly convert everything to map's so we can reduced this to O(N) time.
      // WORKAROUND: Once we find the index of the first item, since they are sorted,
      // we should be able to just linearly scan from that starting point instead of always
      // starting from the beginning. Note this could lead to a bug if the nodes are unsorted
      // or in some random order.
      
      
      //Map<String,ChordNode> topOfStackMap = nodeListStack.getTopStackMap();

/*
      int firstIndex = 0;
      
      int iterations = nodeListStack.peek().size();
      for(int i =0; i < cnl.size(); ++i){
          for(int j = firstIndex; j < iterations; ++j){
            if(cnl.get(i).metaData.name.equals(nodeListStack.peek().get(j).metaData.name)){
              nodeListStack.peek().get(j).highlighted = value;
              firstIndex = j;
              break;
            }
          }
      }
      
*/
      /*
      (1) Convert the top of the stack to a map
      (2) Iterate through the list once, and in another map, and get indicess into it
      (3) 
      
      
      */
      Map<String,ChordNode> topOfStackMap = nodeListStack.getTopStackMap();
      Map<String,Integer> nameToIndex = new HashMap<String,Integer>();
      int iterations = nodeListStack.peek().size();
      for(int i =0; i < iterations; ++i){
        nameToIndex.put(nodeListStack.peek().get(i).metaData.name,i);
      }
      
      
      // Now look through our list
      for(int i =0; i < cnl.size(); ++i){
          // If something from cnl is in our stack
          // then we record the index and edit our actual nodeListStack
          if(topOfStackMap.containsKey(cnl.get(i).metaData.name)){
            int index = nameToIndex.get(cnl.get(i).metaData.name);
            nodeListStack.peek().get(index).highlighted = value;
          }
      }
      
  }
  
    // This command takes in a ChordNodeList from one visualization
  // and then highlights the other visualizations nodes on the top of its stack.
  //
  // We can also unhighlight nodes by passing in a value of 'false'
  //
  synchronized public void setNodesColors(ChordNodeList cnl, int r, int g, int b){

      Map<String,ChordNode> topOfStackMap = nodeListStack.getTopStackMap();
      Map<String,Integer> nameToIndex = new HashMap<String,Integer>();
      int iterations = nodeListStack.peek().size();
      for(int i =0; i < iterations; ++i){
        nameToIndex.put(nodeListStack.peek().get(i).metaData.name,i);
      }
      
      // Now look through our list
      for(int i =0; i < cnl.size(); ++i){
          // If something from cnl is in our stack
          // then we record the index and edit our actual nodeListStack
          if(topOfStackMap.containsKey(cnl.get(i).metaData.name)){
            int index = nameToIndex.get(cnl.get(i).metaData.name);
            nodeListStack.peek().get(index).r = r;
            nodeListStack.peek().get(index).g = g;
            nodeListStack.peek().get(index).b = b;
          }
      }
  }
  
  /* 
      Highlight exactly one node
      
      This function is useful if you're working on a very fine grained
      level, such as a long bargraph with many functions.
  */
  synchronized public void highlightNode(ChordNode cn, boolean value){
    int iterations = nodeListStack.peek().size();
    for(int j = 0; j < iterations; ++j){
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
      ConcurrentHashMap<String, ChordNode> quickConvert = new ConcurrentHashMap<String, ChordNode>();
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
  synchronized public void toggleActiveNodes(ChordNodeList cnl){
      // It's possible that cnl or the top of the nodeListStack has been filtered
      // so we need to make sure we check every node against each other.
      // Unfortunately, since we have lists as data structures, this mean O(N^2) time.
      // TODO: Possibly convert everything to map's so we can reduced this to O(N) time.
     /*
      
      int iterations = nodeListStack.peek().size();
      
      for(int i =0; i < cnl.size(); ++i){    
          for(int j = 0; j < iterations; ++j){
            if(cnl.get(i).metaData.name.equals(nodeListStack.peek().get(j).metaData.name)){
              nodeListStack.peek().get(j).selected = !nodeListStack.peek().get(j).selected; // Modify the node we have found. 
              break;
            }
          }
      }
      
      */
      
      Map<String,ChordNode> topOfStackMap = nodeListStack.getTopStackMap();
      Map<String,Integer> nameToIndex = new HashMap<String,Integer>();
      int iterations = nodeListStack.peek().size();
      for(int i =0; i < iterations; ++i){
        nameToIndex.put(nodeListStack.peek().get(i).metaData.name,i);
      }
      
      
      // Now look through our list
      for(int i =0; i < cnl.size(); ++i){
          // If something from cnl is in our stack
          // then we record the index and edit our actual nodeListStack
          if(topOfStackMap.containsKey(cnl.get(i).metaData.name)){
            int index = nameToIndex.get(cnl.get(i).metaData.name);
            nodeListStack.peek().get(index).selected = !nodeListStack.peek().get(index).selected;
          }
      }
      
      
  }
  
  
  /* 
      Select exactly one node

      This function is useful if you're working on a very fine grained
      level, such as a long bargraph with many functions.
  */
  synchronized public void toggleActiveNode(ChordNode cn){
    int iterations = nodeListStack.peek().size();
    
    for(int j = 0; j < iterations; ++j){
        if(cn.metaData.name.equals(nodeListStack.peek().get(j).metaData.name)){
          nodeListStack.peek().get(j).selected = !nodeListStack.peek().get(j).selected; // Modify the node we have found. 
          break;
        }
     }
  }
  
  
  /*
      Toggle all of the callees as well as the node we are selecting
      
      Based on the node we are selecting
  */
  synchronized public void toggleCallees(ChordNode cn){
    println("About to toggle callees:"+cn.metaData.calleeLocations.size()); 
    int iterations = nodeListStack.peek().size();
    
    for(int j = 0; j < iterations; ++j){
        if(cn.metaData.name.equals(nodeListStack.peek().get(j).metaData.name)){
          nodeListStack.peek().get(j).selected = true;//!nodeListStack.peek().get(j).selected; // Modify the node we have found. 
          for(int i = 0; i < nodeListStack.peek().get(j).metaData.calleeLocations.size(); ++i){
            nodeListStack.peek().get(j).metaData.calleeLocations.get(i).selected = true;// nodeListStack.peek().get(j).selected;
          }
          break;
        }
     }
  }
  
  /*
      Quickly select nodes by holding down a key
  */
  
  synchronized public void select(ChordNode cn, boolean value){
    int iterations = nodeListStack.peek().size();
    
    println("select: "+value);
    for(int j = 0; j < iterations; ++j){
        if(cn.metaData.name.equals(nodeListStack.peek().get(j).metaData.name)){
          nodeListStack.peek().get(j).selected = value; // Modify the node we have found. 
          println("setting: " + nodeListStack.peek().get(j).metaData.name + " to " +value);
          break; 
        }
     }
  }
  
  
  /*
      Quickly select node and all of its callees up to the specified depth
  */
  synchronized public void selectCallees(ChordNode cn, boolean value, int theDepth){
    int iterations = nodeListStack.peek().size();
    
    println("select: "+value);
    for(int j = 0; j < iterations; ++j){
        if(cn.metaData.name.equals(nodeListStack.peek().get(j).metaData.name)){
          nodeListStack.peek().get(j).selected = value; // Modify the node we have found. 
          
                for(int i =0; i < cn.metaData.calleeLocations.size();i++){
                    for(int k =0; k < iterations; ++k){
                        if(cn.metaData.calleeLocations.get(i).metaData.name.equals(nodeListStack.peek().get(k).metaData.name)){
                            nodeListStack.peek().get(k).selected = value; // Modify the node we have found. 
                            // recursively call our function again.
                            if(theDepth>1){
                              selectCallees(nodeListStack.peek().get(k), value, theDepth-1);
                            }
                        }
                    }

                }
          
          break; 
        }
     }
     
     breadCrumbsString += "select Callees";
  }
  
  /*
      Quickly select node and all of its callers up to the specified depth
  */
  
  synchronized public void selectCallers(ChordNode cn, boolean value, int theDepth){
    int iterations = nodeListStack.peek().size();
    
    println("select caller: "+value);
    for(int j = 0; j < iterations; ++j){
        if(cn.metaData.name.equals(nodeListStack.peek().get(j).metaData.name)){
          nodeListStack.peek().get(j).selected = value; // Modify the node we have found. 
          
                for(int i =0; i < cn.metaData.callerLocations.size();i++){
                    for(int k =0; k < iterations; ++k){
                        if(cn.metaData.callerLocations.get(i).metaData.name.equals(nodeListStack.peek().get(k).metaData.name)){
                            nodeListStack.peek().get(k).selected = value; // Modify the node we have found. 
                            // recursively call our function again.
                            if(theDepth>1){
                              selectCallers(nodeListStack.peek().get(k), value, theDepth-1);
                            }
                        }
                    }
                }
          
          break; 
        }
     }
     
     breadCrumbsString += "select Callers";
  }
  
  synchronized public void getCallTree(ChordNode cn, boolean value, int theDepth){
  }
  
  
  /*
      This function syncs up two nodeListStack's such that the visualizations
      are linked together.
      
      There is some uncertaintly as if this is the best way to do things, or if
      one can break the link in a way that makes sense.
      
  */
  synchronized public void setNodeListStack(NodeListStack nsl){
    this.nodeListStack = nsl;   
  }
  
    
  /*
      Returns all of data from this data structure
  */
  public NodeListStack getNodeListStack(){
    return this.nodeListStack;
  }
  
  
  /*
    
    Quickly select all the nodes that have some metaData
        
  */
  
  synchronized public void selectMetaData(){
    int iterations = nodeListStack.peek().size();
    
    for(int j = 0; j < iterations; ++j){
        if(nodeListStack.peek().get(j).metaData.metaData.length() >0){
          nodeListStack.peek().get(j).selected = true; // Modify the node we have found. 
        }
     }
  }
  
  /*
    
    Quickly select all the nodes that have some attributes
        
  */
  
  synchronized public void selectAttributes(){
    int iterations = nodeListStack.peek().size();
    
    for(int j = 0; j < iterations; ++j){
        if(nodeListStack.peek().get(j).metaData.attributes.length() >0){
          nodeListStack.peek().get(j).selected = true; // Modify the node we have found. 
          println(nodeListStack.peek().get(j).metaData.name);
        }
     }
  }
  
  
  /*
    
    Quickly select all the nodes that have line information
        
  */
  
  synchronized public void selectLineInformation(){
    int iterations = nodeListStack.peek().size();
    
    for(int j = 0; j < iterations; ++j){
        if(!nodeListStack.peek().get(j).metaData.sourceFile.equals("/n/a") && !nodeListStack.peek().get(j).metaData.sourceFile.equals("no/information/found")){
          nodeListStack.peek().get(j).selected = true; // Modify the node we have found. 
        }
     }
  }
  
  /* ******************************
      Annotations
  ******************************* */
  // 
  // The goal of this function is to make a list of functions that will
  // get read in by a pass and add attributes to a function.
  //
  // s - the annotation we are adding
  // value - true/false or some other thing that could effect the annotation.
  //
  void annotateSelected(String s, String value){
        int iterations = nodeListStack.peek().size();
    
        println("Annotation: "+s);
        
        PrintWriter output;
        output = createWriter("./annotations.txt");
        for(int j = 0; j < iterations; ++j){
            if(nodeListStack.peek().get(j).selected){
              output.println(nodeListStack.peek().get(j).metaData.name+" "+s+" "+value);
            }
        }
        
        output.flush();
        output.close();
  }
  
    /* **************************
          Call Graph Metrics
     ************************** */
  // Returns a string if a path exists wherby a calls b
  // That is, 'a' is a parent, great-grandparent, great-great-grandparent, etc. of 'b'.
  public String aCallB(ChordNode a, ChordNode b){
      String result = "No path from: "+a.metaData.name+" to "+b.metaData.name;
      String path = "No path exists";  // Build a path.
      
      Queue<ChordNode> bfs = new LinkedList<ChordNode>();
      bfs.add(a);
      
      while(!bfs.isEmpty()){
          
          ChordNode temp = bfs.remove();
          
          // Searches the list
          for(int i =0; i< temp.metaData.calleeLocations.size(); ++i){
              if(temp.metaData.calleeLocations.get(i).metaData.name.equals(b.metaData.name)){
                result="yup a path exists!";
              }
              bfs.add(temp.metaData.calleeLocations.get(i));
          }
      }
      
      return result;
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