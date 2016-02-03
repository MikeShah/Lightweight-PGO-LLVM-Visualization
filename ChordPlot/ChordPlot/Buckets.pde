/*
    This class serves as the details window to display other information.
*/
class BucketsWindow extends commonWidget {
  
  // a self-contained 
  Buckets m_buckets;
  String filename;

  int p_buckets_old = -1;
  int p_buckets = -1;
  Set<Integer> selectedBuckets = new HashSet<Integer>();

  // Colors for the picker
  int r = 192;
  int g = 192;
  int b = 192;
  int a = 255;

  // GUI interface for bucket selection
  ControlP5 cp5;
  ColorPicker cp;
  
  public BucketsWindow(String filename){
    this.filename = filename;
    println("a");
    m_buckets = new Buckets(filename,0,height-30,0);
  }
  
  public BucketsWindow(){
    println("a");
    m_buckets = new Buckets(filename,0,height-30,0);
  }
  
  public void settings() {
    size(755, 320, P3D);
    smooth();
  }
    
  public void setup() {
      println("setup Buckets");
      windowTitle = "Bucket Selection";
      surface.setTitle(windowTitle);
      surface.setLocation(980, 0);
      println("setup Buckets end");
      
      cp5 = new ControlP5(this);
      cp = cp5.addColorPicker("picker")
            .setPosition(500, 0)
            .setColorValue(color(0, 255, 0, 255))
            ;
            
            
// ==================================v Selectiont v==================================    
              cp5.addSlider("SelectionDepth")
                 .setRange( 0, 15 )
                 .setPosition(width-255,80)
                 .plugTo( this, "SelectionDepth" )
                 .setValue( 1 )
                 .setLabel("SelectionDepth")
                 ;
  
                // create a new button for selecting metaData
              cp5.addButton("SelectMetaDataFunctions")
                 .setPosition(width-255,100)
                 .setSize(180,19)
                 ;
                 
               // create a new button for selecting Attributes
              cp5.addButton("SelectAttributesFunctions")
                 .setPosition(width-255,120)
                 .setSize(180,19)
                 ;
                 
               // create a new button for selecting Line Information
              cp5.addButton("LineInformationFunctions")
                 .setPosition(width-255,140)
                 .setSize(180,19)
                 ;
                 
                 
               cp5.addTextfield("StartsWith")
                 .setPosition(width-255,160)
                 .setSize(180,19)
                 .setFocus(true)
                 .setColor(color(255,0,0))
                 ;   
                 
             cp5.addButton("SelectFunctions")
                 .setPosition(width-255+90,180)
                 .setSize(90,19)
                 .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                 ;   
                 
             cp5.addRange("SelectionRange")
                 // disable broadcasting since setRange and setRangeValues will trigger an event
                 .setBroadcast(false) 
                 .setPosition(width-255,200)
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
              cp5.addButton("CalleeSelectionFilters")
                 .setPosition(width-255,220)
                 .setSize(180,19)
                 ;
              cp5.addButton("CallerSelectionFilters")
                 .setPosition(width-255,240)
                 .setSize(180,19)
                 ;      
              cp5.addButton("PGODataSelectionFilters")
                 .setPosition(width-255,260)
                 .setSize(180,19)
                 ;          
              cp5.addButton("BitCodeSizeSelectionFilters")
                 .setPosition(width-255,280)
                 .setSize(180,19)
                 ;        
// ==================================^ Selectiont ^================================== 
  }
  
/*
    Temporary function to quickly select nodes with metadata.
  */
  void SelectMetaDataFunctions(){
    println("SelectMetaDataFunctions");
    cd.selectMetaData();
  }
  /*
    
    Temporary function to quickly select functions with attributes.
  */
  void SelectAttributesFunctions(){
    println("SelectAttributesFunctions");
    cd.selectAttributes();
  }
  
  /*
    
    Temporary function to quickly select functions with line information .
  */
  void LineInformationFunctions(){
    cd.selectLineInformation();
  }

 /*
      Search for functions that match the string and just select it
  */
 public void SelectFunctions() {
    String theText = cp5.get(Textfield.class,"StartsWith").getText(); 
    if(theText.length() > 0){
        // Apply the relevant filters
        cd.functionStartsWithSelect(theText);
        // hw.m_histogram.functionStartsWithSelect(theText);
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
      Apply a Filter based on the options we have selected.
      Makes use of the Range Slider
    */
    public void CalleeSelectionFilters(int theValue){
      cd.selectRange(CALLEE,selectionRangeMin, selectionRangeMax);
      // hw.m_histogram.selectRange(CALLEE,selectionRangeMin, selectionRangeMax);
      bw.m_buckets.selectRange(CALLEE,selectionRangeMin, selectionRangeMax);
    }
    /*
      Apply a Filter based on the options we have selected.
      Makes use of the Range Slider
    */
    public void CallerSelectionFilters(int theValue){  
      cd.selectRange(CALLER,selectionRangeMin, selectionRangeMax);
      // hw.m_histogram.selectRange(CALLER,selectionRangeMin, selectionRangeMax);
      bw.m_buckets.selectRange(CALLER,selectionRangeMin, selectionRangeMax);
    }
    /*
      Apply a Filter based on the options we have selected.
      Makes use of the Range Slider
    */
    public void PGODataSelectionFilters(int theValue){
      cd.selectRange(PGODATA,selectionRangeMin, selectionRangeMax);
      // hw.m_histogram.selectRange(PGODATA,selectionRangeMin, selectionRangeMax);
      bw.m_buckets.selectRange(PGODATA,selectionRangeMin, selectionRangeMax);
    }
    /*
      Apply a Filter based on the options we have selected.
      Makes use of the Range Slider
    */
    public void BitCodeSizeSelectionFilters(int theValue){
      cd.selectRange(BITCODESIZE,selectionRangeMin, selectionRangeMax);
      // hw.m_histogram.selectRange(BITCODESIZE,selectionRangeMin, selectionRangeMax);
      bw.m_buckets.selectRange(BITCODESIZE,selectionRangeMin, selectionRangeMax);
    }


// How many nodes to select
  void SelectionDepth(int theDepth) {
    CalleeDepth = theDepth;
  }

public void controlEvent(ControlEvent theEvent) {
  // when a value change from a ColorPicker is received, extract the ARGB values
  // from the controller's array value
    if(theEvent.isFrom(cp)) {
      r = int(theEvent.getArrayValue(0));
      g = int(theEvent.getArrayValue(1));
      b = int(theEvent.getArrayValue(2));
      a = int(theEvent.getArrayValue(3));
    }
  
        // Get the values from the CallSites range slider.
      if(theEvent.isFrom("SelectionRange")) {
        selectionRangeMin = int(theEvent.getController().getArrayValue(0));
        selectionRangeMax = int(theEvent.getController().getArrayValue(1));
        println("range update, done. ("+selectionRangeMin+","+selectionRangeMax+")");
      }
}
  
  public void draw() {
     
    if(m_buckets!=null){
        cp.getColorValue();  // Get the color values
        float m_x = mouseX;
        float m_y = mouseY; 
        
        // Every 250 milliseconds we're allowed to click
        if(millis() - lastTime > 250){
          canClick = true;
        }else{
          canClick = false;
        }
        
        int m_bucketsSizeTotal = 0;
        
                     if(m_buckets.showData){
                      background(0,64,164); fill(0); stroke(0); text("FPS: "+frameRate,width-120,height-20);
                      //pushMatrix();
                        //translate(0,0,MySimpleCamera.cameraZ);
                        // Draw some bounds
                        fill(0,64,128);
                        rect(m_buckets.xPosition+1,m_buckets.yPosition-m_buckets.yBounds-1,m_buckets.xBounds,m_buckets.yBounds);
                        
                        // Normalize the largest buckets
                        // The purpose is so we can use this information to scale the bucket
                        // heights and fit the visualization within the screen.
                        float largestBucket = 0;
                        float smallestBucket = 0;
                        for(int i = 0; i < m_buckets.bucketLists.size(); ++i){
                            smallestBucket = min(smallestBucket,m_buckets.bucketLists.get(i).size());
                            largestBucket = max(largestBucket,m_buckets.bucketLists.get(i).size());
                        }
                        
                                                
                        // Render the rectangles
                        for(int i =0; i < m_buckets.bucketLists.size(); ++i){
                          // Tally total nodes in visualization
                          m_bucketsSizeTotal += m_buckets.bucketLists.get(i).size();
                          
                          fill(192,255); stroke(255);
                          float bucketHeight = m_buckets.bucketLists.get(i).size();
                          float xBucketPosition = m_buckets.xPosition+(i*((int)m_buckets.bucketWidth));
                          bucketHeight = map(bucketHeight, smallestBucket, largestBucket, 0, m_buckets.scaledHeight);

                          // A bit hacky, but check to see if the mouse is over the region and then highlight the active nodes.
                          if(m_x >  xBucketPosition && m_x < xBucketPosition+m_buckets.bucketWidth){
                              // Just check if we are within our visualization. The reason is because we want to be able to select 
                              // even very small buckets by just sliding over them.
                              if(m_y < m_buckets.yPosition && m_y > m_buckets.yPosition-m_buckets.yBounds){
                                  // Give some text to tell us which bucket we are in
                                  text("Bucket# "+i,xBucketPosition,m_buckets.yPosition+10);
                                  text("range "+m_buckets.bucketLists.get(i).m_min+"-"+m_buckets.bucketLists.get(i).m_max,xBucketPosition,m_buckets.yPosition+20);
                  
                                  // Unhighlight all of the previous buckets that were highlighted.
                                  if(p_buckets != i || m_x <= 0){
                                    p_buckets_old = p_buckets;
                                    p_buckets = i;
                                    cd.highlightNodes(m_buckets.bucketLists.get(i),true);
                                    // Store the list of buckets we had previously highlighted
                                    // This allows us to quickly unhighlight them.
                                    
                                    if(p_buckets_old>-1){
                                        cd.highlightNodes(m_buckets.bucketLists.get(p_buckets_old),false);
                                    }
                                  }
                                  
                                  // If the mouse is pressed
                                  if(mousePressed==true){
                                      // TODO: Do not make me a hard link
                                        if(mouseButton==LEFT && canClick){ lastTime = millis(); canClick = false;
                                          if(selectedBuckets.contains(i)){
                                            cd.setNodesColors(m_buckets.bucketLists.get(i),r,g,b); // Update all effected nodes selection color
                                            cd.toggleActiveNodes(m_buckets.bucketLists.get(i));
                                            selectedBuckets.remove(i);
                                          }
                                          else{
                                            // Highlight the buckets we are over if we have not done so
                                            cd.toggleActiveNodes(m_buckets.bucketLists.get(i));
                                            selectedBuckets.add(i);
                                          }
                                        }
                                       else if(mouseButton==RIGHT){
                                          fill(0);
                                          text("Size:"+m_buckets.bucketLists.get(i).size(),m_x,m_y);
                                        }
                                  }
                              }
                                  // Useful debugging statement for selecting the correct bucket
                                  //text("selected: "+i+" prev: "+p_buckets+" prev2: "+p_buckets_old,200,200);
                                  fill(255,255,0,255); stroke(255);
                          }
                          
                          // If we have selected our bucket, then highlight it green.
                          if(selectedBuckets.contains(i)){
                            // Fill our rectangle if it is the selected one.
                            fill(0,255,0,255); stroke(255);
                          }
                          
                          // Draw our rectangle for each of the buckets
                          rect(xBucketPosition,m_buckets.yPosition-bucketHeight,m_buckets.bucketWidth,bucketHeight);
                        }
                      
                      //popMatrix();
                  } 
                  
                  
                  String sortingString = "";
                  if(m_buckets.sortBy==CALLEE){
                    sortingString = "Callee";
                  }else if(m_buckets.sortBy==CALLER){
                    sortingString = "Caller";                    
                  }else if(m_buckets.sortBy==PGODATA){
                    sortingString = "PGO Function Entry Counts";
                  }else if(m_buckets.sortBy==BITCODESIZE){
                    sortingString = "Bit Code Size";
                  }else if(m_buckets.sortBy==RECURSIVE){
                    sortingString = "Contains Recursion";
                  }
                  
                  text("Total Nodes: "+m_bucketsSizeTotal,width-350,120);
                  text("Sorting by: "+sortingString,width-350,160);
                  
                  
    } // m_buckets != null

  }  
  
}


/*
  This visualization takes a bunch of values,
  and generates buckets of an appropriate size.
  
  Algorithm:
  1.) Read in a bunch of data
  2.) Allocate some buckets of a certain size(say 5 buckets each of size 10. Thus, range of 0-9, 10-20, 21-30, 31-40, 41-50)
  3.) Put some feature of that data (Say callsites) into a bucket
  4.) For each item that is in a bucket, we need to also have that bucket be a list, so we can highlight active nodes in other visualizations.

*/
class Buckets extends DataLayer{
  
  // Store all of the nodes in each respective bucket
  // Make thread-safe
  CopyOnWriteArrayList<ChordNodeList> bucketLists;
  // The default number of Buckets
  int numberOfBuckets = 0;
  
  // How wide to draw our buckets in the actual visualization (see draw call)
  int bucketWidth = 50;
   
  int scaledHeight = 250; // Normalize visualization height and values to this
  
  // Default Constructor for the Buckets
  public Buckets(String file, float xPosition, float yPosition, int layout){
    this.visualizationName = "Buckets";
    // Call init which seets up the DataLayer.
    super.init(file, xPosition, yPosition,layout);

    bucketLists = new CopyOnWriteArrayList<ChordNodeList>();
    
    // Set a layout
    this.setLayout(layout);
    // Compute initial statistics
    // nodeListStack.computeSummaryStatistics(); // FIXME: Probably not needed
  } 

  // Get all of the points into our node list
  //
  // start is the maximum value where we want to show items
  // step - How big each bucket is
  private void plotPoints2D(){
    //println("buckets plotPoints2D");
    bucketLists.clear();
    println("==== Sorting by: " +sortBy);
    
    float minValue = 0;
    float maxValue = 1;
        
      // Compute the max and the min values based on how we are sorting.
      switch(sortBy){
        case CALLEE:
              minValue = minCallees;
              maxValue = maxCallees;
              break;
        case CALLER:
              minValue = minCallers;
              maxValue = maxCallers;
              break;
        case PGODATA:
              minValue = minPGO;
              maxValue = maxPGO;
              break;
        case BITCODESIZE:
              minValue = minBitCodeSize;
              maxValue = maxBitCodeSize;
              break;
        case RECURSIVE:
              // Do nothing, minValue and maxValue are 0 and 1 by default
        case FILENAME:
              // Each file will be assigned an integer from 0 to however many files there are.
              minValue = 1;
              maxValue = 10;
              break;
      } 

    // Float
    // The step value is how big of a range of items the buckets get
    float stepValue = (maxValue - minValue) / 10;  // TODO: This assumes positive values, may need to fix in the future.
    //stepValue = 5;

    // How many buckets do we allocate in our arrayList
    numberOfBuckets = 10;//(int) ((maxValue - minValue)/stepValue);
    
    // Allocate memory for all of the buckets we will need.
    for(int i = 0; i < numberOfBuckets; ++i){
      ChordNodeList temp = new ChordNodeList();
      temp.m_min=i*stepValue;
      temp.m_max=(i+1)*stepValue;
      bucketLists.add(temp);
    }
    
    println("numberOfBuckets: "+numberOfBuckets);
    println("bucketLists.size(): "+bucketLists.size());
    
    // Set the bounds by the number of rectangles we have
    xBounds = bucketWidth*numberOfBuckets;
    
    // Figure out which bucket to set the ChordNode to.
    for(int i =0; i < nodeListStack.peek().size();i++){
      int assignBucket = 0;
      // Increment which bucket we need to put our node in based on the step value.
      // If the attribute we're analyzing is less then the bucket size, then we know we have finished.
      for(int j = 0; j < bucketLists.size(); j++){       
        // Assign buckets  
        switch(sortBy){
            case CALLEE:
                  if (nodeListStack.peek().get(i).metaData.callees > j*stepValue){
                    assignBucket++;
                  }
                  break;
            case CALLER:
                  if (nodeListStack.peek().get(i).metaData.callers > j*stepValue){
                    assignBucket++;
                  }
                  break;
            case PGODATA:
                  if (nodeListStack.peek().get(i).metaData.PGOData > j*stepValue){
                    assignBucket++;
                  }
                  break;
            case BITCODESIZE:
                  if (nodeListStack.peek().get(i).metaData.bitCodeSize > j*stepValue){
                    assignBucket++;
                  }
                  break;
            case RECURSIVE:
                  if (nodeListStack.peek().get(i).metaData.recursive > j*stepValue){
                    assignBucket++;
                  }
                  break;
        }
      }
      
      // clamp our values within the number of buckets we have
      if(assignBucket < 0)                 {  assignBucket = 0;  }
      if(assignBucket > numberOfBuckets-1) {  assignBucket = numberOfBuckets-1;  }  
      
      // All of the nodes that are within the right bucket get assigned to their proper bucket.
      nodeListStack.peek().get(i).bucket = assignBucket;
      // Add an actual copy of the ChordNode to the bucket that it is assigned to
      // This will allos us to quickly highlight over a bucket, and select the nodes that fall in that subset.
      bucketLists.get(assignBucket).add(nodeListStack.peek().get(i));
    }
    
    // Set the yBounds to the max value that our visualization scales to.
    yBounds = (int)map(maxValue, minValue, maxValue, 0, 350);
    
    // Clean up our buckets, so if there is nothing in one, get rid of it.
    for(int i = 0; i < bucketLists.size(); ++i){
      if(bucketLists.get(i).size()==0){
        // remove the bucket from the list
        bucketLists.remove(i);
      }
    }
  }
  
  
  /*
      Currently there is only one layout supported.
  */
  public void setLayout(int layout){
    //println("buckets setLayout");
    this.layout = layout;
    
    bucketLists.clear();        
        
    // Quick hack so the visualization can render quickly, also calculates the number of callees from the caller
    // This is called after we have positioned all of our nodes in the visualization
    storeLineDrawings();
    // Draw the mapping of the visualization (Different layouts may need different 
    // functions called.
    // This function cycles through all of the nodes and generates a numerical value that can be sorted by
    // for some attribute that we care about
    generateHeatForCalleeAttribute(scaledHeight, false);
    
    sortNodesBy();
    
    // Modify all of the physical locations in our nodeList
    fastUpdate();
    
    // Quick hack so the visualization can render quickly, also calculates the number of callees from the caller
    // This is called after we have positioned all of our nodes in the visualization
    storeLineDrawings();
  }
    
  /*
  
  // DEPRECATED: Now should be using the DataLayer version
  
  // Here maxHeight represents how many pixels we scale to (
  // (i.e. the maximum value in the set will equal this)
  void generateHeatForCalleeAttribute(float maxHeight){
    //println("buckets generateHeatForCalleeAttribute");
    // Find the max and min from the ChordNode metadata
    for(int i =0; i < nodeListStack.peek().size();i++){
      minValue = min(minValue,nodeListStack.peek().get(i).metaData.callees);
      maxValue = max(maxValue,nodeListStack.peek().get(i).metaData.callees);
    }
    
    // Set the yBounds to the max value that our visualization scales to.
    yBounds = (int)map(maxValue, minValue, maxValue, 0, maxHeight);
    
    println("themin:"+minValue);
    println("themax:"+maxValue);
    // Then map that value into the ChordNode so that it can render correctly.
    // We scale from 
    for(int i =0; i < nodeListStack.peek().size();i++){
      // Get our callees and map it agains the min and max of other callees so we know how to make it stand out
      nodeListStack.peek().get(i).metaData.callees = (int)map(nodeListStack.peek().get(i).metaData.callees, minValue, maxValue, 0, maxHeight);
      nodeListStack.peek().get(i).metaData.c = nodeListStack.peek().get(i).metaData.callees;
    }
  }
  */
  
  
  /*
      Useful for being used in update where we don't need to do anything else with the data.
      This means setLayout should only be called once initially.
      
      Fast layout will layout the nodes. It is nice to have this abstracted away
      into its own function so we can quickly re-plot the nodes without doing additional
      computations.
  */
  public void fastUpdate(){
    //println("buckets fastUpdate");
    // Modify all of the positions in our nodeList
    // this.generateHeatForCalleeAttribute(scaledHeight); // TODO: We may need this if we call fastUpdate independently, but for now all calls are using update()
    if(this.layout <= 0){
      //this.generateHeatForCalleeAttribute(scaledHeight);
      plotPoints2D();
    }else{
      println("No other other layout, using default");
      plotPoints2D();
    }
  }
  
  // After we filter our data, make an update
  // so that our visualization is reset based on the
  // active data.
  @Override
  public void update(){
    println("buckets update");
     this.setLayout(layout);
  }
  
  // Output all of the buckets and their respective sizes
  public void debug(){
        // Render the rectangles
        for(int i =0; i < bucketLists.size(); ++i){
          fill(192); stroke(255);
          float bucketHeight = bucketLists.get(i).size();
          println("Bucket: "+i+" has: "+bucketHeight);
        }
  }
  
  
  /*
  
  DEPRECATED: Because Processing needs to render everything in the main thread
              we cannot have other draw routines, even if they're in different windows(which really should have their own drawing thread..).
  
  // Draw using our rendering modes
  //
  //
  // Buckets is slightly more unique then ChordDiagram or Histogram
  // In that we only need to draw the rectangles for their bucketsizes.
  // We have to normalize all of the sizes based on maxValue and our visualization space.
  public void draw(int mode){
    if(showData){
          // Draw a background
          pushMatrix();
            //translate(0,0,MySimpleCamera.cameraZ);
            drawBounds(0,64,128, xPosition,yPosition-yBounds);
            
            // Normalize the largest buckets
            // The purpose is so we can use this information to scale the bucket
            // heights and fit the visualization within the screen.
            float largestBucket = 0;
            float smallestBucket = 0;
            for(int i = 0; i < bucketLists.size(); ++i){
                smallestBucket = min(smallestBucket,bucketLists.get(i).size());
                largestBucket = max(largestBucket,bucketLists.get(i).size());
            }
            
            // Render the rectangles
            for(int i =0; i < bucketLists.size(); ++i){
              fill(192,255); stroke(255);
              float bucketHeight = bucketLists.get(i).size();
              float xBucketPosition = xPosition+(i*((int)bucketWidth));
              bucketHeight = map(bucketHeight, smallestBucket, largestBucket, 0, scaledHeight);
              
              // A bit hacky, but check to see if the mouse is over the region and then highlight the active nodes.
              if(MySimpleCamera.xSelection >  xBucketPosition && MySimpleCamera.xSelection < xBucketPosition+bucketWidth){
                // Just check if we are within our visualization. The reason is because we want to be able to select 
                // even very small buckets by just sliding over them.
                if(MySimpleCamera.ySelection > yPosition-yBounds && MySimpleCamera.ySelection < yPosition){
                  fill(0,255,0,255); stroke(255);
                  // Give some text to tell us which bucket we are in
                  // Also display the min and max of each bucket, which is stored int he chordlist of each bucketlist.
                  text("Bucket# "+i,xBucketPosition,yPosition+10);
                  text("range "+bucketLists.get(i).m_min+"-"+bucketLists.get(i).m_max,xBucketPosition,yPosition+20);
                  
                  cd.highlightNodes(bucketLists.get(i),true);
                  // If the mouse is pressed
                  if(mousePressed==true ){
                    // TODO: Do not make me a hard link
                    if(mouseButton==LEFT){
                      cd.toggleActiveNodes(bucketLists.get(i));
                    }

                  }
                }
              }
              
              // Draw our rectangle
              rect(xBucketPosition,yPosition-bucketHeight,bucketWidth,bucketHeight);
             
            }
          
          popMatrix();
    
      }
  }
  */
}