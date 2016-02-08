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
  
  Textarea myTextArea;
  // re-route output from text to this details pane.
  //Textarea myConsoleTextarea;
  //Println console;
  
  /*
      Build the GUI for the Details Pane
  */
  void initGUI(){
      detailsPanel = new ControlP5(this);
      
      myTextArea = detailsPanel.addTextarea("txt")
                  .setPosition(0,0)
                  .setSize(width-180,height)
                  .setFont(createFont("arial",12))
                  .setLineHeight(14)
                  .setColor(color(128))
                  .setColorBackground(color(255,100))
                  .setColorForeground(color(255,100));
                  ;
      
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



                 
// ==================================v Sorting v================================== 
              detailsPanel.addTextlabel("sortingByLabel")
                .setText("Sort By")
                .setPosition(width-180,80)
                .setColorValue(0xffffffff)
                ;
                    
              detailsPanel.addRadioButton("sortBy")
                 .setPosition(width-180,100)
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
                .setPosition(width-90,80)
                .setColorValue(0xffffffff)
                ;                 
                 
             detailsPanel.addRadioButton("colorizeBy")
                 .setPosition(width-90,100)
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
                 
                 
                 /*
             detailsPanel.addButton("EncodeSelected")
                 .setPosition(width-540,180)
                 .setSize(90,19)
                 .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                 ; 
      
      
             detailsPanel.addTextfield("EncodeSymbol")
                 .setPosition(width-630,180)
                 .setSize(90,19)
                 .setFocus(true)
                 .setColor(color(255,0,0))
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
             
             
             detailsPanel.addToggle("AnimateEncoding")
               .setPosition(width-450,200)
               .setSize(40,20)
               ;
               
             detailsPanel.addToggle("RectangleEncoding")
               .setPosition(width-450,220)
               .setSize(40,20)
               ;
               
             detailsPanel.addToggle("SymbolEncodoing")
               .setPosition(width-450,240)
               .setSize(40,20)
               ;
               */
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
    surface.setLocation(0, 600);
    println("setup DetailsPane end");
    frameRate(60);
  }

  public void draw() {
    background(145,160,176);
    
    int xSize = width-180;
    int ySize = height;
   
   // Draw the help
   noFill();
   noStroke();
   fill(255);stroke(255);
   text("Camera Position ("+MySimpleCamera.cameraX+","+MySimpleCamera.cameraY+","+MySimpleCamera.cameraZ+") | FPS :"+int(frameRate),width-250,height-20);
   text("'p' - Open bitcode file to function",5,height-70);
   text("Enter - Push nodes | Space - Deselect/Unhighlihgt all | Arrowkeys for Camera | Left-Mouse select/deselect | Right-Mouse more Info | Hold 's' or 'e' to select/deselect node you hover over",5,height-50);
   text("'a' - select all callees of current node | 'h' to hide lines being drawn | 'c' - Show callers of node | 'b' selects all caller nodes | 'o' open source in editor | 'i' to invert selection",5,height-30);
   fill(255);
    
    fill(0); stroke(0,255);
    if(dataString!=null){
      myTextArea.setText(dataString.getString());
      //text(dataString.getString(), 0,0, xSize, ySize);
    }
  }
  
  // 
  void setDataString(String s){
    dataString.setText(s);
  }
  
  
  /*
      Set the values for how the visualization sorts,
      and then update the layouts
  */
  void sortBy(int a){
    println("sortby: "+a);
    cd.setSortBy(a);
    // hw.m_histogram.setSortBy(a);
    bw.m_buckets.setSortBy(a);
    
        cd.update();
        // hw.m_histogram.update();
        bw.m_buckets.update();
        aw.m_calltree.update();
  }
  
  /*
      Set the values for how the visualization colors,
      and then update the layouts
  */
  void colorizeBy(int a){
    println("colorizeBy: "+a);
    cd.setColorizeBy(a);
    // hw.m_histogram.setColorizeBy(a);
    bw.m_buckets.setColorizeBy(a);
    
        cd.update();
        // hw.m_histogram.update();
        bw.m_buckets.update();
  }
  
  /*
      This function annotates the selected nodes.
      
      This is one of the key functions
  */
  void AnnotateSelected(){
    cd.annotateSelected("ChordPlot_worked","true");
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
    

      
        println("exited okay from Details Pane");
    }
    
    
    

    
}