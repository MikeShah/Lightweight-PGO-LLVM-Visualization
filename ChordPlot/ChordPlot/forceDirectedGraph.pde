/*
    This class serves as the details window to display other information.
*/
public class forceDirectedGraphWindow extends PApplet {
  
  
  //public ConcurrentHashMap<nodeMetaData,LinkedHashSet<nodeMetaData>> graph = new ConcurrentHashMap<nodeMetaData,LinkedHashSet<nodeMetaData>>();
  CopyOnWriteArrayList<ChordNode> nodes;

  // Our control panel
  ControlP5 fdgPanel;
  
  
  int simulationSteps = 0;
  int maxSimulationSteps = 100;
  
  // Spring constant should be stronger than repulsion in theory?
  float springConstant = 0.0001;
  float repulseNodes =   0.0001;
    
  /*
      Build the GUI for the Details Pane
  */
  void initGUI(){
    fdgPanel = new ControlP5(this);
  
             fdgPanel.addButton("SimulateFDG")
                 .setPosition(0,0)
                 .setSize(90,19)
                 .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
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
  }
  
  public void SimulateFDG(){
    simulationSteps = 0;
    getNodes();
  }

  public void draw() {
    background(145,160,176);
    
    float xEnergy = 0;
    float yEnergy = 0;
        
    fill(0); stroke(0,255);
     
          // Draw nodes
      for(int i =0; i < nodes.size(); ++i){
          stroke(0); fill(0);
          
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
         
          ellipse(nodes.get(i).fdg_x, nodes.get(i).fdg_y, 5, 5);
      }
      
      // Perform the actual simulation and apply physical forces to the nodes
      if(simulationSteps < maxSimulationSteps){
          simulationSteps += 1;
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
                              // Move nodes closer together
                              //nodes.get(i).force.x -= (nodes.get(i).fdg_x - nodes.get(k).fdg_x) * springConstant;
                              nodes.get(k).force.x += (nodes.get(i).fdg_x - nodes.get(k).fdg_x) * springConstant;
                              //nodes.get(i).force.y -= (nodes.get(i).fdg_y - nodes.get(k).fdg_y) * springConstant;
                              nodes.get(k).force.y += (nodes.get(i).fdg_y - nodes.get(k).fdg_y) * springConstant;
                          }
                      }
                    }
                  }// for(int i =0; i < nodes.size(); ++i){
                  
                  // Repulse nodes
                  for(int i =0; i < nodes.size(); ++i){
                    for(int j =0; j < nodes.size(); ++j){
                        // Repulse nodes by adding more distance 
                       // nodes.get(i).force.x += -(nodes.get(i).fdg_x - nodes.get(j).fdg_x) * repulseNodes;
                       // nodes.get(i).force.y += -(nodes.get(i).fdg_y - nodes.get(j).fdg_y) * repulseNodes;
                    }
                  } // for(int i =0; i < nodes.size(); ++i){
          
                  // Apply forces
                  for(int i =0; i < nodes.size(); ++i){
                     nodes.get(i).fdg_x += nodes.get(i).force.x;
                     nodes.get(i).fdg_y += nodes.get(i).force.y;
                     
                     xEnergy = nodes.get(i).force.x;
                     yEnergy = nodes.get(i).force.y;
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
      
      
     // Draw the help
      noFill();
      noStroke();
      fill(255);stroke(255);
      text(simulationSteps+"| Energy ("+xEnergy+","+yEnergy+") Nodes:"+nodes.size()+" |FPS :"+int(frameRate),100,20); 
        
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