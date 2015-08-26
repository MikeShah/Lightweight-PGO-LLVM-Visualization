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
  ArrayList<ChordNodeList> bucketLists;
  // The default number of Buckets
  int numberOfBuckets = 0;
  
  // How wide to draw our buckets in the actual visualization (see draw call)
  int bucketWidth = 50;
  
  // For now there is an assumption that these
  // are all positive values
  float maxValue  = 0;
  float minValue  = 0;
  float stepValue = 5;
  
  int scaledHeight = 250; // Normalize visualization height and values to this
  
  // Default Constructor for the Buckets
  public Buckets(String file, float xPosition, float yPosition, int layout){
    this.VisualizationName = "Buckets";
    // Call init which seets up the DataLayer.
    super.init(file, xPosition, yPosition,layout);

    bucketLists = new ArrayList<ChordNodeList>();
    
    // Set a layout
    this.setLayout(layout);
    // Compute initial statistics
    nodeListStack.computeSummaryStatistics();
  }
  

  // Get all of the points into our node list
  //
  // start is the maximum value where we want to show items
  // step - How big each bucket is
  private void plotPoints2D(){
    bucketLists.clear();
    
    // How many buckets do we allocate in our arrayList
    numberOfBuckets = (int) ((maxValue - minValue)/stepValue);
    
    // Allocate memory for all of the buckets we will need.
    for(int i = 0; i < numberOfBuckets; ++i){
      bucketLists.add(new ChordNodeList());
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
        if (nodeListStack.peek().get(i).metaData.callees > j*stepValue){
          assignBucket++;
        }else
        {
          break;
        }
      }
      
      // clamp our values within a certain range
      if(assignBucket < 0)                 {  assignBucket = 0;  }
      if(assignBucket > numberOfBuckets-1) {  assignBucket = numberOfBuckets-1;  }
      // All of the nodes that are within the right bucket get assigned to their proper bucket.
      nodeListStack.peek().get(i).bucket = assignBucket;
      // Add an actual copy of the ChordNode to the bucket that it is assigned to
      // This will allos us to quickly highlight over a bucket, and select the nodes that fall in that subset.
      bucketLists.get(assignBucket).add(nodeListStack.peek().get(i));
      
    }
  }
  
  
  /*
      Currently there is only one layout supported.
  */
  public void setLayout(int layout){
    this.layout = layout;
        
    // Quick hack so the visualization can render quickly, also calculates the number of callees from the caller
    // This is called after we have positioned all of our nodes in the visualization
    storeLineDrawings();
    // Draw the mapping of the visualization (Different layouts may need different 
    // functions called.
    // This function cycles through all of the nodes and generates a numerical value that can be sorted by
    // for some attribute that we care about
    this.generateHeatForCalleeAttribute(scaledHeight);
    
    sortNodesByCallee();
    
    if(layout<=0){
      plotPoints2D();
    }else{
      plotPoints2D();
    }
    
    // Quick hack so the visualization can render quickly, also calculates the number of callees from the caller
    // This is called after we have positioned all of our nodes in the visualization
    storeLineDrawings();
  }
    
  
  // Here maxHeight represents how many pixels we scale to (
  // (i.e. the maximum value in the set will equal this)
  void generateHeatForCalleeAttribute(float maxHeight){
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
  
    /*
      Useful for being used in update where we don't need to do anything else with the data.
  */
  public void fastUpdate(){
    int layout = this.layout;
    // Modify all of the positions in our nodeList
    if(layout<=0){
      plotPoints2D();
    }else{
      plotPoints2D();
    }
  }
  
  // After we filter our data, make an update
  // so that our visualization is reset based on the
  // active data.
  @Override
  public void update(){
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
            translate(0,0,MySimpleCamera.cameraZ);
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
                  text("Bucket# "+i,xBucketPosition,yPosition+10);
                  
                  cd.highlightNodes(bucketLists.get(i));
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
}