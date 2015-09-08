// This is a random file for testing ideas
// Consider this a sandbox.
// Totally not necessary to keep this file in the project.

/* 

  Common Widget sandbox

  The purpose of this class is to split up the visualization into multiple windows, that all have
  similar filters, and ways of digging through information.

*/

class commonWidget extends PApplet{
  // The main GUI component
  ControlP5 cp5;
  // Window title
  String windowTitle;
   
  // This controls the dynamic size of our attributes
  int heightOfGUIElements = 10;
  
  /*
      Initialize all of the GUI components.
      Ideally this connects to the dataLayer.
  */
   private void  initGUI(){
    // Setup our GUI
      cp5 = new ControlP5( this );
    
      cp5.addSlider( "value-")
           .setRange( 0, 255 )
           .plugTo( this, "setValue" )
           .setValue( 127 )
           .setLabel("value")
           ;
                      
      ButtonBar b = cp5.addButtonBar("filterSelector")
           .setPosition(0, 0)
           .setSize(width, 20)
           .addItems(split("Metadata Attributes PGO Perf Graph Other Help"," "))
           ;

            
        // Populate list
          String[] test = new String[cd.nodeListStack.peek().size()];
          for(int i = 0; i < cd.nodeListStack.peek().size();i++){
            test[i] = cd.nodeListStack.peek().get(i).metaData.name;
          }
  
          cp5.addScrollableList("Function Scrollable List")
               .setPosition(width-360,20)
               .setSize(180,180)
               .addItems(test)
               ;
          
          cp5.get(ScrollableList.class, "Function Scrollable List").setItems(test);

/*
              println("setup attributesCheckbox");
      cp5.addCheckBox("AttributesCheckbox")
          .setPosition(10, 10)
          .setSize(10, heightOfGUIElements)
          .setItemsPerRow(1)
          .setSpacingRow(1)
          ;
*/
                // Populate the attributes
        int AttributeSpaceNeeded = 0;

println("a");
/*
        for (int i = 0 ; i < attributes.length; i++) {
            //attributesCheckbox.addItem(attributes[i], 0);
        }
*/
println("b");
        // Size the panel appropriately
       // cp5.get(Group.class, "Attribute Filters").setSize(200,AttributeSpaceNeeded+40);


  }
  
  
  /*
    Update our function list
  */
  synchronized public void updateFunctionList(){
    
    // Update the functions list with all of the applicable functions
    if(cd.nodeListStack.peek() != null ){
      String[] test = new String[cd.nodeListStack.peek().size()];
      for(int i = 0; i < test.length;i++){
        test[i] = cd.nodeListStack.peek().get(i).metaData.name;
      }
      
      println("test.size()"+test.length);
      // Update the Function List
      if(test!=null && cp5.get(ScrollableList.class, "Function Scrollable List") != null){
        cp5.get(ScrollableList.class, "Function Scrollable List").setItems(test);
      }
      println("booom");
    }
    
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
    // Help
    else if(n==6){
      println("clicked Help - Showing information about how to use this visualization");
    }
    
  }
  
  public commonWidget(){
      // Call the constructor for the PApplet
      super();
      println("aaa commonWidget()");
      PApplet.runSketch(new String[]{this.getClass().getName()}, this);
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
      println("aaa commonWidget(windowTitle)");
      PApplet.runSketch(new String[]{this.getClass().getName()}, this);
      // Setup our GUI
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
      
      // Instantiate attributes for the GUI -- This needs to be done before even the constructor! http://forum.processing.org/one/topic/problem-with-loadstrings-file-txt.html
      attributes = loadStrings("./attributes.txt");
    }
  
    public void draw() {
      background(0);
      
      rect(5,5,5,5);
    }
    */
}