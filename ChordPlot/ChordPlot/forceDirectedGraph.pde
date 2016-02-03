/*
    This class serves as the details window to display other information.
*/
public class forceDirectedGraphWindow extends PApplet {
  /*
      Build the GUI for the Details Pane
  */
  void initGUI(){
    
  }
  
  public forceDirectedGraphWindow() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    
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

  public void draw() {
    background(145,160,176);
    
    // Draw the help
    noFill();
    noStroke();
    fill(255);stroke(255);
    text("FPS :"+int(frameRate),5,20);
    
    fill(0); stroke(0,255);
  }
    
}