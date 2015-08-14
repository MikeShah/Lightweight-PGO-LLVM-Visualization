

// Purpose of this class is to
// 
class ChordDiagram extends DataLayer{
  
  float radius;
     
  public ChordDiagram(float radius, String file,int layout){
    this.radius = radius;
    this.layout = layout;
    // Calls init() which is from the DataLayer calss, and basically runs as a constructor
    super.init(file,0,0,layout);
    // Set a layout
    this.setLayout(layout);
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
    println("Nodes edited:"+counter);
    
  }
  
  private void plotPointsOnGrid(float numberOfPoints){
  
    float padding = 10; // padding on the screen
    float xSize = width-padding-200; // FIXME: 200 is because the GUI's width is 200, there needs to be a better way to reference this
    float ySize = height-padding;
    
    xBounds = xSize; // Set the bounds
    
    float steps = 7; // Based on how many points we have, 
    int counter = 0; // draw a new point at each step
    for(  float yPos = padding; yPos < ySize-padding; yPos+=steps){
      for(float xPos = padding; xPos < xSize-padding; xPos+=steps){
        if(counter < nodeList.size()){
          nodeList.get(counter).x = xPos;
          nodeList.get(counter).y = yPos;
          yBounds = yPos+padding; // Set the bounds to the last yPos we find (which would be the maximum Y Value)
        }
        counter++;
      }
    }
  }
  
  private void plotPointsOnSphere(float numberOfPoints){   
    float steps = 360/numberOfPoints; // Based on how many points we have, 
                                      // draw a new point at each step
    float theta = 0; // angle to increase each loop

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

  public void setLayout(int layout){
    // Set our layout
    this.layout = layout;
    
    // Quick hack so the visualization can render quickly, also calculates the number of callees from the caller
    // This is called after we have positioned all of our nodes in the visualization
    storeLineDrawings();
    // Draw the mapping of the visualization (Different layouts may need different 
    // functions called.
    // This function cycles through all of the nodes and generates a numerical value that can be sorted by
    // for some attribute that we care about
    generateHeatForCalleeAttribute();
    
    sortNodesByCallee();
    
    // Modify all of the positions in our nodeList
    if(layout<=0){
      plotPointsOnCircle(nodeList.size()); // Plot points on the circle
    }else if(layout==1){
      plotPointsOnGrid(nodeList.size());
    }else if(layout>=2){
      plotPointsOnSphere(nodeList.size());
    }
       
    // Quick hack so the visualization can render quickly, also calculates the number of callees from the caller
    // This is called after we have positioned all of our nodes in the visualization
    storeLineDrawings();
  }

  
  @Override
  public void setPosition(float x, float y){
    centerx = x;
    centery = y;
  }
  
  public void draw(int mode){
     // Draw a background
      drawBounds(192,192,192);
      
      fill(0);
      
      if(this.layout==0){
        ellipse(centerx,centery,radius*2,radius*2);
      }
      
      // What is interesting about the drawing, is that it is all happening in the
      // ChordNode itself. This way we can have any arbritrary shape in ChordNode
      // drawn and handle all of the selection there. It also would allow us to have
      // different types of shaped nodes mixed in a visualization much more easily.
      for(int i =0; i < nodeList.size();i++){
        ChordNode temp = (ChordNode)nodeList.get(i);
        temp.render(mode);
      }
  }
  
}