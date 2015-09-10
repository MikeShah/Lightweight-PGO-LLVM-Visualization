/*
    This class serves as the details window to display other information.
*/
class DetailsPane extends PApplet {
  
  
  
  /* Purpose:
  
     A special mutable version of a java string.
     It exists within DetailsPane in order to transfer text around.
   
  */
  
  class DataString{
    String text;
    
    DataString(){
      text = new String("empty");
    }
    
    void setText(String s){
      text = new String(s);
    }
    
    String getString(){
      if(text!=null){
        return text;
      }else{
        return "";
      }
    }
    
  }
  

  
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
              detailsPanel.addButton("AnnotateSelected")
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
                 
             detailsPanel.addButton("SelectFunctions")
                 .setPosition(width-90,100)
                 .setSize(90,19)
                 .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                 ;   
                 
             detailsPanel.addRange("CallSites")
                 // disable broadcasting since setRange and setRangeValues will trigger an event
                 .setBroadcast(false) 
                 .setPosition(width-180,120)
                 .setSize(140,heightOfGUIElements)
                 .setHandleSize(10)
                 .setRange(0,maxNumberOfCallsites)
                 .setRangeValues(callSiteMin,callSiteMax)
                 // after the initialization we turn broadcast back on again
                 .setBroadcast(true)
                 .setColorForeground(color(255,40))
                 .setColorBackground(color(255,40))
                 ;
                 
              // create a new button for outputting Dot files
              detailsPanel.addButton("CalleeSelectionFilters")
                 .setPosition(width-180,140)
                 .setSize(180,19)
                 ;
                 
              detailsPanel.addSlider("SelectionDepth")
                 .setRange( 0, 15 )
                 .setPosition(width-360,0)
                 .plugTo( this, "SelectionDepth" )
                 .setValue( 1 )
                 .setLabel("SelectionDepth")
                 ;
  
                // create a new button for selecting metaData
              detailsPanel.addButton("SelectMetaDataFunctions")
                 .setPosition(width-360,20)
                 .setSize(180,19)
                 ;
                 
               // create a new button for selecting Attributes
              detailsPanel.addButton("AttributesFunctions")
                 .setPosition(width-360,40)
                 .setSize(180,19)
                 ;
                 
               // create a new button for selecting Line Information
              detailsPanel.addButton("LineInformationFunctions")
                 .setPosition(width-360,60)
                 .setSize(180,19)
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
    println("setup DetailsPane");
    surface.setTitle("Details View");
    surface.setLocation(0, 800);
    println("setup DetailsPane end");
  }

  public void draw() {
    background(145,160,176);
    
    int xSize = width-360;
    int ySize = height;
    
    fill(0); stroke(0,255);
    if(dataString!=null){
      text(dataString.getString(), 0,0, xSize, ySize);
    }
  }
  
  // 
  void setDataString(String s){
    dataString.setText(s);
  }
  
  
  /*
    TODO: Remove me
    
    Temporary function to quickly select nodes with metadata.
  */
  void SelectMetaDataFunctions(){
    cd.selectMetaData();
  }
  /*
    TODO: Remove me
    
    Temporary function to quickly select functions with attributes.
  */
  void SelectAttributesFunctions(){
    cd.selectAttributes();
  }
  
    /*
    TODO: Remove me
    
    Temporary function to quickly select functions with line information .
  */
  void LineInformationFunctions(){
    cd.selectLineInformation();
  }
  
  /*
      This function annotates the selected nodes.
      
      This is one of the key functions
  */
  void AnnotateSelected(){
    cd.annotateSelected("ChordPlot_worked","true");
  }
  
  
  void SelectionDepth(int theDepth) {
    CalleeDepth = theDepth;
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
      Search for functions that match the string and just select it
  */
 public void SelectFunctions() {
    String theText = detailsPanel.get(Textfield.class,"StartsWith").getText(); 
    if(theText.length() > 0){
      
        // Apply the relevant filters
        cd.functionStartsWithSelect(theText);
        hw.m_histogram.functionStartsWithSelect(theText);
        //bw.m_buckets.functionStartsWithSelect(theText);

    }
  }
  
  
  /*
      TODO: Implement highlighting as you start to type
      
      Will need to test on very large programs to see if
      the 
  */
  /*
  public void StartsWith(){
    String theText = detailsPanel.get(Textfield.class,"StartsWith").getText(); 
    if(theText.length() > 0){
      println("Typing in"+theText);
    }
  }
  */
  
  /*
      Search for functions that match the string
 
 DEPRECATED: We just want to select things quickly, not necessarily
 immedietely push. All pushing needs to be done with enter
 
  public void FindFunction() {
    String theText = detailsPanel.get(Textfield.class,"StartsWith").getText(); 
    if(theText.length() > 0){
      
        String FilterString = cd.nodeListStack.peek().name;
        // Apply the relevant filters
        cd.functionStartsWith(theText);
        cd.update(); // Make a call to update the visualization
        
        hw.m_histogram.functionStartsWith(theText);
        hw.m_histogram.update(); // Make a call to update the visualization
        hw.updateFunctionList();
        
        bw.m_buckets.functionStartsWith(theText);
        bw.m_buckets.update();
        bw.updateFunctionList();
        
        // Add our item to the list
        breadCrumbsBar.addItem(FilterString,cd.nodeListStack.size()-1);
        // Update the functions list with anything we have found.

    }
  }
   */
 
  
    // function controlEvent will be invoked with every value change 
    // in any registered controller
    void controlEvent(ControlEvent theEvent) {
      if(theEvent.isGroup()) {
        println("got an event from group "
                +theEvent.getGroup().getName()
                +", isOpen? "+theEvent.getGroup().isOpen()
                );
                
      } else if (theEvent.isController()){
        println("got something from a controller "
                +theEvent.getController().getName()
                );
      }
    
    
      // Get the values from the CallSites range slider.
      if(theEvent.isFrom("CallSites")) {
        callSiteMin = int(theEvent.getController().getArrayValue(0));
        callSiteMax = int(theEvent.getController().getArrayValue(1));
        println("range update, done. ("+callSiteMin+","+callSiteMax+")");
      }
      
        println("exited okay from Details Pane");
    }
    
    /*
      Apply a Filter based on the options we have selected.
    */
    public void CalleeSelectionFilters(int theValue){
      // Apply the relevant filters
      cd.selectCallSites(callSiteMin, callSiteMax);
      hw.m_histogram.selectCallSites(callSiteMin, callSiteMax);
      bw.m_buckets.selectCallSites(callSiteMin, callSiteMax);
    }
    
}