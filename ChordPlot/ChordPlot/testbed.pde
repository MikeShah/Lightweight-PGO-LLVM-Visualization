// This is a random file for testing ideas
// Consider this a sandbox.
// Totally not necessary to keep this file in the project.

/* 

  Common Widget sandbox

  The purpose of this class is to split up the visualization into multiple windows, that all have
  similar filters, and ways of digging through information.

*/

public class commonWidget extends PApplet{
  // The main GUI component
  ControlP5 cp5;
  // Window title
  String windowTitle;
  
  /*
      Initialize all of the GUI components.
      Ideally this connects to the dataLayer.
  */
  private void  initGUI(){
      cp5.addSlider( "value-")
           .setRange( 0, 255 )
           .plugTo( this, "setValue" )
           .setValue( 127 )
           .setLabel("value")
           ;
                      
      ButtonBar b = cp5.addButtonBar("filterSelector")
           .setPosition(0, 0)
           .setSize(width, 20)
           .addItems(split("Metadata Attributes PGO Perf Graph Other"," "))
           ;
  }
  
  /*
      For the visualization, select the appropriate window
      to bring up, and restructure the Buckets window
  */
  void filterSelector(int n) {
    println("filterSelector clicked, item-value:", n);
    
    // Metadata
    if(n==0){
      println("clicked Metadata");
    }
    // Attributes
    else if(n==1){
      println("clicked Attributes");
    }
    // PGO 
    else if(n==2){
      println("clicked PGO");
    }
    // Perf 
    else if(n==3){
      println("clicked Perf");
    }
    // Graph
    else if(n==4){
      println("clicked Graph");
    }
    // Other
    else if(n==5){
      println("clicked Other");
    }
    
  }
  
  public commonWidget(){
      // Call the constructor for the PApplet
      super();
      PApplet.runSketch(new String[]{this.getClass().getName()}, this);
      // Setup our GUI
      cp5 = new ControlP5( this );
      this.initGUI();
      // Set the window title
      this.windowTitle = "No set windowTitle";
  }
  
  /*
      Constructor for a common Widget
  */
  public commonWidget(String windowTitle){
      // Call the constructor for the PApplet
      super();
      PApplet.runSketch(new String[]{this.getClass().getName()}, this);
      // Setup our GUI
      cp5 = new ControlP5( this );
      this.initGUI();
      // Set the window title
      this.windowTitle = windowTitle;
  }
  
  /*
    public void settings() {
      size(300, 600, P3D);
      smooth();
    }
    public void setup() { 
      surface.setTitle(windowTitle);
      surface.setLocation(1440, 400);
    }
  
    public void draw() {
      background(0);
      
      rect(5,5,5,5);
    }
    */
}