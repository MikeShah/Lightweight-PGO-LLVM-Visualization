import controlP5.*;

// Our control panel
ControlP5 filtersPanel;
// Collapse into one
Accordion accordion;

/* Create our visualizations */
ChordDiagram cd;
Histogram h;


void initGUI(){
  filtersPanel = new ControlP5(this);
  
  Group filterSet1 = filtersPanel.addGroup("Filters")
                    .setSize(160,120)
                    .setPosition(100,100)
                    .setBackgroundColor(color(64,50))
                    ;
                    
                    filtersPanel.addRadioButton("Attributes")
                       .setPosition(10,10)
                       .setSize(20,9)
                       .addItem("some attribute",0)
                       .addItem("inlined",1)
                       .addItem("another thing",2)
                       .addItem("readonly",3)
                       .addItem("writestomemory",4)
                       .setGroup(filterSet1)
                       ;
                       
                    filtersPanel.addRange("Call sites")
                       // disable broadcasting since setRange and setRangeValues will trigger an event
                       .setBroadcast(false) 
                       .setPosition(10,100)
                       .setSize(80,15)
                       .setHandleSize(10)
                       .setRange(0,255)
                       .setRangeValues(50,100)
                       // after the initialization we turn broadcast back on again
                       .setBroadcast(true)
                       .setColorForeground(color(255,40))
                       .setColorBackground(color(255,40))
                       .setGroup(filterSet1)
                       ;
     
  Group layoutPanel = filtersPanel.addGroup("Layouts")
                .setPosition(280,100)
                .setWidth(220)
                .activateEvent(true)
                .setBackgroundColor(color(64,80))
                .setBackgroundHeight(100)
                .setLabel("Visualization Layouts")
                ;
  
                filtersPanel.addRadioButton("Microarray")
                   .setPosition(10,10)
                   .setSize(20,9)
                   .addItem("ChordDiagram2D",0)
                   .addItem("Microarray2D",1)
                   .addItem("ChordDiagram3D",2)
                   .setGroup(layoutPanel)
                   ;
                   
                 filtersPanel.addRadioButton("Histogram")
                   .setPosition(10,80)
                   .setSize(20,9)
                   .addItem("Histogram2D",0)
                   .setGroup(layoutPanel)
                   ;
                   
  Group functionListGroup = filtersPanel.addGroup("Function List")
                .setPosition(600,100)
                .setSize(150,200)
                .setBackgroundColor(color(64,100))
                ;
                
              filtersPanel.addScrollableList("FunctionScrollableList")
                 .setPosition(10,10)
                 .setSize(180,180)
                 .setGroup(functionListGroup)
                 .addItems(java.util.Arrays.asList("a","b","c","d","e","f","g","h","i","j","k","L","M","N","O","P","Q","R"))
                 ;

    // create a new accordion
  // add g1, g2, and g3 to the accordion.
  accordion = filtersPanel.addAccordion("acc")
                 .setPosition(width-200,0)
                 .setWidth(200)
                 .addItem(filterSet1)
                 .addItem(layoutPanel)
                 .addItem(functionListGroup)
                 ;
  // Open all three of our panels by default
  accordion.open(0,1,2);
  // Allow us to open multiple levels at a time
  accordion.setCollapseMode(Accordion.MULTI);

  String[] test = new String[h.nodeList.size()];
  for(int i = 0; i < h.nodeList.size();i++){
    test[i] = h.nodeList.get(i).metaData.name;
  }
  
  filtersPanel.get(ScrollableList.class, "FunctionScrollableList").setItems(test);

}

void setup(){
  size(1200 , 900,P3D);
  String filename = "output.dot";
   
  cd = new ChordDiagram(400, filename,1);
  h = new Histogram(filename,20,height-100,0);
  
  // Initialize our GUI after our data has been loaded
  initGUI();
}

int drawMode = 0;

// 
// an event from slider sliderA will change the value of textfield textA here
public void sliderA(String item) {
  filtersPanel.get(ScrollableList.class, "FunctionScrollableList").clear();
  List<String> test = new ArrayList<String>();
  filtersPanel.get(ScrollableList.class, "FunctionScrollableList").setItems(test);
}

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
}

void draw(){
  println("FPS :"+frameRate);
   
   background(128);
   
   pushMatrix();
     translate(MySimpleCamera.cameraX,MySimpleCamera.cameraY,MySimpleCamera.cameraZ);
     cd.draw(drawMode);
     
     h.draw(0);
   popMatrix();
}


int keyIndex = 0;
// Determine how deep in the tree we go.
void keyPressed() {
  
  if (key >= '0' && key <= '9') {
    keyIndex = key - '0';
    println(key-'0');
    cd.setLayout(keyIndex);
    
    // Reset the camera
    MySimpleCamera.cameraX = 0;
    MySimpleCamera.cameraY = 0;
    MySimpleCamera.cameraZ = 0;
    
    if(keyIndex==2){
      drawMode = 1;
    }
    else{
      drawMode = 0;
    }
  } else if (key >= 'a' && key <= 'z') {
    keyIndex = key - '0';
    println(key-'0');
  }
  
  // Simple camera
  if(keyCode == LEFT){
    MySimpleCamera.moveLeft();
  }
  if(keyCode == RIGHT){
    MySimpleCamera.moveRight();
  }
  if(keyCode == UP){
    MySimpleCamera.moveForward();
  }
  if(keyCode == DOWN){
    MySimpleCamera.moveBack();
  }
  if(keyCode == CONTROL){
    MySimpleCamera.moveUp();
  }
  if(keyCode == SHIFT){
    MySimpleCamera.moveDown();
  }
  
}