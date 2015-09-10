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


// How far many levels to draw to callees when we highlight over nodes.
int CalleeDepth = 1;

// This is the string we push onto the bread crumbs bar to remind
// us what filter we last ran when we push.
String breadCrumbsString = "";

int heightOfGUIElements = 20;

void initGUI(){
  filtersPanel = new ControlP5(this);
  
  breadCrumbsBar = filtersPanel.addButtonBar("theBreadCrumbsBar")
                       .setPosition(0, height-20)
                       .setSize(width, 20)
                       ;                                      
       
}


/*

DEPRECATED can be removed eventually

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
  
  println("exited okay from GUI");
}
*/

// Histogram
public void Histogram(int theValue) {
  hw.m_histogram.showData = !hw.m_histogram.showData;
}

// Microarray
public void Microarray(int theValue) {
  cd.showData = !cd.showData;
}


/*
    Used for popping the stack from our main objects
*/
public void theBreadCrumbsBar(int n){
  if(mouseButton == LEFT){
    println("-------------------------------------------Setting Stack to this node", n);
    ChordNodeList temp = (ChordNodeList)cd.nodeListStack.pop();
                            hw.m_histogram.nodeListStack.pop();
                              bw.m_buckets.nodeListStack.pop();
    
    if(temp!=null){  // If we didn't pop anything off of the stack, then do not remove any items
      filtersPanel.get(ButtonBar.class, "theBreadCrumbsBar").removeItem(temp.name);
      cd.fastUpdate(); // Make a call to update the visualization // FIXME: See if I can use fastUpdate() to speed things up
      hw.m_histogram.fastUpdate();
      bw.m_buckets.fastUpdate();

      hw.updateFunctionList();
      bw.updateFunctionList();
    }
    if(cd.nodeListStack.size()==1){
      filtersPanel.get(ButtonBar.class, "theBreadCrumbsBar").clear();
    }

  }else if(mouseButton == RIGHT){
    println("Clearing Stack to this node", n);
    while(cd.nodeListStack.size()>n+1){
      ChordNodeList temp = (ChordNodeList)cd.nodeListStack.pop();
                              hw.m_histogram.nodeListStack.pop();
                                bw.m_buckets.nodeListStack.pop();
      
      if(temp!=null){  // If we didn't pop anything off of the stack, then do not remove any items
        filtersPanel.get(ButtonBar.class, "theBreadCrumbsBar").removeItem(temp.name);
        cd.fastUpdate(); // Make a call to update the visualization // FIXME: See if I can use fastUpdate() to speed things up
        hw.m_histogram.fastUpdate();
        bw.m_buckets.fastUpdate();
        
        hw.updateFunctionList();
        bw.updateFunctionList();
      }
      if(cd.nodeListStack.size()==1){
        filtersPanel.get(ButtonBar.class, "theBreadCrumbsBar").clear();
      }
    }
  }
}