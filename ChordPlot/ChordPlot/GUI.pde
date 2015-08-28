/*
  
    This file contains everything concerned with the GUI

*/

// Our control panel
ControlP5 filtersPanel;
// Collapse into one
Accordion accordion;
// Breadcrumbs
ButtonBar breadCrumbsBar;

/* Global values for our sliders */
int callSiteMin = 20;
int callSiteMax = 100;
int maxNumberOfCallsites = 255;

/* Figure out attributes for our program */
CheckBox attributesCheckbox;
String attributes[];

// This controls the dynamic size of our attributes
int heightOfGUIElements = 10;


void initGUI(){
  filtersPanel = new ControlP5(this);
  
  breadCrumbsBar = filtersPanel.addButtonBar("theBreadCrumbsBar")
                       .setPosition(0, height-20)
                       .setSize(width, 20)
                       ;
                       
  Group attributeFiltersSet = filtersPanel.addGroup("Attribute Filters")
                        .setBackgroundColor(color(64,50))
                        ;
                                           
                    attributesCheckbox = filtersPanel.addCheckBox("AttributesCheckbox")
                        .setPosition(10, 10)
                        .setSize(10, heightOfGUIElements)
                        .setItemsPerRow(1)
                        .setSpacingRow(1)
                        .setGroup(attributeFiltersSet)
                        ;
                       /* Search for attributes that we can filter in our GUI - Code to Dynamically setup the attributes*/
                                                                      attributes = loadStrings("./attributes.txt");
                                                                      // Populate the attributes
                                                                      int AttributeSpaceNeeded = 0;
                                                                      for (int i = 0 ; i < attributes.length; i++) {
                                                                            attributesCheckbox.addItem(attributes[i], 0);
                                                                            AttributeSpaceNeeded += heightOfGUIElements + 1;
                                                                      }
                                                                      // Size the panel appropriately
                                                                      filtersPanel.get(Group.class, "Attribute Filters").setSize(200,AttributeSpaceNeeded+40);
                                                                      
                    filtersPanel.addRange("CallSites")
                       // disable broadcasting since setRange and setRangeValues will trigger an event
                       .setBroadcast(false) 
                       .setPosition(10,AttributeSpaceNeeded+heightOfGUIElements)
                       .setSize(140,heightOfGUIElements)
                       .setHandleSize(10)
                       .setRange(0,maxNumberOfCallsites)
                       .setRangeValues(callSiteMin,callSiteMax)
                       // after the initialization we turn broadcast back on again
                       .setBroadcast(true)
                       .setColorForeground(color(255,40))
                       .setColorBackground(color(255,40))
                       .setGroup(attributeFiltersSet)
                       ;
                       
                    // create a new button for outputting Dot files
                    filtersPanel.addButton("ApplyOurFilters")
                       .setPosition(10,AttributeSpaceNeeded+heightOfGUIElements+heightOfGUIElements)
                       .setSize(180,19)
                       .setGroup(attributeFiltersSet)
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
                    .setSize(150,240)
                    .setBackgroundColor(color(64,100))
                    ;
                
              filtersPanel.addScrollableList("Function Scrollable List")
                   .setPosition(10,10)
                   .setSize(180,180)
                   .setGroup(functionListGroup)
                   .addItems(java.util.Arrays.asList("a","b","c","d","e","f","g","h","i","j","k","L","M","N","O","P","Q","R"))
                   ;
                 
              // create a new button for outputting Dot files
              filtersPanel.addButton("OutputDOT")
                   //.setValue(0) // Note that setting the value forces a call to this function (which sort of makes sense, as it will call your function at least once to set things up to align with the GUI).
                   .setPosition(10,200)
                   .setSize(180,19)
                   .setGroup(functionListGroup)
                   ;
                   
              // create a new button for outputting Dot files
              filtersPanel.addButton("OutputSelectedDOT")
                   //.setValue(0) // Note that setting the value forces a call to this function (which sort of makes sense, as it will call your function at least once to set things up to align with the GUI).
                   .setPosition(10,220)
                   .setSize(180,19)
                   .setGroup(functionListGroup)
                   ;

  // Populate list
  String[] test = new String[cd.nodeListStack.peek().size()];
  for(int i = 0; i < cd.nodeListStack.peek().size();i++){
    test[i] = cd.nodeListStack.peek().get(i).metaData.name;
  }
  
  filtersPanel.get(ScrollableList.class, "Function Scrollable List").setItems(test);
  

  
  
      // create a new accordion
  // add g1, g2, and g3 to the accordion.
  accordion = filtersPanel.addAccordion("AccordionLayout")
                 .setPosition(width-200,0)
                 .setWidth(200)
                 .addItem(attributeFiltersSet)
                 .addItem(layoutPanel)
                 .addItem(functionListGroup)
                 ;
                 
                 
  // Open all three of our panels by default
  accordion.open(0,1,2);
  // Allow us to open multiple levels at a time
  accordion.setCollapseMode(Accordion.MULTI);
  
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

  // Get the values from the CallSites range slider.
  if(theEvent.isFrom("CallSites")) {
    callSiteMin = int(theEvent.getController().getArrayValue(0));
    callSiteMax = int(theEvent.getController().getArrayValue(1));
    //println("range update, done. ("+callSiteMin+","+callSiteMax+")");
  }
  
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


// Histogram
public void Histogram(int theValue) {
  h.showData = !h.showData;
}

// Microarray
public void Microarray(int theValue) {
  cd.showData = !cd.showData;
}

/*
  Apply a Filter based on the options we have selected.
*/
public void ApplyOurFilters(int theValue){
  String FilterString = cd.nodeListStack.peek().name;
  // Apply the relevant filters
  cd.filterCallSites(callSiteMin, callSiteMax);
  cd.update(); // Make a call to update the visualization
  
  h.filterCallSites(callSiteMin, callSiteMax);
  h.update(); // Make a call to update the visualization
  
  bw.m_buckets.filterCallSites(callSiteMin, callSiteMax);
  bw.m_buckets.update();
  
  // Add our item to the list
  breadCrumbsBar.addItem(FilterString,cd.nodeListStack.size()-1);
  
  updateFunctionList();
}

/*
  Update our function list
*/
public void updateFunctionList(){
  // Update the functions list with all of the applicable functions
  String[] test = new String[cd.nodeListStack.peek().size()];
  for(int i = 0; i < test.length;i++){
    test[i] = cd.nodeListStack.peek().get(i).metaData.name;
  }
  
  // Update the Function List
  filtersPanel.get(ScrollableList.class, "Function Scrollable List").setItems(test);
}


/*
    Used for popping the stack from our main objects
*/
public void theBreadCrumbsBar(int n){
  if(mouseButton == LEFT){
    println("-------------------------------------------Setting Stack to this node", n);
    ChordNodeList temp = (ChordNodeList)cd.nodeListStack.pop();
    ChordNodeList temp2 = (ChordNodeList)h.nodeListStack.pop();
    ChordNodeList temp3 = (ChordNodeList)bw.m_buckets.nodeListStack.pop();
    
    if(temp!=null){  // If we didn't pop anything off of the stack, then do not remove any items
      filtersPanel.get(ButtonBar.class, "theBreadCrumbsBar").removeItem(temp.name);
      cd.fastUpdate(); // Make a call to update the visualization
      h.fastUpdate();
      bw.m_buckets.fastUpdate();
    }
    if(cd.nodeListStack.size()==1){
      filtersPanel.get(ButtonBar.class, "theBreadCrumbsBar").clear();
    }

  }else if(mouseButton == RIGHT){
    println("Clearing Stack to this node", n);
    while(cd.nodeListStack.size()>n+1){
      ChordNodeList temp = (ChordNodeList)cd.nodeListStack.pop();
      ChordNodeList temp2 = (ChordNodeList)h.nodeListStack.pop();
      ChordNodeList temp3 = (ChordNodeList)bw.m_buckets.nodeListStack.pop();
      
      if(temp!=null){  // If we didn't pop anything off of the stack, then do not remove any items
        filtersPanel.get(ButtonBar.class, "theBreadCrumbsBar").removeItem(temp.name);
        cd.fastUpdate(); // Make a call to update the visualization
        h.fastUpdate();
        bw.m_buckets.fastUpdate();
      }
      if(cd.nodeListStack.size()==1){
        filtersPanel.get(ButtonBar.class, "theBreadCrumbsBar").clear();
      }
    }
  }
}