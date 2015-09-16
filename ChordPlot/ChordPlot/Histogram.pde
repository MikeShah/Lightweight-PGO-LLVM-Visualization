/*
    This class serves as the details window to display other information.
*/
class HistogramWindow extends commonWidget {
  
  // a self-contained 
  Histogram m_histogram;
  String filename;

  public HistogramWindow(String filename){
    this.filename = filename;
    println("a from Histogram");
    m_histogram = new Histogram(filename,0,height-30,0);
  }
  
  public void settings() {
    size(1440, 350, P3D);
    smooth();
  }
    
  public void setup() { 
      println("setup Histogram");
      surface.setTitle(windowTitle);
      surface.setLocation(1440, 350);
      println("setup Histogram end");
  }
  
  int p_node_old = -1;
  int p_node = -1;
  Set<Integer> selectedNodes = new HashSet<Integer>();
  
  public void draw() {
    
    if(m_histogram != null){
    
      float m_x = mouseX;
      float m_y = mouseY;   
    
      // Refresh the screen    
      background(0,64,128);
        text("FPS :"+frameRate,width-100,height-20);
        text("Camera Position ("+MySimpleCamera.cameraX+","+MySimpleCamera.cameraY+","+MySimpleCamera.cameraZ+")",5,height-20);
        text("(x,y) => ("+m_x+","+m_y+")",width-200,height-20);
           
           //m_histogram.draw(0); // TODO: FIXME: This is a bug, for some reason I "Cannot run the OpenGL renderer outside the main thread, change your code so the drawing calls are all inside the main thread"
           //m_histogram.drawBounds(0,64,128, m_histogram.xPosition,m_histogram.yPosition-m_histogram.yBounds);
           // What is interesting about the drawing, is that it is all happening in the
          // ChordNode itself. This way we can have any arbritrary shape in ChordNode
          // drawn and handle all of the selection there. It also would allow us to have
          // different types of shaped nodes mixed in a visualization much more easily.
          
          
          for(int i =0; i < m_histogram.nodeListStack.peek().size();i++){ // FIXME: Well, this visualization is only useful if it is directly attached to the 'cd', so just work with that data directly.
                                                                          //        Current bug is 
            ChordNode temp = (ChordNode)m_histogram.nodeListStack.peek().get(i);
            
            fill(temp.metaData.c); stroke(255);
            
            // Highlight nodes we are over
            if(m_x > temp.x && m_x < temp.x+temp.rectWidth){
              fill(192);
              text("selected: "+i+" prev: "+p_node+" prev2: "+p_node_old,200,150);
              // Highlight nodes we are hovering over
              fill(255,255,0,255); stroke(255);
              
              // Unhighlight all of the previous buckets that were highlighted.
              if(p_node != i){
                p_node_old = p_node;
                p_node = i;
                cd.highlightNode(temp,true);
                // Store the list of nodes we had previously highlighted
                // This allows us to quickly unhighlight them.
                if(p_node_old > -1){
                    ChordNode old = (ChordNode)m_histogram.nodeListStack.peek().get(p_node_old);
                    cd.highlightNode(old,false);
                }
              }
              
                // If the mouse is pressed
                if(mousePressed==true){
                   if(mouseButton==LEFT){
                     if(selectedNodes.contains(i)){
                       cd.toggleActiveNode(temp);
                       selectedNodes.remove(i);
                     }else{
                       cd.toggleActiveNode(temp);
                       selectedNodes.add(i);
                     }
                   }
                   if(mouseButton==RIGHT){
                         float _w = 500;
                         float _h = 200;
                         float padding = 5;
                         
                         pushMatrix();
                           translate(0,0,MySimpleCamera.cameraZ+20);
                           fill(192,192);
                           rect(m_x,m_y,_w,_h);
                           fill(0,255);
                           text("MetaData: "+temp.metaData.getAllMetadata(),m_x+padding,m_y+padding,_w-padding,_h-padding);
                         popMatrix();
                       
                       // Pass a data string to our child applet and store it here.
                        dp.setDataString("Data:"+temp.metaData.getAllMetadata());
                   }
                }
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

class Histogram extends DataLayer{
  
  int scaledHeight = 250; // Normalize visualization height and values to this
  
  // Default Constructor for the Histogram
  public Histogram(String file, float xPosition, float yPosition, int layout){
    this.visualizationName = "Histogram";
    println("a m_histogram");
    super.init(file, xPosition, yPosition,layout);
    println("b m_histogram");
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
  */
  
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