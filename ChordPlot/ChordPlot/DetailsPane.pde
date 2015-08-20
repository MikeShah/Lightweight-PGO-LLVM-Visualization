/*
    This class serves as the details window to display other information.
*/
class DetailsPane extends PApplet {
  
  // Used to pass and send data
  DataString dataString;
  
  // Our control panel
  ControlP5 detailsPanel;
  
  /*
      Build the GUI for the Details Pane
  */
  void initGUI(){
      detailsPanel = new ControlP5(this);
                    // create a new button for outputting Dot files
              detailsPanel.addButton("More")
                   //.setValue(0) // Note that setting the value forces a call to this function (which sort of makes sense, as it will call your function at least once to set things up to align with the GUI).
                   .setPosition(width-180,0)
                   .setSize(180,19)
                   ;
  }
  
  
  
  public DetailsPane() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    // Initialize a string of data that we can use to pass
    // between our different windows.
    dataString = new DataString();
    dataString.setText("Data");
    
    // Setup the GUI
    initGUI();
  }

  public void settings() {
    size(1440, 200, P3D);
    smooth();
  }
  public void setup() { 
    surface.setTitle("Details View");
    frame.setLocation(0, 800);
  }

  public void draw() {
    background(0);
    
    int xSize = width;
    int ySize = height;
    
    stroke(192,255);
    fill(0,255);
    rect(0,0,xSize,ySize);
    fill(255,0,0,255);
    text(dataString.getString(), 0,0, xSize, ySize);
  }
  
  // 
  void setDataString(String s){
    dataString.setText(s);
  }
  
  
  
  
  
  
  
  
}