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
}