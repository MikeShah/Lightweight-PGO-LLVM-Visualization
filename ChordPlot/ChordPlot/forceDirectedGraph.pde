/*
    This class serves as the details window to display other information.
*/
public class forceDirectedGraphWindow extends PApplet {
  
  
  //public ConcurrentHashMap<nodeMetaData,LinkedHashSet<nodeMetaData>> graph = new ConcurrentHashMap<nodeMetaData,LinkedHashSet<nodeMetaData>>();
  CopyOnWriteArrayList<ChordNode> nodes;

  // Our control panel
  ControlP5 fdgPanel;
  
  
  int simulationSteps = 0;
  int maxSimulationSteps = 200;
  
  // Spring constant should be stronger than repulsion in theory?
  float springConstant = 0.01;
  float repulseNodes =   0.01;
  float springRestLength = 50;
  float divider = 100;    // Special note that when we hook this with the GUI, since the gui doesn't do super precise decimals we divide by this much.
    
  /*
      Build the GUI for the Details Pane
  */
  void initGUI(){
    fdgPanel = new ControlP5(this);
  
             fdgPanel.addButton("SimulateFDG")
                 .setPosition(0,0)
                 .setSize(90,39)
                 .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                 ; 
                 
              fdgPanel.addSlider("SimulationSteps")
                 .setRange( 0, 500 )
                 .setPosition(90,0)
                 .plugTo( this, "SimulationSteps" )
                 .setValue( 200 )
                 .setLabel("SimulationSteps")
                 ;   
                 
              fdgPanel.addSlider("springConstantFunc")
                 .setRange( 1, 100 )
                 .setPosition(90,10)
                 .plugTo( this, "springConstantFunc" )
                 .setValue( 1 )
                 .setLabel("springConstant")
                 ;  
                 
              fdgPanel.addSlider("springRestLengthFunc")
                 .setRange( 1, 500 )
                 .setPosition(90,30)
                 .plugTo( this, "springRestLengthFunc" )
                 .setValue( 50 )
                 .setLabel("SpringRestLength")
                 ; 
              
              fdgPanel.addSlider("repulseConstantFunc")
                 .setRange( 0, 100 )
                 .setPosition(90,20)
                 .plugTo( this, "repulseConstantFunc" )
                 .setValue( 1 )
                 .setLabel("RepulseConstant")
                 ;  
  }
  
  public forceDirectedGraphWindow() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    
    nodes = new CopyOnWriteArrayList<ChordNode>(); 
    
    // Setup the GUI
    initGUI();
  }

  public void settings() {
    size(360, 320, P3D);
    smooth();
  }
  public void setup() { 
    println("setup ForceDirectedGraphWindow");
    surface.setTitle("Force Directed Graph");
    surface.setLocation(1260, 320);
    println("ForceDirectedGraphWindow end");
    frameRate(60);
  }
  
  // How many steps to take place in the simulation
  void SimulationSteps(int steps) {
    maxSimulationSteps = steps;
  }
  
  void springConstantFunc(float _k){
    springConstant = _k/divider;
  }
  
  void repulseConstantFunc(float _r){
    repulseNodes = _r/divider;
  }
  
  void springRestLengthFunc(int restLength){
    springRestLength = restLength;
  }
  
  public void SimulateFDG(){
    simulationSteps = 0;
    getNodes();
  }

  // Simple function that checks
  // if a value is greater or less than a range, then lock it in there.
  // Useful if too much force is given to a node
  float clamp(float value, float min, float max){
     if(value < min){
       return min;
     }
     else if(value > max){
       return max;
     }
     else{
       return value;
     }
  }
  

  public void draw() {
    background(145,160,176);
    
    fill(0); stroke(0,255);
     
      // Perform the actual simulation and apply physical forces to the nodes
      if(simulationSteps < maxSimulationSteps){
          simulationSteps += 1;
          
          // Set all forces to zero by default each timestep
          for(int i =0; i < nodes.size(); ++i){
              nodes.get(i).force.x = 0;
              nodes.get(i).force.y = 0;
          }
          
                  // For each of our edges
                  for(int i =0; i < nodes.size(); ++i){
                    // Search all of the callees
                    for(int j=0; j < nodes.get(i).metaData.calleeLocations.size();++j){
                      // if any of the callees are in our nodelist, then draw an edge
                      for(int k=0; k < nodes.size(); ++k){
                          if(nodes.get(k).metaData.name.equals(nodes.get(i).metaData.calleeLocations.get(j).metaData.name)){
                              // Connect the nodes
                              stroke(255,255);
                              line(nodes.get(i).fdg_x, nodes.get(i).fdg_y,   nodes.get(k).fdg_x,nodes.get(k).fdg_y);
                              float dx = (nodes.get(k).fdg_x - nodes.get(i).fdg_x);
                              float dy = (nodes.get(k).fdg_y - nodes.get(i).fdg_y);
                              // Move nodes closer together
                              float distance_squared = dx*dx + dy*dy;
                              float distance = sqrt(distance_squared);
                              float force = springConstant * (distance - springRestLength);
                              float fx = force * dx/distance;
                              float fy = force * dy/distance;

                              nodes.get(i).force.x += fx;
                              nodes.get(i).force.y += fy;
                              nodes.get(k).force.x -= fx;
                              nodes.get(k).force.y -= fy;
                              
                              nodes.get(i).force.x = clamp(nodes.get(i).force.x,-10,10);
                              nodes.get(i).force.y = clamp(nodes.get(i).force.y,-10,10);
                              nodes.get(k).force.x = clamp(nodes.get(k).force.x,-10,10);
                              nodes.get(k).force.y = clamp(nodes.get(k).force.y,-10,10);
                          }
                      }
                    }
                  }// for(int i =0; i < nodes.size(); ++i){
                  
                  // Repulse nodes
                  for(int i =0; i < nodes.size(); ++i){
                    for(int j =0; j < nodes.size(); ++j){
                        // Repulse nodes by adding more distance 
                       float dx = (nodes.get(j).fdg_x - nodes.get(i).fdg_x);
                       float dy = (nodes.get(j).fdg_y - nodes.get(i).fdg_y);
                          if(dx !=0 || dy!=0){
                             float distance_squared = dx*dx + dy*dy;
                             float distance = sqrt(distance_squared);
                             float force = repulseNodes / distance_squared;
                             float fx = force * dx/distance;
                             float fy = force * dy/distance;
                             nodes.get(i).force.x -= fx;
                             nodes.get(i).force.y -= fy;
                             nodes.get(j).force.x += fx;
                             nodes.get(j).force.y += fy;
                             
                              nodes.get(i).force.x = clamp(nodes.get(i).force.x,-10,10);
                              nodes.get(i).force.y = clamp(nodes.get(i).force.y,-10,10);
                              nodes.get(j).force.x = clamp(nodes.get(j).force.x,-10,10);
                              nodes.get(j).force.y = clamp(nodes.get(j).force.y,-10,10);
                          }
                    }
                  } // for(int i =0; i < nodes.size(); ++i){
          
                  // Apply forces
                  for(int i =0; i < nodes.size(); ++i){
                     nodes.get(i).fdg_x += nodes.get(i).force.x;
                     nodes.get(i).fdg_y += nodes.get(i).force.y;
                  }
      }else{// if(simulationSteps < maxSimulationSteps){
                        // For each of our edges
                  for(int i =0; i < nodes.size(); ++i){
                    // Search all of the callees
                    for(int j=0; j < nodes.get(i).metaData.calleeLocations.size();++j){
                      // if any of the callees are in our nodelist, then draw an edge
                      for(int k=0; k < nodes.size(); ++k){
                          if(nodes.get(k).metaData.name.equals(nodes.get(i).metaData.calleeLocations.get(j).metaData.name)){
                              stroke(255,255);
                              line(nodes.get(i).fdg_x, nodes.get(i).fdg_y,   nodes.get(k).fdg_x,nodes.get(k).fdg_y);
                          }
                      }
                    }
                  }  
      }
      
      
      
          // Draw nodes
      for(int i =0; i < nodes.size(); ++i){
          
          // Set the nodes boundaries
          if(nodes.get(i).fdg_x > width){
             nodes.get(i).fdg_x = width;
          }
          // Set the nodes boundaries
          if(nodes.get(i).fdg_x < 0){
             nodes.get(i).fdg_x = 0;
          }
          // Set the nodes boundaries
          if(nodes.get(i).fdg_y > height){
             nodes.get(i).fdg_y = height;
          }
          // Set the nodes boundaries
          if(nodes.get(i).fdg_y < 0){
             nodes.get(i).fdg_y = 0;
          }          
          
          // Draw the actual node last (Might need to do this in a separate loop so things do not overlap

          if(dist(mouseX,mouseY,nodes.get(i).fdg_x, nodes.get(i).fdg_y)<5){
            stroke(192); fill(192);
          }
          else{
            stroke(0); fill(0);
          }
          rect(nodes.get(i).fdg_x, nodes.get(i).fdg_y, 5, 5);
      }
      
      
     // Draw the help
      noFill();
      noStroke();
      fill(255);stroke(255);
      text(simulationSteps+"| Nodes:"+nodes.size()+" |FPS :"+int(frameRate),0,height-20); 
        
  }
  
      
  // Generates a force-directed graph from the
  // top level nodes
  public void getNodes(){
    // Clear
    nodes.clear();
    
    // How many nodes we have
    int iterations = cd.nodeListStack.peek().size();
    
    // Get all of the nodes on the stack
    for(int i =0; i < iterations;i++){
      // Get all of the selected nodes
      if(cd.nodeListStack.peek().get(i).selected){
        float random_x = random(0,width);
        float random_y = random(0,height);
        cd.nodeListStack.peek().get(i).fdg_x = random_x;
        cd.nodeListStack.peek().get(i).fdg_y = random_y;
        nodes.add(cd.nodeListStack.peek().get(i));
        nodes.get(nodes.size()-1).fdg_x = random_x;
        nodes.get(nodes.size()-1).fdg_y = random_y;
      }
    }

  }
    
    
    
    
}