/*
    This class serves as the details window to display other information.
*/
public class EncodingWindow extends PApplet {
  
  // Our control panel
  ControlP5 encodingPanel;
  
  // Encoding options for the nodes
  // By naming the same as the toggle button, the controller will use these guys.
  boolean AnimateEncoding = true;
  boolean RectangleEncoding = true;
  boolean SymbolEncodoing = true;
  
  // Parameters to store encodings
  String theText="";  
  float spinRotation = 0;
  
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
    size(280, 200);
    smooth();
  }
  public void setup() { 
    println("setup EncodingPane");
    surface.setTitle("Encoding View");
    surface.setLocation(900, 320);
    println("setup EncodingPane end");
    frameRate(60);
  }

  public void draw() {
    // Reset the text size
    textSize(12);
    background(145,160,176);
    
    // Draw the help
    noFill();
    noStroke();
    fill(255);stroke(255);
    text("FPS :"+int(frameRate),width-250,height-40); 
    

    float rectHeight = 80;
    float rectWidth = 80;
    float x = 0;
    float y = 40;
  
    fill(192); stroke(0,255);
    rect(x,y+rectHeight/2,80,80);
      
       if(RectangleEncoding){
           fill(255); stroke(0);
           float halfWidth = rectWidth/2;
           float halfHeight = rectHeight/2;
            
           pushMatrix();
           if(AnimateEncoding){
             rectMode(CENTER);  // Set rectMode to CENTER
             translate(x+halfWidth,y+rectHeight);
             rotate(radians(spinRotation));
             rect(0,0,halfWidth,halfHeight);
             rectMode(CORNER);  // Set rectMode to CENTER
             spinRotation++;
           }
           else{
             rect(x+halfWidth/2,y+halfHeight,halfWidth,halfHeight);
           }   
           popMatrix();
       }
       if(SymbolEncodoing){
         // Apply Encodings
         fill(0);
         stroke(0);
         textSize(30);
         text(theText,x+rectWidth/2,y+rectHeight);
         textSize(rectHeight);
         theText = encodingPanel.get(Textfield.class,"EncodeSymbol").getText(); 
       }

  }
    
    void controlEvent(ControlEvent theEvent) {
    }
    
    /*
      Encode Selected
    */
    public void EncodeSelected(){
      theText = encodingPanel.get(Textfield.class,"EncodeSymbol").getText(); 
      cd.encodeNodesWith(1,true,theText,AnimateEncoding,RectangleEncoding,SymbolEncodoing);
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