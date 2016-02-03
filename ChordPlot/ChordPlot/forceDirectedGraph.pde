/*
    This class serves as the details window to display other information.
*/
public class forceDirectedGraphWindow extends PApplet {
  
  
  //public ConcurrentHashMap<nodeMetaData,LinkedHashSet<nodeMetaData>> graph = new ConcurrentHashMap<nodeMetaData,LinkedHashSet<nodeMetaData>>();
  CopyOnWriteArrayList<ChordNode> nodes;

  // Our control panel
  ControlP5 fdgPanel;
  
  int simulationSteps = 0;
  int maxSimulationSteps = 10000;
  
  
  
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
    surface.setLocation(0, 0);
    println("ForceDirectedGraphWindow end");
  }
  
  public void SimulateFDG(){
    simulationSteps = 0;
    getNodes();
  }

  public void draw() {
    background(145,160,176);
    
    // Draw the help
    noFill();
    noStroke();
    fill(255);stroke(255);
    text("Nodes:"+nodes.size()+" |FPS :"+int(frameRate),width-120,20);
    
    fill(0); stroke(0,255);
    
    if(simulationSteps < maxSimulationSteps){
      simulationSteps += 1;
    }
    
      // Draw nodes
      for(int i =0; i < nodes.size(); ++i){
          
          stroke(0); fill(0);
          // Draw the actual node last (Might need to do this in a separate loop so things do not overlap
          ellipse(nodes.get(i).fdg_x, nodes.get(i).fdg_y, 5, 5);
      }
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