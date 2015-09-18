/*
    This class serves as the details window to display other information.
*/
public class DetailsPane extends PApplet {
  
  
  
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
      
      
// ==================================v Mark/Output v==================================      
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
                   
// ==================================^ Mark/Output ^================================== 


// ==================================v Selectiont v==================================    
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
                 
                 
               detailsPanel.addTextfield("StartsWith")
                 .setPosition(width-360,80)
                 .setSize(180,19)
                 .setFocus(true)
                 .setColor(color(255,0,0))
                 ;   
                 
             detailsPanel.addButton("SelectFunctions")
                 .setPosition(width-270,100)
                 .setSize(90,19)
                 .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                 ;   
                 
             detailsPanel.addRange("SelectionRange")
                 // disable broadcasting since setRange and setRangeValues will trigger an event
                 .setBroadcast(false) 
                 .setPosition(width-360,120)
                 .setSize(140,heightOfGUIElements)
                 .setHandleSize(10)
                 .setRange(0,maxSelectionRange)
                 .setRangeValues(selectionRangeMin,selectionRangeMax)
                 // after the initialization we turn broadcast back on again
                 .setBroadcast(true)
                 .setColorForeground(color(255,40))
                 .setColorBackground(color(255,40))
                 ;
                 
              // create a new button for outputting Dot files
              detailsPanel.addButton("CalleeSelectionFilters")
                 .setPosition(width-360,140)
                 .setSize(180,19)
                 ;
              detailsPanel.addButton("CallerSelectionFilters")
                 .setPosition(width-360,160)
                 .setSize(180,19)
                 ;      
              detailsPanel.addButton("PGODataSelectionFilters")
                 .setPosition(width-360,180)
                 .setSize(180,19)
                 ;          
              detailsPanel.addButton("BitCodeSizeSelectionFilters")
                 .setPosition(width-360,200)
                 .setSize(180,19)
                 ;        
// ==================================^ Selectiont ^================================== 
                 
// ==================================v Sorting v================================== 
              detailsPanel.addTextlabel("sortingByLabel")
                .setText("Sort By")
                .setPosition(width-540,0)
                .setColorValue(0xffffffff)
                ;
                    
              detailsPanel.addRadioButton("sortBy")
                 .setPosition(width-540,20)
                 .setSize(40,20)
                 .setColorForeground(color(120))
                 .setColorActive(color(255))
                 .setColorLabel(color(255))
                 .setItemsPerRow(1)
                 .setSpacingColumn(50)
                 .addItem("CALLEE",CALLEE)
                 .addItem("CALLER",CALLER)
                 .addItem("PGODATA",PGODATA)
                 .addItem("BITCODESIZE",BITCODESIZE)
                 .addItem("RECURSIVE",RECURSIVE)
                 ;
             
              detailsPanel.addTextlabel("colorByLabel")
                .setText("Color By")
                .setPosition(width-450,0)
                .setColorValue(0xffffffff)
                ;                 
                 
             detailsPanel.addRadioButton("colorizeBy")
                 .setPosition(width-450,20)
                 .setSize(40,20)
                 .setColorForeground(color(120))
                 .setColorActive(color(255))
                 .setColorLabel(color(255))
                 .setItemsPerRow(1)
                 .setSpacingColumn(50)
                 .addItem("_CALLEE",CALLEE)
                 .addItem("_CALLER",CALLER)
                 .addItem("_PGODATA",PGODATA)
                 .addItem("_BITCODESIZE",BITCODESIZE)
                 .addItem("_RECURSIVE",RECURSIVE)
                 ;
                 
             detailsPanel.addButton("EncodeSelected")
                 .setPosition(width-540,180)
                 .setSize(90,19)
                 .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                 ;   
                 
             detailsPanel.addButton("UnEncodeSelected")
                 .setPosition(width-540,200)
                 .setSize(90,19)
                 .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                 ;   
                 
             detailsPanel.addButton("SelectEncoded")
                 .setPosition(width-450,180)
                 .setSize(90,19)
                 .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                 ;   
                 
// ==================================^ Sorting ^================================== 
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
    size(1440, 320, P3D);
    smooth();
  }
  public void setup() { 
    println("setup DetailsPane");
    surface.setTitle("Details View");
    surface.setLocation(1440, 720);
    println("setup DetailsPane end");
  }

  public void draw() {
    background(145,160,176);
    
    int xSize = width-540;
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
    
    Temporary function to quickly select nodes with metadata.
  */
  void SelectMetaDataFunctions(){
    cd.selectMetaData();
  }
  /*
    
    Temporary function to quickly select functions with attributes.
  */
  void SelectAttributesFunctions(){
    cd.selectAttributes();
  }
  
  /*
    
    Temporary function to quickly select functions with line information .
  */
  void LineInformationFunctions(){
    cd.selectLineInformation();
  }
  
  
  
  /*
      Set the values for how the visualization sorts,
      and then update the layouts
  */
  void sortBy(int a){
    println("sortby: "+a);
    cd.setSortBy(a);
    hw.m_histogram.setSortBy(a);
    bw.m_buckets.setSortBy(a);
    
        cd.update();
        hw.m_histogram.update();
        bw.m_buckets.update();
  }
  
  /*
      Set the values for how the visualization colors,
      and then update the layouts
  */
  void colorizeBy(int a){
    println("colorizeBy: "+a);
    cd.setColorizeBy(a);
    hw.m_histogram.setColorizeBy(a);
    bw.m_buckets.setColorizeBy(a);
    
        cd.update();
        hw.m_histogram.update();
        bw.m_buckets.update();
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
        //bw.m_buckets.functionStartsWithSelect(theText); // cannot select buckets which contain functions...could be a future functionality. TODO: Should their be some heuristic?
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
      /*
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
    */
    
      // Get the values from the CallSites range slider.
      if(theEvent.isFrom("SelectionRange")) {
        selectionRangeMin = int(theEvent.getController().getArrayValue(0));
        selectionRangeMax = int(theEvent.getController().getArrayValue(1));
        println("range update, done. ("+selectionRangeMin+","+selectionRangeMax+")");
      }
      
        println("exited okay from Details Pane");
    }
    
    /*
      Apply a Filter based on the options we have selected.
      Makes use of the Range Slider
    */
    public void CalleeSelectionFilters(int theValue){
      cd.selectRange(CALLEE,selectionRangeMin, selectionRangeMax);
      hw.m_histogram.selectRange(CALLEE,selectionRangeMin, selectionRangeMax);
      bw.m_buckets.selectRange(CALLEE,selectionRangeMin, selectionRangeMax);
    }
    /*
      Apply a Filter based on the options we have selected.
      Makes use of the Range Slider
    */
    public void CallerSelectionFilters(int theValue){  
      cd.selectRange(CALLER,selectionRangeMin, selectionRangeMax);
      hw.m_histogram.selectRange(CALLER,selectionRangeMin, selectionRangeMax);
      bw.m_buckets.selectRange(CALLER,selectionRangeMin, selectionRangeMax);
    }
    /*
      Apply a Filter based on the options we have selected.
      Makes use of the Range Slider
    */
    public void PGODataSelectionFilters(int theValue){
      cd.selectRange(PGODATA,selectionRangeMin, selectionRangeMax);
      hw.m_histogram.selectRange(PGODATA,selectionRangeMin, selectionRangeMax);
      bw.m_buckets.selectRange(PGODATA,selectionRangeMin, selectionRangeMax);
    }
    /*
      Apply a Filter based on the options we have selected.
      Makes use of the Range Slider
    */
    public void BitCodeSizeSelectionFilters(int theValue){
      cd.selectRange(BITCODESIZE,selectionRangeMin, selectionRangeMax);
      hw.m_histogram.selectRange(BITCODESIZE,selectionRangeMin, selectionRangeMax);
      bw.m_buckets.selectRange(BITCODESIZE,selectionRangeMin, selectionRangeMax);
    }
    
    /*
      Encode Selected
    */
    public void EncodeSelected(){
      cd.encodeNodesWith(1,true);
    }
    /*
      UnEncode Selected
    */
    public void UnEncodeSelected(){
      cd.encodeNodesWith(1,false);
    }
    /* 
      Select all the nodes we have encoded
    */
    public void SelectEncoded(){
      cd.selectEncodedNodes();
    }
    
}