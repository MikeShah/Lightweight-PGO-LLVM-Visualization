

// Purpose of this class is to
// 
class ChordDiagram extends DataLayer{
  
  float radius;
     
  public ChordDiagram(float radius, String file,int layout){
    this.radius = radius;
    this.layout = layout;
    // Calls init() which is from the DataLayer calss, and basically runs as a constructor
    init(file,0,0,layout);
    
  }
  
  
  void generateHeatForCalleeAttribute(){
    // Find the max and min from the ChordNode metadata
    float themin = 0;
    float themax =0;
    for(int i =0; i < nodeList.size();i++){
      themin = min(themin,nodeList.get(i).metaData.callees);
      themax = max(themax,nodeList.get(i).metaData.callees);
    }
    println("themin:"+themin);
    println("themax:"+themax);
    // Then map that value into the ChordNode so that it can render correctly.
    // We scale from 
    for(int i =0; i < nodeList.size();i++){
                                   // Get our callees and map it agains the min and max of other callees so we know how to make it stand out
      nodeList.get(i).metaData.c = map(nodeList.get(i).metaData.callees, themin, themax, 0, 255);
    }
    
  }
  
  /*
   h = center
   k = center
   r = radius
   numberOfPoints = How many points to draw on the circle
   
  */
  private void plotPointsOnCircle(float numberOfPoints){
    
    float steps = 360/numberOfPoints; // Based on how many points we have, 
                                      // draw a new point at each step
    float theta = 0; // angle to increase each loop
    
    int counter = 0;
    
    float xPos = 0;
    float yPos = 0;
    while(theta<360){
      xPos = centerx + radius*cos(theta);
      yPos = centery - radius*sin(theta);

      theta = theta + steps;

      if(counter < nodeList.size()){
        nodeList.get(counter).x = xPos;
        nodeList.get(counter).y = yPos;
      }
      counter++;
    }
    
  }
  
  private void plotPointsOnGrid(float numberOfPoints){
  
    float padding = 10; // padding on the screen
    float xSize = width-padding-200; // FIXME: 200 is because the GUI's width is 200
    float ySize = height-padding;
    
    float steps = 7; // Based on how many points we have, 
                                              // draw a new point at each step
    int counter = 0;
    for(  float yPos = 0; yPos < ySize-padding; yPos+=steps){
      for(float xPos = 0; xPos < xSize-padding; xPos+=steps){
        if(counter < nodeList.size()){
          nodeList.get(counter).x = xPos+padding;
          nodeList.get(counter).y = yPos+padding;
          counter++;
        }
      }
    }
    
  }
  
  private void plotPointsOnSphere(float numberOfPoints){   
    float steps = 360/numberOfPoints; // Based on how many points we have, 
                                      // draw a new point at each step
    float theta = 0; // angle to increase each loop
    

    Iterator<nodeMetaData> nodeListIter = dotGraph.fullNodeList.iterator();

    int counter = 0;
    while(counter < nodeList.size()){
      
      float p = radius;
      float phi = PI/3;
      
      float xPos = centerx + p*sin(phi)*cos(theta);
      float yPos = centery + p*sin(phi)*sin(theta);
      float zPos = p*cos(phi);
      /*
      float xPos = centerx + radius*cos(theta);
      float yPos = centery - radius*sin(theta);
      float zPos = radius*sin(theta);
      */
      nodeList.get(counter).x = xPos;
      nodeList.get(counter).y = yPos;
      nodeList.get(counter).z = zPos;
      
      theta = theta + steps;
      counter++;
    }
    
  }


  
  public void regenerateLayout(int layout){
    // Emptry the nodeList and regenerate it from the data
    nodeList.clear();
    this.layout = layout;
    
    // Go through our nodeList and grab all of the nodes
    Iterator<nodeMetaData> nodeListIter = dotGraph.fullNodeList.iterator();
    while(nodeListIter.hasNext()){
          // Create a new node for every node that was loaded from our instance of dotGraph
          nodeList.add(new ChordNode(nodeListIter.next().name,0,0,0));
    }
    
    // Modify all of the positions in our nodeList
    if(layout<=0){
      plotPointsOnCircle(dotGraph.fullNodeList.size()); // Plot points on the circle
    }else if(layout==1){
      plotPointsOnGrid(dotGraph.fullNodeList.size());
    }else if(layout>=2){
      plotPointsOnSphere(dotGraph.fullNodeList.size());
    }
    
    // Quick hack so the visualization can render quickly, also calculates the number of callees from the caller
    storeLineDrawings();
    // Draw the mapping of the visualization (Different layouts may need different 
    // functions called.
    generateHeatForCalleeAttribute();
  }
  
  @Override
  public void setPosition(float x, float y){
    centerx = x;
    centery = y;
  }
  
  public void draw(int mode){
      fill(192);
      
      if(this.layout==0){
        ellipse(centerx,centery,radius*2,radius*2);
      }
      
      for(int i =0; i < nodeList.size();i++){
        ChordNode temp = (ChordNode)nodeList.get(i);
        temp.render(mode);
      }
  }
  
}