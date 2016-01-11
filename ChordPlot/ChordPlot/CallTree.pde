/*
    This class serves as the details window to display other information.
*/
class CallTreeWindow extends commonWidget {
  
  // a self-contained 
  CallTree m_calltree;
  String filename;

  public CallTreeWindow(String filename){
    this.filename = filename;
    println("a from CallTreeWindow");
    m_calltree = new CallTree(filename,0,height-30,0);
  }
  
  public void settings() {
    size(1440, 350, P3D);
    smooth();
  }
    
  public void setup() { 
      surface.setTitle(windowTitle);
      surface.setLocation(0, 350);
  }
  
  int p_node_old = -1;
  int p_node = -1;
  Set<Integer> selectedNodes = new HashSet<Integer>();
  
  /*
    Interactive rendering loop
    
    This is where we can interact with our visualization
    Depending on what we select, details can change
  */
  public void draw() {
    
    if(m_calltree != null){
    
      float m_x = mouseX;
      float m_y = mouseY;   
    
      // Refresh the screen    
      background(0,64,128);
        text("FPS :"+frameRate,width-100,height-20);
        text("(x,y) => ("+m_x+","+m_y+")",width-200,height-20);
           
         
          // Main loop that draws
          for(int i =0; i < cd.nodeListStack.peek().size();i++){ // FIXME: Well, this visualization is only useful if it is directly attached to the 'cd', so just work with that data directly.
                                                                          //        Current bug is                           
            ChordNode temp = (ChordNode)cd.nodeListStack.peek().get(i);
            
            if(temp.selected==true){
                   if(mouseButton==RIGHT){
                       // Pass a data string to our child applet and store it here.
                       dp.setDataString("Data:"+temp.metaData.getAllMetadata());
                   }
                              
                  // If our node has been selected, then highlight it green
                  if(selectedNodes.contains(i)){
                    fill(0,255,0,255); stroke(255);
                  }
                  
                  // Draw rectangle for each of the buckets.
                  rect(temp.x,temp.y - temp.rectHeight,temp.rectWidth,temp.rectHeight);
                }
          }
        
    }
  }
  
} // class CallTreeWindow extends commonWidget 


class CallTree extends DataLayer{
  
  int scaledHeight = 250; // Normalize visualization height and values to this
  
  // Default Constructor for the Histogram
  public CallTree(String file, float xPosition, float yPosition, int layout){
    this.visualizationName = "CallTree";
    println("a m_calltree");
    super.init(file, xPosition, yPosition,layout);
    println("b m_calltree");
    // Set a layout
    this.setLayout(layout);
    // Compute initial statistics
    //FIXME: Put me back in later nodeListStack.computeSummaryStatistics();
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
    generateHeatForCalleeAttribute(scaledHeight,true);
    
    sortNodesBy();
    
    // Modify all of the physical locations in our nodeList
    fastUpdate();
    
    // Quick hack so the visualization can render quickly, also calculates the number of callees from the caller
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
    // Modify all of the positions in our nodeList
    if(this.layout <= 0){
      plotPoints2D();
    }else{
      println("No other other layout, using default");
      plotPoints2D();
    }
  }
  
  // After we filter our data, make an update
  // so that our visualization is reset based on the
  // active data.
  @Override
  public void update(){
     this.setLayout(layout);
  }
    
  /*
      Draw using our rendering modes
      
      This is where we are actually rendering each rectangle
  */
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
          for(int i = 0; i < nodeListStack.peek().size(); ++i){
            ChordNode temp = (ChordNode)nodeListStack.peek().get(i);
            temp.render(2);
          }
      }
  }
  
  
}