/*
    This class serves as the details window to display other information.
*/
public class EncodingWindow extends PApplet {
  
  // Our control panel
  ControlP5 encodingPanel;
  
  // Encoding options for the nodes
  // By naming the same as the toggle button, the controller will use these guys.
  boolean AnimateEncoding = false;
  boolean RectangleEncoding = false;
  boolean SymbolEncodoing = false;
  
  /*
      Build the GUI for the Details Pane
  */
  void initGUI(){
      encodingPanel = new ControlP5(this);
  
             encodingPanel.addButton("EncodeSelected")
                 .setPosition(0,0)
                 .setSize(90,19)
                 .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                 ; 
                 
             encodingPanel.addButton("UnEncodeSelected")
                 .setPosition(90,0)
                 .setSize(90,19)
                 .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                 ;
                 
             encodingPanel.addButton("SelectEncoded")
                 .setPosition(180,0)
                 .setSize(90,19)
                 .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                 ;                 
      
             encodingPanel.addTextfield("EncodeSymbol")
                 .setPosition(0,40)
                 .setSize(90,19)
                 .setFocus(true)
                 .setColor(color(255,0,0))
                 ;   
             
             encodingPanel.addToggle("AnimateEncoding")
               .setPosition(95,40)
               .setSize(40,20)
               ;
               
             encodingPanel.addToggle("RectangleEncoding")
               .setPosition(95,80)
               .setSize(40,20)
               ;
               
             encodingPanel.addToggle("SymbolEncodoing")
               .setPosition(95,120)
               .setSize(40,20)
               ;               
  }
  
  
  public EncodingWindow() {
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
    println("setup EncodingPane");
    surface.setTitle("Encoding View");
    surface.setLocation(0, 0);
    println("setup EncodingPane end");
  }

  public void draw() {
    background(145,160,176);
    
    // Draw the help
    noFill();
    noStroke();
    fill(255);stroke(255);
    text("FPS :"+int(frameRate),width-250,height-40);
    
    fill(0); stroke(0,255);
  }
    
    void controlEvent(ControlEvent theEvent) {
    }
    
    /*
      Encode Selected
    */
    public void EncodeSelected(){
      String theText = encodingPanel.get(Textfield.class,"EncodeSymbol").getText(); 
      if(theText.length() > 0){
        cd.encodeNodesWith(1,true,theText,AnimateEncoding,RectangleEncoding,SymbolEncodoing);
      }
    }
    /*
      UnEncode Selected
    */
    public void UnEncodeSelected(){
      cd.encodeNodesWith(1,false,"",false,false,false);
    }
    /* 
      Select all the nodes we have encoded
    */
    public void SelectEncoded(){
      println("Trying to select stuff");
      cd.selectEncodedNodes();
    }
    
}