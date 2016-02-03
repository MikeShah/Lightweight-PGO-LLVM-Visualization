/*
    This class serves as the details window to display other information.
*/
class AnimationWindow extends commonWidget {
  
  // a self-contained 
  CallTree m_calltree;
  String filename;

  float seek_pos = 0.0; // The actual position to display the slider
  int traceStep = 0; // The current instruction in trace to play.
  int numberOfSteps; // How many items there are in the trace
  boolean play = false;
  boolean select = true;  // If this is true, then when the animation plays, nodes are selected.

  List<String> functionCalls;
  


  public AnimationWindow(String filename){
    this.filename = filename;
    println("a from CallTreeWindow");
    m_calltree = new CallTree(filename,0,height-30,0);
    
    functionCalls = new LinkedList<String>();
    loadTrace();
  }
  
  public void settings() {
    size(900, 120, P3D);
    smooth();
    
  }
    
  public void setup() { 
      windowTitle = "Trace Player";
      surface.setTitle(windowTitle);
      surface.setLocation(0, 350);
      lastTime = millis();
  }
  
  /*
    Loads the trace file and setups up the animation window.
  */
  public void loadTrace(){
    // Note that the filename provided must be an absolute path, or the file directly in the data folder.
    
    String[] lines = loadStrings(traceFileName);
    println("Loading trace");
    for(String s: lines){
      functionCalls.add(s);
    }
    
    numberOfSteps = functionCalls.size();
  }
    
  /*
    Interactive rendering loop
    
    This is where we can interact with our visualization
    Depending on what we select, details can change
  */
  public void draw() {
    
    if(m_calltree != null){
      // Refresh the screen    
      background(0,64,128);
              
      float m_x = mouseX;
      float m_y = mouseY;   
      float timeLineLength = width-10;
      boolean step = false;  // Should we move forward
      
      // (1) Start parsing trace
      // (2) Be able to walk through each step 1 at a time, perhaps display function name
      // (3) Add a step button
      // (4) Maybe highlight step animation in orange?
       
      // Every half second we're allowed to click
      if(millis() - lastTime > 500){
        canClick = true;
      }else{
        canClick = false;
      }
      
        text("FPS :"+frameRate,width-100,height-20);          
            // Play
              fill(255); rect(0,0,20,20);
              if(m_x < 20 && m_y < 20){
                fill(192); rect(0,0,20,20);
                if(mouseButton==LEFT && canClick){ lastTime = millis(); canClick = false;
                  fill(128); rect(0,0,20,20);
                  play = true;
                }
              }
              fill(0); triangle(6,4,14,10,6,16);  // The actual triangle
              
              // Pause
              fill(255); rect(20,0,20,20);
              if(m_x > 20 && m_x < 40 && m_y < 20){
                fill(192); rect(20,0,20,20);
                if(mouseButton==LEFT && canClick){ lastTime = millis(); canClick = false;
                  fill(128); rect(20,0,20,20);
                  play = false;
                }
              }
              fill(0); rect(25,4,3,13); rect(31,4,3,13); // The bars
              
              // Restart
              fill(255); rect(40,0,20,20);
              if(m_x > 40 && m_x < 60 && m_y < 20){
                fill(192); rect(40,0,20,20);
                if(mouseButton==LEFT && canClick){ lastTime = millis(); canClick = false;
                  fill(128); rect(40,0,20,20);
                  play = false;
                  seek_pos = 0;
                  traceStep = 0;
                }
              }
              fill(0); rect(44,4,12,12);// The stop icon
              
              // Step Backward
              fill(255); rect(60,0,20,20);
              if(m_x > 60 && m_x < 80 && m_y < 20){
                fill(192); rect(60,0,20,20);
                if(mouseButton==LEFT && canClick){ lastTime = millis(); canClick = false;
                  fill(128); rect(60,0,20,20);
                  play = false;
                  step = true;
                  if(traceStep-1 > -1){
                    traceStep -= 1;
                    seek_pos -= timeLineLength / numberOfSteps-1;
                  }
                }
              }
              fill(0); triangle(73,4,63,10,73,16); rect(75,4,3,13);   // The actual triangle and bar
              
              // Step Forward
              fill(255); rect(80,0,20,20);
              if(m_x > 80 && m_x < 100 && m_y < 20){
                fill(192); rect(80,0,20,20);
                if(mouseButton==LEFT && canClick){ lastTime = millis(); canClick = false;
                  fill(128); rect(80,0,20,20);
                  play = false;
                  step = true;
                  if(traceStep+1 < numberOfSteps-1){
                    traceStep += 1;
                    seek_pos += timeLineLength / numberOfSteps-1;
                  }
                }
              }
              fill(0); rect(83,4,3,13); triangle(88,4,97,10,88,16);  // The actual triangle and bar
            
            // Select each node as it plays
            if(m_x > 100 && m_x < 160 && m_y < 20){
              fill(192); rect(100,0,50,20);
              if(mouseButton==LEFT && canClick){ lastTime = millis(); canClick = false;
                select = !select;
              }
            }
            if(select){
              fill(128); rect(100,0,50,20);
              fill(0); text("select",105,15);
            }else{
              fill(255); rect(100,0,50,20);
              fill(0); text("Highlight",105,15);
            }
            
              
            // Deselect each node as it plays
            
            
            // If we're playing, move our slider
            // and increment the instruction we're on.
            if(play){
                seek_pos += timeLineLength / numberOfSteps-1;
                traceStep += 1;
                if(traceStep > numberOfSteps-1){
                  play = false;
                }
            }
            
            // Loop that finds our node and highlights it in the visualization
            if(play || step){
                for(int i =0; i < cd.nodeListStack.peek().size();i++){                        
                    ChordNode temp = (ChordNode)cd.nodeListStack.peek().get(i);
                    if(traceStep>-1 && traceStep < functionCalls.size()-1){
                      if(temp.metaData.name.equals("\""+functionCalls.get(traceStep)+"\"")){
                        if(select){
                          temp.selected = true;
                        }else{
                          temp.highlighted = true;
                        }
                      }
                    }
                }
            }
            step = false;
            
            // Timeline
            line(0,40,timeLineLength,40);
            // Rect place in time
            fill(255);
            rect(seek_pos,30,3,20);
            text(str(traceStep),seek_pos,30.0);
            if(traceStep>-1 && traceStep < functionCalls.size()-1){
              text(functionCalls.get(traceStep),5,60.0);
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
    //super.init(file, xPosition, yPosition,layout);
    println("b m_calltree");
    // Set a layout
    this.setLayout(layout);
    // Compute initial statistics
    //FIXME: Probably not needed in this layers nodeListStack.computeSummaryStatistics(); // 
  }
  

  // Get all of the points into our node list
  private void plotPoints2D(){
    /*
    float xPos = xPosition;
    
    for(int i =0; i < nodeListStack.peek().size();i++){
      nodeListStack.peek().get(i).x = xPos;
      nodeListStack.peek().get(i).y = yPosition;
      xPos += defaultWidth+1;
      xBounds = xPos;
    }
    */
  }
  
  /*
      Currently there is only one layout supported.
  */
  public void setLayout(int layout){
    /*
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
    */
  }
  
  /*
      Useful for being used in update where we don't need to do anything else with the data.
      This means setLayout should only be called once initially.
      
      Fast layout will layout the nodes. It is nice to have this abstracted away
      into its own function so we can quickly re-plot the nodes without doing additional
      computations.
  */
  public void fastUpdate(){
    /*
    // Modify all of the positions in our nodeList
    if(this.layout <= 0){
      plotPoints2D();
    }else{
      println("No other other layout, using default");
      plotPoints2D();
    }
    */
  }
  
  // After we filter our data, make an update
  // so that our visualization is reset based on the
  // active data.
  @Override
  public void update(){
    /*
     this.setLayout(layout);
     */
  }
    
  /*
      Draw using our rendering modes
      
      This is where we are actually rendering each rectangle
  */
  public void draw(int mode){
    /*
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
      */
  }
  
  
}