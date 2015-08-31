/*
    This class serves as the details window to display other information.
*/
class DetailsPane extends PApplet {
  
  // Used to pass and send data
  DataString dataString;
  
  // Our control panel
  ControlP5 detailsPanel;
  
  // re-route output from text to this details pane.
  Textarea myConsoleTextarea;
  Println console;
  
  /*
      Build the GUI for the Details Pane
  */
  void initGUI(){
      detailsPanel = new ControlP5(this);
              // create a new button for something
              detailsPanel.addButton("More (todo)")
                   //.setValue(0) // Note that setting the value forces a call to this function (which sort of makes sense, as it will call your function at least once to set things up to align with the GUI).
                   .setPosition(width-180,0)
                   .setSize(180,19)
                   ;
              // create a new button for something
              detailsPanel.addButton("Highlight Similiar Nodes (todo)")
                   //.setValue(0) // Note that setting the value forces a call to this function (which sort of makes sense, as it will call your function at least once to set things up to align with the GUI).
                   .setPosition(width-180,20)
                   .setSize(180,19)
                   ;
                   
              // create a new button for outputting Dot files
              detailsPanel.addButton("OutputDOT")
                   //.setValue(0) // Note that setting the value forces a call to this function (which sort of makes sense, as it will call your function at least once to set things up to align with the GUI).
                   .setPosition(width-180,40)
                   .setSize(180,19)
                   ;
                   
              // create a new button for outputting Dot files
              detailsPanel.addButton("OutputSelectedDOT")
                   //.setValue(0) // Note that setting the value forces a call to this function (which sort of makes sense, as it will call your function at least once to set things up to align with the GUI).
                   .setPosition(width-180,60)
                   .setSize(180,19)
                   ;

              detailsPanel.addTextfield("StartsWith")
                 .setPosition(width-180,80)
                 .setSize(180,19)
                 .setFocus(true)
                 .setColor(color(255,0,0))
                 ;  
                 
                 detailsPanel.addBang("FindFunction")
                 .setPosition(width-180,100)
                 .setSize(180,19)
                 .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                 ;    
  
                  
/*                   
              // Capture Console output here.
              myConsoleTextarea = detailsPanel.addTextarea("txt")
                  .setPosition(400, 0)
                  .setSize(300, height)
                  .setFont(createFont("", 10))
                  .setLineHeight(14)
                  .setColor(color(200))
                  .setColorBackground(color(0, 100))
                  .setColorForeground(color(255, 100));
              ;

              console = detailsPanel.addConsole(myConsoleTextarea);//
*/              
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
    surface.setLocation(0, 800);
  }

  public void draw() {
    background(145,160,176);
    
    int xSize = width-180;
    int ySize = height;
    
    fill(0); stroke(0,255);

    text(dataString.getString(), 0,0, xSize, ySize);
  }
  
  // 
  void setDataString(String s){
    dataString.setText(s);
  }
  
  
  /*
       When this button is pressed, we output a 
      .dot file with the functions listed in the microarray
  */
  public void OutputDOT(int theValue) {
    println("Outputting Dot file");
    cd.nodeListStack.outputDot(".//top_of_stack_plus_some_timestamp.dot",0);
  }
  
  /*
      Output all of the selected nodes to
      a dot file
  */
  public void OutputSelectedDOT(int theValue){
    println("Outputting Dot file of selected nodes");
    cd.nodeListStack.outputDot(".//selected_nodes_plus_some_timestamp.dot",1);
  }
  
  /*
      Search for functions that match the string
  */
 
  public void FindFunction() {
    String theText = detailsPanel.get(Textfield.class,"StartsWith").getText(); 
    if(theText.length() > 0){
      
        String FilterString = cd.nodeListStack.peek().name;
        // Apply the relevant filters
        cd.functionStartsWith(theText);
        cd.update(); // Make a call to update the visualization
        
        hw.m_histogram.functionStartsWith(theText);
        hw.m_histogram.update(); // Make a call to update the visualization
        
        bw.m_buckets.functionStartsWith(theText);
        bw.m_buckets.update();
        
        // Add our item to the list
        breadCrumbsBar.addItem(FilterString,cd.nodeListStack.size()-1);
        // Update the functions list with anything we have found.
        updateFunctionList();
    }
  }
    
}