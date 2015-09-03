import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import javax.swing.*; 
import java.util.Hashtable; 
import java.util.*; 
import java.io.*; 
import java.util.concurrent.*; 
import java.util.concurrent.*; 
import java.util.Hashtable; 
import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ChordPlot extends PApplet {


 

/*
  Create a second window
*/
DetailsPane dp;

/* Create our visualizations */
ChordDiagram cd;
//Histogram h;

HistogramWindow hw;
BucketsWindow bw;


int programStart = 0;

public void settings(){
  size(1240 ,800, P3D);
}

/*
    Processing program initialization
*/
public void setup(){  
  programStart = millis();
  surface.setTitle("Microarray Visualization");
  surface.setLocation(0, 0);
  
  
  ortho(-width/2.0f, width/2.0f, -height/2.0f, height/2.0f); // same as ortho()

  //String filename = "/home/mdshah/Desktop/LLVMSample/fullDot.dot";
  //String filename = "output.dot"; // legacy version of dot file loader
  String filename = "horde3d.dot";

  // Our base visualizations
  // It is best practice to intialize this first since we reference 'cd' across
  // the entire codebase.
  cd = new ChordDiagram(400, filename,1);
  
  //h = new Histogram(filename,20,height-30,0);

  // Create the second window with the details pane
  dp = new DetailsPane();
  dp.setDataString("File Loaded: "+filename);
  
  hw = new HistogramWindow(filename);
  bw = new BucketsWindow(filename);
  
  bw.m_buckets.debug();
  
  // Initialize our GUI after our data has been loaded
  initGUI();  
  
  println("setup time: " + (millis()-programStart));
}

/* =============================================
     Main draw function in the visualization
   ============================================= */
public void draw(){
  // Update the mouse Coordidinates with our camera
  MySimpleCamera.update(mouseX, mouseY);
  
  // Refresh the screen
  background(128);
   
   text("FPS :"+frameRate,width-100,height-20);
   text("Camera Position ("+MySimpleCamera.cameraX+","+MySimpleCamera.cameraY+","+MySimpleCamera.cameraZ+")",5,height-20);
   text("Enter - Push nodes | Space - Deselect/Unhighlihgt all | Arrowkeys for Camera | Left-Mouse select/deselect | Right-Mouse more Info | Hold 's' or 'e' to select/deselect node you hover over",5,height-30);
   
   pushMatrix();
     translate(MySimpleCamera.cameraX,MySimpleCamera.cameraY,MySimpleCamera.cameraZ);
     cd.draw(drawMode);
     //h.draw(0);
   popMatrix();
}
/*
    This class serves as the details window to display other information.
*/
class BucketsWindow extends commonWidget {
  
  // a self-contained 
  Buckets m_buckets;
  String filename;

  public BucketsWindow(String filename){
    this.filename = filename;
    println("a");
    m_buckets = new Buckets(filename,0,height-30,0);
    
    
  }
  
  public void settings() {
    size(600, 450, P3D);
    smooth();
  }
    
  public void setup() {
      println("setup Buckets");
      surface.setTitle(windowTitle);
      surface.setLocation(1440, 0);
  }
  
  int p_buckets_old = -1;
  int p_buckets = -1;
  Set<Integer> selectedBuckets = new HashSet<Integer>();

  
  public void draw() {
    
    float m_x = mouseX;
    float m_y = mouseY;   
    
    if(m_buckets!=null){
                     if(m_buckets.showData){
                      background(0,64,164); fill(0); stroke(0); text("FPS: "+frameRate,20,height-20);
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
                                  // Unhighlight all of the previous buckets that were highlighted.
                                  if(p_buckets != i){
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
                                  if(mousePressed==true ){
                                      // TODO: Do not make me a hard link
                                        if(mouseButton==LEFT){
                                          if(selectedBuckets.contains(i)){
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
                                  text("selected: "+i+" prev: "+p_buckets+" prev2: "+p_buckets_old,200,200);
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
    }

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
  
  // For now there is an assumption that these
  // are all positive values
  float maxValue  = 0;
  float minValue  = 0;
  float stepValue = 5;
  
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
    // nodeListStack.computeSummaryStatistics(); // FIXME: Put this back in the code 
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
    storeLineDrawings(1);
    // Draw the mapping of the visualization (Different layouts may need different 
    // functions called.
    // This function cycles through all of the nodes and generates a numerical value that can be sorted by
    // for some attribute that we care about
    this.generateHeatForCalleeAttribute(scaledHeight);
    
    sortNodesByCallee();
    
    // Modify all of the physical locations in our nodeList
    fastUpdate();
    
    // Quick hack so the visualization can render quickly, also calculates the number of callees from the caller
    // This is called after we have positioned all of our nodes in the visualization
    storeLineDrawings(0);
  }
    
  
  // Here maxHeight represents how many pixels we scale to (
  // (i.e. the maximum value in the set will equal this)
  public void generateHeatForCalleeAttribute(float maxHeight){
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
      This means setLayout should only be called once initially.
      
      Fast layout will layout the nodes. It is nice to have this abstracted away
      into its own function so we can quickly re-plot the nodes without doing additional
      computations.
  */
  public void fastUpdate(){
    // Modify all of the positions in our nodeList
    if(this.layout <= 0){
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
                  text("Bucket# "+i,xBucketPosition,yPosition+10);
                  
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
}


// Purpose of this class is to
// 
class ChordDiagram extends DataLayer{
  
  float radius;
  float nodeSteps = 4;
     
  public ChordDiagram(float radius, String file,int layout){
    this.visualizationName = "Chord Diagram";
    this.radius = radius;
    this.layout = layout;
    // Calls init() which is from the DataLayer class, and basically runs as a constructor
    super.init(file,0,0,layout);
    // Set a layout
    this.setLayout(layout);
    // Compute initial statistics
    // FIXME: Put this back in the code nodeListStack.computeSummaryStatistics();
  }
  
  /*
      
  */
  public void generateHeatForCalleeAttribute(){
    // Find the max and min from the ChordNode metadata
    float themin = 0;
    float themax = 0;
    for(int i =0; i < nodeListStack.peek().size();i++){
      themin = min(themin,nodeListStack.peek().get(i).metaData.callees);
      themax = max(themax,nodeListStack.peek().get(i).metaData.callees);
    }
    println("themin:"+themin);
    println("themax:"+themax);
    // Then map that value into the ChordNode so that it can render correctly.
    // We scale from 
    for(int i =0; i < nodeListStack.peek().size();i++){
      // Get our callees and map it agains the min and max of other callees so we know how to make it stand out
      nodeListStack.peek().get(i).metaData.c = map(nodeListStack.peek().get(i).metaData.callees, themin, themax, 0, 255);
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

      if(counter < nodeListStack.peek().size()){
        nodeListStack.peek().get(counter).x = xPos;
        nodeListStack.peek().get(counter).y = yPos;
      }
      counter++;
    }
    println("Nodes edited:"+counter);
    
  }
  
  /*
      Plot points in the microarary
  */
  private void plotPointsOnGrid(float numberOfPoints){
    println("Calling plotPointsOnGrid");  
    float padding = 20; // padding on the screen
    float pixelsAvailable = (width-padding-padding)*(height-padding-padding);
  
    float optimalSize = pixelsAvailable/ nodeListStack.peek().size();
    // Since we need a square, take the sqrt
    optimalSize = (int)(sqrt(optimalSize)); // Cast to an int to make things simple
    // Compute the proper aspect ratio so that the visualization is more square.     
    // Adjust the aspect ratio
    int pixelsNeeded = (int)(sqrt( optimalSize * nodeListStack.peek().size()));
    
    float xSize = pixelsNeeded * optimalSize; 
    
    // If our aspect ratio gets messed up, set it to the maximum
    if(xSize > width-padding){
      xSize = width-padding;
    }
    
    float ySize = height-padding;
    
    xBounds = xSize+padding; // Set the bounds
    
    // We can set a default steps(that is passed in the parameter)
    // But we can re-adjust it to fit the xBo
    
    println("======About to replot=========");
    int counter = 0; // draw a new point at each step
    for(  float yPos = padding; yPos < ySize; yPos+=optimalSize){
      for(float xPos = padding; xPos < xSize; xPos+=optimalSize){
        if(counter < nodeListStack.peek().size()){
          nodeListStack.peek().get(counter).x = xPos;
          nodeListStack.peek().get(counter).y = yPos+optimalSize;

          // Set the size of our visualization here
          nodeListStack.peek().get(counter).nodeSize = (int)(optimalSize/2); // Integer division
          nodeListStack.peek().get(counter).rectWidth = optimalSize;
          nodeListStack.peek().get(counter).rectHeight = optimalSize;
          
          yBounds = yPos+padding; // Set the bounds to the last yPos we find (which would be the maximum Y Value)
          counter++;
        }
      }
    }
  }
  
  /*
    Plot Points on a Sphere
  */
  private void plotPointsOnSphere(float numberOfPoints){   
    float steps = 360/numberOfPoints; // Based on how many points we have, 
                                      // draw a new point at each step
    float theta = 0; // angle to increase each loop

    int counter = 0;
    while(counter < nodeListStack.peek().size()){
      
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
      nodeListStack.peek().get(counter).x = xPos;
      nodeListStack.peek().get(counter).y = yPos;
      nodeListStack.peek().get(counter).z = zPos;
      
      theta = theta + steps;
      counter++;
    }
    
  }

  public void setLayout(int layout){
    // Set our layout
    this.layout = layout;

    println("Setting a new layout");
    // Calculates the number of callees from the caller
    storeLineDrawings(1);
    
    // Quick hack so the visualization can render quickly, also calculates the number of callees from the caller
    // This is called after we have positioned all of our nodes in the visualization
    // Draw the mapping of the visualization (Different layouts may need different 
    // functions called.
    // This function cycles through all of the nodes and generates a numerical value that can be sorted by
    // for some attribute that we care about
    generateHeatForCalleeAttribute();
    
    sortNodesByCallee();
    
    // Modify all of the physical locations in our nodeList
    fastUpdate();
       
    // Quick hack so the visualization can render quickly, also calculates the number of callees from the caller
    // This is called after we have positioned all of our nodes in the visualization
    storeLineDrawings(0);
  }

  /*
      Useful for being used in update where we don't need to do anything else with the data.
      This means setLayout should only be called once initially.
      
      Fast layout will layout the nodes. It is nice to have this abstracted away
      into its own function so we can quickly re-plot the nodes without doing additional
      computations.
  */
  public void fastUpdate(){
    println("Calling fastUpdate");
    // Modify all of the positions in our nodeList
    if(this.layout <=0 ){
      plotPointsOnCircle(nodeListStack.peek().size()); // Plot points on the circle
    }else if(this.layout == 1){
      plotPointsOnGrid(nodeListStack.peek().size());
    }else if(this.layout >= 2){
      plotPointsOnSphere(nodeListStack.peek().size());
    }
  }

  // After we filter our data, make an update
  // so that our visualization is reset based on the
  // active data.
  @Override
  public void update(){
     this.setLayout(this.layout);
  }

  @Override
  public void setPosition(float x, float y){
    centerx = x;
    centery = y;
  }
  
  public void draw(int mode){
    if(showData){
         // Draw a background
          pushMatrix();
            translate(0,0,MySimpleCamera.cameraZ-1);
            drawBounds(0,64,128, xPosition, yPosition);
          popMatrix();
          
          fill(0);
          
          if(this.layout==0){
            ellipse(centerx,centery,radius*2,radius*2);
          }
          
          // What is interesting about the drawing, is that it is all happening in the
          // ChordNode itself. This way we can have any arbritrary shape in ChordNode
          // drawn and handle all of the selection there. It also would allow us to have
          // different types of shaped nodes mixed in a visualization much more easily.
          for(int i =0; i < nodeListStack.peek().size();i++){
            ChordNode temp = (ChordNode)nodeListStack.peek().get(i);
            temp.render(mode);
          }
      }
  }
}

// Node class consits of a source
class ChordNode{
  float x;
  float y;
  float z;
  public nodeMetaData metaData;
  int nodeSize = 3; // needed if we are rendering 2D circles or spheres
    
  float rectWidth  = 0; // needed if we are rendering 2D rectangular shapes (Such as when we render histogram)
  float rectHeight = 0; // needed if we are rendering 2D rectangular shapes (Such as when we render histogram)

  int bucket = 0;      // If we are clustering the nodes together, figure out which bucket they should be put in.

  // Selecting nodes
  boolean selected = false; // By default, we show everything, so we render all nodes
  
  // Highlighted
  boolean highlighted = false; // By default, nodes are not highlighted. This is the same as selection, but does not show the call sites
  

  // This arrayList holds all of the locations that the node points to(all of its callees).
  ChordNodeList LocationPoints;
  
  /*
      The most default constructor that will be used
  */
  public ChordNode(String name, float x, float y, float z){
    this.metaData = new nodeMetaData(name);
    this.x = x;
    this.y = y;
    this.z = z;
    
    LocationPoints = new ChordNodeList();
  }
  
  /*
      Another constructor with more fields if we need them pre-populated.
  */
  public ChordNode(String name, float x, float y, float z, nodeMetaData nmd, ChordNodeList cnl){
    this.metaData = new nodeMetaData(name);
    this.x = x;
    this.y = y;
    this.z = z;
    
    this.metaData = nmd;
    if(cnl==null){
      LocationPoints = new ChordNodeList();
    }else{
      this.LocationPoints = cnl;
    }
  }
  
  public void getMetaData(nodeMetaData n){
    metaData.copyMetaData(metaData);
  }
  
  // for 2D
  public void addPoint(float x, float y, String name){
    LocationPoints.add(new ChordNode(name,x,y,0));
  }
  
    // for 2D
  public void addPoint(float x, float y, String name, nodeMetaData nmd, ChordNodeList cnl){
    LocationPoints.add(new ChordNode(name,x,y,0, nmd, cnl));
  }
  
  // For 3D
  public void addPoint(float x, float y, float z, String name){
    LocationPoints.add(new ChordNode(name,x,y,z));
  }
  
  /*
    A Mode of 0 (by default) if we render in 2D as ellipses
    A mode of 1 if we would like to render in 3D as spheres.
    A mode of 2 renders as lines
  */
  public void render(int mode){
    pushMatrix();
    translate(0,0,MySimpleCamera.cameraZ);

        // Determine how to render the nodes
        if(mode<=0){
          render2D(1);
        }else if(mode==1){
          sphereDetail(6);
          render3D();
        }
        else if(mode==2){
          render2DRects(rectWidth,rectHeight);
        }
    popMatrix();
  }
  
  // Render 2D Ellipses
  // Implements onHover and Selection for 2D Cirlces
  // renderShape (0) = ellipse
  // renderShape (1) = rect
  private void render2D(int renderShape){
    // Simply make a call into render2DRects if we choose to do 2D shapes
     if(renderShape == 1){
           render2DRects(rectWidth,rectHeight);
     }
     else{
          // Display information if we hover over our node
          if(dist(x,y,MySimpleCamera.xSelection,MySimpleCamera.ySelection) < nodeSize){
            onRightClick();
          }
        
        
          if( dist(x,y,MySimpleCamera.xSelection,MySimpleCamera.ySelection) < nodeSize || selected){
              fill(0);
              stroke(255);
              if(selected) { fill(0,255,0); }
              ellipse(x,y,nodeSize*2,nodeSize*2);
              
              fill(0,255,0);
              pushMatrix();
                translate(0,0,MySimpleCamera.cameraZ+1);  // Translate forward
                drawToCallees(CalleeDepth);
              popMatrix();
              fill(0);
              text(metaData.name,x,y);
              text("Here's the meta-data for "+metaData.name+": "+metaData.extra_information,0,height-20);
              
              if(mousePressed && dist(x,y,MySimpleCamera.xSelection,MySimpleCamera.ySelection) < nodeSize && mouseButton == LEFT){
                selected = !selected;
              }
          }
          else{
              // Color nodes based on callees
              fill(255-metaData.c);
              stroke(255-metaData.c);
              ellipse(x,y,nodeSize*2,nodeSize*2);
          }
     }
  }
  
  // Imlements selection and onHover for 3D spheres
  private void render3D(){
     if( dist(x,y,0,MySimpleCamera.xSelection,MySimpleCamera.ySelection,0) < nodeSize || selected){
        fill(0);
        if(selected){fill(0,255,0);}
        
        pushMatrix();
        translate(x,y,z);
          sphere(nodeSize);
        popMatrix();
        
        fill(0,255,0);
        
        drawTo3DCallees(CalleeDepth);
        fill(0);
        text(metaData.name,x,y);
        text("Here's the meta-data for "+metaData.name+": "+metaData.extra_information,0,height-20);
        
        if(mousePressed && dist(x,y,z,MySimpleCamera.xSelection,MySimpleCamera.ySelection,0) < nodeSize && mouseButton == LEFT){
          selected = !selected;
        }
     }
     else{
        // Color nodes based on callees
        fill(255-metaData.c);
        pushMatrix();
        translate(x,y,z);
          sphere(nodeSize);
        popMatrix();
     }
  }
  
  /*
  
  */
  public void onRightClick(){
     if(mouseButton == RIGHT){
       float _w = 500;
       float _h = 200;
       float padding = 5;
       
       pushMatrix();
         translate(0,0,MySimpleCamera.cameraZ+20);
         fill(192,192);
         rect(x,y,_w,_h);
         fill(0,255);
         text("MetaData: "+metaData.getAllMetadata()+" \n Lorem ipsum dolor sit amet, phasellus pede tempus magna elit sed integer, aliquam ut mollit turpis, magna at a, non dui",x+padding,y+padding,_w-padding,_h-padding);
       popMatrix();
       
     }
     
     // Pass a data string to our child applet and store it here.
      dp.setDataString("Data:"+metaData.getAllMetadata());
  }
  
  
  // Implements onHover and Selection for 2D Rectangles
  private void render2DRects(float rectWidth, float rectHeight){
        // Display information if we hover over our node
        if((mouseX > x && MySimpleCamera.xSelection < (x+rectWidth) && MySimpleCamera.ySelection < y && MySimpleCamera.ySelection > (y-rectHeight))){
            // Display more information
            onRightClick();
            // Popup some useful text if we have not yet right-clicked  
            if(mousePressed==false){
               pushMatrix();
                 translate(0,0,MySimpleCamera.cameraZ+20);
                 fill(192,192);
                 if (selected) {fill(0,255,0);}  // Provide feedback if we're hovering over a selected node.
                 rect(x,y,metaData.name.length()*8,20);
                 fill(0,255);
                 text(metaData.name,x,y+10);
               popMatrix();
            }
            
            if(keyPressed){
                if      (key == 's'){
                  cd.select(this,true);
                }else if(key == 'e'){
                  cd.select(this,false);
                }
            }
        }
    
        // If our node is selected, then highlight it a new color
        if( selected || (mouseX > x && MySimpleCamera.xSelection < (x+rectWidth) && MySimpleCamera.ySelection < y && MySimpleCamera.ySelection > (y-rectHeight))){ 
            fill(0);
            stroke(255);
            if(selected){ stroke(255,0,0); fill(0,255,0); }
            
            rect(x,y-rectHeight,rectWidth,rectHeight);
            pushMatrix();
              translate(0,0,MySimpleCamera.cameraZ+1);  // Translate forward
              drawToCallees(CalleeDepth);
            popMatrix();
                        
            if(mousePressed &&  (MySimpleCamera.xSelection > x && MySimpleCamera.xSelection < (x+rectWidth) && MySimpleCamera.ySelection < y && MySimpleCamera.ySelection > (y-rectHeight)) && mouseButton == LEFT){
              selected = !selected;
            }
                       
         }
         else if(highlighted){
           if(highlighted) { fill(255,255,0); }  
           rect(x,y-rectHeight,rectWidth,rectHeight);
         }
         else{
            // If we aren't selected or highlighted then
            // Default to coloing nodes based on color in the metaData
            fill(255-metaData.c);
            stroke(255-metaData.c);
            rect(x,y-rectHeight,rectWidth,rectHeight);
         }
         
  }
  
  

  
  // Draw to all of the callee locations in 2D
  // Note that we are drawing exclusively to the secondGraphicsLayer here.
  // The depth is how many levels in the tree to draw to callees (essentially do a BFS).
  public void drawToCallees(int depth){

      fill(0); stroke(0);
      for(int i =0; i < LocationPoints.size();i++){
        line(x,y,LocationPoints.get(i).x,LocationPoints.get(i).y);
        noFill(); stroke(0);
        rect(LocationPoints.get(i).x,LocationPoints.get(i).y-rectHeight,rectWidth,rectHeight);
        ChordNode blah = LocationPoints.get(i);
        if(depth>0){
          blah.drawToCallees(depth-1);     
        }
      }
  }
  
  // Draw to all of the callee locations in 3D
  public void drawTo3DCallees(int depth){
    fill(255,0,0);
    for(int i =0; i < LocationPoints.size();i++){
      line(x,y,z,LocationPoints.get(i).x,LocationPoints.get(i).y,LocationPoints.get(i).z);
    }
  }
  
  /*
      Return information about a ChordNode
  */
  public String debug(){
    return "(x,y,z)=> (" + x + "," + y + "," + z + ")" + " name; "+metaData.name + "callees: "+metaData.callees;
  }
  
    
}
/*
  The purpose of this class is to contain a list of chords.
  
  There are also other conveience functions attached.
*/
class ChordNodeList{
  
  // Backbone data structure for working with a list of Chord Nodes
  // Note that in order to avoid ConcurrentModifcationException, we make a CopyOnWriteArrayList.
  // This use to be a regular ArrayList, but since we are passing lists around so often, we had to be
  // extra safe and make sure it is thread-safe.
  ArrayList<ChordNode> chordList;
  
  // The name of the ChordNode List if we want to identify how to work with it.
  public String name = "Dataset";
  
  public ChordNodeList(){
     chordList = new ArrayList<ChordNode>(); 
  }
  
  public ChordNodeList(String name){
     chordList = new ArrayList<ChordNode>();
     this.name = name;    
  }
  
  /*
      Retrieve an element at the index of the chordList
  */
  public ChordNode get(int index){
    return chordList.get(index);
  }
  
  /*
      Add an element at the end of the chordList
  */
  public void add(ChordNode element){
    chordList.add(element);
  }
  
  /*
      Clear all of the elements
  */
  public void clear(){
    chordList.clear();
  }
  
  /*
      Return the size of our ChordNode List
  */
  public int size(){
    return chordList.size();
  }
  
  /*
      Simple sorting function which takes advantage of the ArrayList
      
      We sort by the callees here. We can duplicate this pattern
      to sort by an arbritrary feature.
  */
  public void sortNodes(){
    Collections.sort(chordList, new Comparator<ChordNode>(){
      @Override
      public int compare(ChordNode item1, ChordNode item2){
          Integer val1 = item1.metaData.callees;
          Integer val2 = item2.metaData.callees;
          
          // Descending order (reverse comare to do ascending order)
          return val2.compareTo(val1);
          //return item1.metaData.name.compareTo(item2.metaData.name); // uncomment this to sort based on 'string' value
      }
    });
  }
  
}
/*

  Any interaction with the user interface through keyboard is currently here

*/


int drawMode = 0;

/* =============================================
  Camera Controls with Arrowkeys, Ctrl, and Shift
   ============================================= */
int keyIndex = 0;
// Determine how deep in the tree we go.
public void keyPressed() {
  
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
  

  
  // Need to check for Enter and Return so application is cross
  // platform: https://processing.org/reference/keyCode.html
  if(keyCode == ENTER || keyCode == RETURN){
      
      String FilterString = cd.nodeListStack.peek().name;
      
      // Apply the relevant filters
      cd.pushSelectedNodes();
      cd.update(); // Make a call to update the visualization
      
      hw.m_histogram.pushSelectedNodes();
      hw.m_histogram.update(); // Make a call to update the visualization
      hw.updateFunctionList();
      
      bw.m_buckets.pushSelectedNodes();
      bw.m_buckets.update();
      bw.updateFunctionList();
      
      // Add our item to the list
      breadCrumbsBar.addItem(FilterString,cd.nodeListStack.size()-1);
  }
  
  // De-select nodes if space is pressed.
  if(key== ' '){
      // Apply the relevant filters
      cd.deselectAllNodes();
      hw.m_histogram.deselectAllNodes();
      bw.m_buckets.deselectAllNodes();
  }
  
}
/*
    This is a class that other classes can extend from to get data from
    The goal of this class is to store all common information from a visualization.
    
    This class should not be instantiated (It should just be considered abstract with some functionality implemented)
*/
public class DataLayer implements VisualizationLayout{
   
  
  // The name of the visualization
  public String visualizationName = "Data Layer";

  // Where to draw the visualization
  public float xPosition;
  public float yPosition;
  // The layout of the nodes within the visualization
  public int layout;
  
  public float centerx = width/2.0f;
  public float centery = height/2.0f;
  
  public float defaultWidth = 4; // The default width of the bars in the histogram
  // Bounds
  // Stores how big the visualization is. Useful if we need to select items
  // or draw a background panel
  public float xBounds = 0;
  public float yBounds = 0;
  public float zBounds = 0;
    
  // Toggle for showing the Visualization
  boolean showData = true;
  // Store our dotGraph
  public DotGraph dotGraph;
  public ChordNodeList nodeList;  // All of the nodes, that will be loaded from the dotGraph
  // Create a stack of the nodes
  public NodeListStack nodeListStack; 
  
  /*
      Function that constructs this object.
      This class should only be extended on, and serves as a base class for other visualizations.
  */
  public void init(String file, float xPosition, float yPosition, int layout){ //DataLayer(String file, float xPosition, float yPosition){
     this.xPosition = xPosition;
     this.yPosition = yPosition;

    // Load up data
    // Note that the dotGraph contains the entire node list, and all of the associated meta-data with it.
    dotGraph = new DotGraph(file);     println("bbblah"); 
    // Create a list of all of our nodes that will be in the visualization
    // We eventually push a copy of this to the stack
    nodeList = new ChordNodeList("Initial Data");
println("blah");
    println("a blah");
    // Plot the points in some default configuration
    this.regenerateLayout(layout);
    nodeListStack = new NodeListStack();
    
    // Push the nodeList onto the stack
    nodeListStack.push(nodeList);
    println("after push nodeListStack.size(): "+nodeListStack.size());
    // FIXME: Put this back in the code nodeListStack.computeSummaryStatistics();
    
  }
  
  public void sortNodesByCallee(){
    this.nodeListStack.peek().sortNodes();
  }
  
  /*
      This function is responsible for being called at initialization
      This populates nodeList which we can then use
      
      // What it does is
  */
  public void regenerateLayout(int layout){
    // Empty our list if it has not previously been emptied
    nodeList.clear();
    this.layout = layout;
    
    // Populate the node list
    // Get access to all of our nodes
    Iterator nodeListIter = dotGraph.fullNodeList.entrySet().iterator();
    while(nodeListIter.hasNext()){
      Map.Entry pair = (Map.Entry)nodeListIter.next();
      nodeMetaData m = (nodeMetaData)pair.getValue(); 
      ChordNode temp = new ChordNode(m.name,xPosition,yPosition,0);
      // Do a deep copy
      // This is annoying, but will work for now
      temp.metaData.callees           = m.callees;
      temp.metaData.attributes        = m.attributes;
      temp.metaData.annotations       = m.annotations;
      temp.metaData.metaData          = m.metaData;
      temp.metaData.OpCodes           = m.OpCodes;
      temp.metaData.PGOData           = m.PGOData;
      temp.metaData.PerfData          = m.PerfData;
      temp.metaData.ControlFlowData   = m.ControlFlowData;
      temp.metaData.extra_information = m.extra_information;
    
      nodeList.add(temp);
      nodeListIter.remove(); // Avoid ConcurrentModficiationException
    }
  }
  
  /*
      Sets the position of our visualization
  */
  public void setPosition(float x, float y){
     this.xPosition = x;
     this.yPosition = y;
     // A bit ugly, but we have to regenerate the layout
     // everytime we move the visualization for now
     regenerateLayout(layout);
  }
  
  // Here maxHeight represents how many pixels we scale to (
  // (i.e. the maximum value in the set will equal this)
  public void generateHeatForCalleeAttribute(float maxHeight){
    // Find the max and min from the ChordNode metadata
    float themin = 0;
    float themax = 0;
    for(int i = 0; i < nodeListStack.peek().size();i++){
      themin = min(themin,nodeListStack.peek().get(i).metaData.callees);
      themax = max(themax,nodeListStack.peek().get(i).metaData.callees);
    }
    println("themin:"+themin);
    println("themax:"+themax);
    // Then map that value into the ChordNode so that it can render correctly.
    // We scale from 
    for(int i = 0; i < nodeListStack.peek().size();i++){
      // Get our callees and map it agains the min and max of other callees so we know how to make it stand out
      nodeListStack.peek().get(i).metaData.callees = (int)map(nodeListStack.peek().get(i).metaData.callees, themin, themax, 0, maxHeight);
      
      // Our shapes are rectangular, so we need to set this in the ChordNode
      nodeListStack.peek().get(i).rectWidth = defaultWidth;
      nodeListStack.peek().get(i).rectHeight = nodeListStack.peek().get(i).metaData.callees;
    }
  }
  
  
  // The goal of this function is to look through every node
  // in the DotGraph that is a source.
  // For each of the nodes that are a destination in the source
  // figure out which position they have been assigned in 'plotPointsOnCircle'
  // Then we need to store each of these in that ChordNode's list of lines to draw
  // so that when we render we can do it quickly.
  //
  // If compute == 1 then compute callees, otherwise do not becaue they have already been done.
  //
  public void storeLineDrawings(int compute){
   println("I think we might crash around here");
      Map<String,ChordNode> topOfStackMap = nodeListStack.getTopStackMap();
   
      

                // Faster hacked version
                println("size: "+nodeListStack.size());
                for(int i =0; i < nodeListStack.peek().size(); i++){
                  // Search to see if our node has outcoming edges
                  nodeMetaData nodeName = nodeListStack.peek().get(i).metaData;        // This is the node we are interested in finding sources
                  nodeListStack.peek().get(i).LocationPoints.clear();                  // Clear our old Locations because we'll be setting up new ones
                  if (dotGraph.graph.containsKey(nodeName)){                           // If we find out that it exists as a key(i.e. it is not a leaf node), then it has targets
                    // If we do find that our node is a source(with targets)
                    // then search to get all of the destination names and their positions
                    LinkedHashSet<nodeMetaData> dests = (dotGraph.graph.get(nodeName));
                    Iterator<nodeMetaData> it = dests.iterator();
                    // Iterate through all of the callees in our current node
                    // We already know what they are, but now we need to map
                    // WHERE they are in the visualization screen space.
                    while(it.hasNext()){
                        nodeMetaData temp = it.next();
                        // When we find the key, add the values points
                        if(topOfStackMap.containsKey(temp.name)){
                            ChordNode value = topOfStackMap.get(temp.name);
                            nodeListStack.peek().get(i).addPoint(value.x,value.y,value.metaData.name, topOfStackMap.get(temp.name).metaData ,topOfStackMap.get(temp.name).LocationPoints );          // Add to our source node the locations that we can point to
                            // Store some additional information (i.e. update our callees count.
                            // TODO: This number is only of the visible callees, perhaps we want a maximum value?
                            if(1==compute){
                              nodeListStack.peek().get(i).metaData.callees++;
                            }
                            
                            //topOfStackMap.remove(temp); // Try to avoid ConcurrentModificationException Since top of stack is a temporary thing, this should be okay to do.
                        }
                        
                    }
                  }
                }
      
  }
  
  
  /*
      Pushes all of the selected nodes onto a stack
      This is the most generic way to push nodes onto a stack.
  
      Ideally this is tied to some keypress(Enter key)
  */
  synchronized public void pushSelectedNodes(){
      String name = "Selected Nodes";
    
      ChordNodeList selectedNodes = new ChordNodeList(name);
      for(int i =0; i < nodeListStack.peek().size();i++){
        if(nodeListStack.peek().get(i).selected){
          selectedNodes.add(nodeListStack.peek().get(i));
        }
      }
      
      nodeListStack.push(selectedNodes);
  }
  
  /*
      Unselects all nodes.
      
      This is a convenience function
  
      Ideally this is tied to some keypress(Space key)
  */
  synchronized public void deselectAllNodes(){
      for(int i =0; i < nodeListStack.peek().size();i++){
        nodeListStack.peek().get(i).selected = false;
        nodeListStack.peek().get(i).highlighted = false;
      }
  }
    
  
    /*
      Filter Design pattern
      
      1.) Create a new ArrayList<ChordNode>
      2.) Loop through all nodes that are on the top of the stack
      3.) If they do not meet the criteria, then do not add them to the list.
      4.) Push the arrayList we have built on top of the stack
  */
  synchronized public void filterCallSites(int min, int max){
      String name = "Callsites "+callSiteMin+"-"+callSiteMax;
    
      ChordNodeList filteredNodes = new ChordNodeList(name);
      for(int i =0; i < nodeListStack.peek().size();i++){
        if(nodeListStack.peek().get(i).metaData.callees >= min && nodeListStack.peek().get(i).metaData.callees <= max){
          filteredNodes.add(nodeListStack.peek().get(i));
        }
      }
      nodeListStack.push(filteredNodes);
  }
  
  /*
      Functions that match the starting characters
      
      This will also return matches that 'contain' or are equal to the string
  */
  
    synchronized public void functionStartsWith(String text){
      String name = "Starts With: "+text;
      // The name we give to our list, so we can pop it off the stack by name if we need to.
      ChordNodeList filteredNodes = new ChordNodeList(name);
      
      for(int i =0; i < nodeListStack.peek().size();i++){
        // Small hack we have to do for now, because all of our functions are
        // surrounded by quotes to work properly in the .dot format (because if we use
        // periods in the .dot format for function names, things break, thus we surround them
        // in quotes). Thus, the hack is we append a double quote to all searches.
        if(nodeListStack.peek().get(i).metaData.name.startsWith("\""+text) || nodeListStack.peek().get(i).metaData.name.contains(text)){
          filteredNodes.add(nodeListStack.peek().get(i));
          println("adding: "+nodeListStack.peek().get(i).metaData.name);
        }
      }
      nodeListStack.push(filteredNodes);
  }
  
  /*
      GUI Controls for this component to filter.
  */
  public void GUIControls(){
    
  }
  
  
  /* *******************************
          Data Link Routines
     ******************************* */  
/*  The purpose of these commands are to share data between visualizations.
    Early on I decided that I wanted each visualization to be able to be explored
    independently of the others, and leave the microarray as the key diagram.
    
    However, it has become useful to use visualizations such as 'Buckets' to
    quickly filter the microarray for particular criteria.
*/

  // This command takes in a ChordNodeList from one visualization
  // and then highlights the other visualizations nodes on the top of its stack.
  //
  // We can also unhighlight nodes by passing in a value of 'false'
  //
  synchronized public void highlightNodes(ChordNodeList cnl, boolean value){
      // It's possible that cnl or the top of the nodeListStack has been filtered
      // so we need to make sure we check every node against each other.
      // Unfortunately, since we have lists as data structures, this mean O(N^2) time.
      // TODO: Possibly convert everything to map's so we can reduced this to O(N) time.
      // WORKAROUND: Once we find the index of the first item, since they are sorted,
      // we should be able to just linearly scan from that starting point instead of always
      // starting from the beginning. Note this could lead to a bug if the nodes are unsorted
      // or in some random order.
      
      
      //Map<String,ChordNode> topOfStackMap = nodeListStack.getTopStackMap();

      int firstIndex = 0;
      for(int i =0; i < cnl.size(); ++i){
          for(int j = firstIndex; j < nodeListStack.peek().size(); ++j){
            if(cnl.get(i).metaData.name.equals(nodeListStack.peek().get(j).metaData.name)){
              nodeListStack.peek().get(j).highlighted = value;
              firstIndex = j;
              break;
            }
          }
      }
  }
  
  /* 
      Highlight exactly one node
      
      This function is useful if you're working on a very fine grained
      level, such as a long bargraph with many functions.
  */
  synchronized public void highlightNode(ChordNode cn, boolean value){
    for(int j = 0; j < nodeListStack.peek().size(); ++j){
        if(cn.metaData.name.equals(nodeListStack.peek().get(j).metaData.name)){
          nodeListStack.peek().get(j).highlighted = value; // Modify the node we have found. 
          break;
        }
      }
  }
  
  /*
    public void highlightNodes(ChordNodeList cnl, boolean value){
      // It's possible that cnl or the top of the nodeListStack has been filtered
      // so we need to make sure we check every node against each other.
      // Unfortunately, since we have lists as data structures, this mean O(N^2) time.
      // TODO: Possibly convert everything to map's so we can reduced this to O(N) time.

      // Put everything into a hashmap from the cnl list (items we're trying to highlight,
      // and then modify the nodes in another loop
      ConcurrentHashMap<String, ChordNode> quickConvert = new ConcurrentHashMap<String, ChordNode>();
      for(int i =0; i < nodeListStack.peek().size(); ++i){
        quickConvert.put(nodeListStack.peek().get(i).metaData.name,nodeListStack.peek().get(i));
      }
      
      
      for(int i = 0; i < cnl.size(); ++i){
        quickConvert.get(cnl.get(i).metaData.name).selected = value;
        
        if((nodeListStack.peek().get(j).metaData.name)){
          nodeListStack.peek().get(j).highlighted = value;
          break;
        }
      }

  }
  
  */
  
    // This command takes in a ChordNodeList from one visualization
    // and then toggles the other visualizations nodes being active.
    synchronized public void toggleActiveNodes(ChordNodeList cnl){
      // It's possible that cnl or the top of the nodeListStack has been filtered
      // so we need to make sure we check every node against each other.
      // Unfortunately, since we have lists as data structures, this mean O(N^2) time.
      // TODO: Possibly convert everything to map's so we can reduced this to O(N) time.
      for(int i =0; i < cnl.size(); ++i){
        
          for(int j = 0; j < nodeListStack.peek().size(); ++j){
            if(cnl.get(i).metaData.name.equals(nodeListStack.peek().get(j).metaData.name)){
              nodeListStack.peek().get(j).selected = !nodeListStack.peek().get(j).selected; // Modify the node we have found. 
              break;
            }
          }
      }
  }
  
  
  /* 
      Select exactly one node

      This function is useful if you're working on a very fine grained
      level, such as a long bargraph with many functions.
  */
  synchronized public void toggleActiveNode(ChordNode cn){
    for(int j = 0; j < nodeListStack.peek().size(); ++j){
        if(cn.metaData.name.equals(nodeListStack.peek().get(j).metaData.name)){
          nodeListStack.peek().get(j).selected = !nodeListStack.peek().get(j).selected; // Modify the node we have found. 
          break;
        }
     }
  }
  
  
  /*
      Toggle all of the callees as well as the node we are selecting
      
      Based on the node we are selecting
  */
  synchronized public void toggleCallees(ChordNode cn){
    println("About to toggle callees:"+cn.LocationPoints.size()); 
    
    for(int j = 0; j < nodeListStack.peek().size(); ++j){
        if(cn.metaData.name.equals(nodeListStack.peek().get(j).metaData.name)){
          nodeListStack.peek().get(j).selected = true;//!nodeListStack.peek().get(j).selected; // Modify the node we have found. 
          for(int i = 0; i < nodeListStack.peek().get(j).LocationPoints.size(); ++i){
            nodeListStack.peek().get(j).LocationPoints.get(i).selected = true;// nodeListStack.peek().get(j).selected;
          }
          break;
        }
     }
  }
  
  /*
      Quickly select nodes by holding down a key
  */
  
  synchronized public void select(ChordNode cn, boolean value){
    println("select: "+value);
    for(int j = 0; j < nodeListStack.peek().size(); ++j){
        if(cn.metaData.name.equals(nodeListStack.peek().get(j).metaData.name)){
          nodeListStack.peek().get(j).selected = value; // Modify the node we have found. 
          println("setting: " + nodeListStack.peek().get(j).metaData.name + " to " +value);
          break; 
        }
     }
  }
  
  
  // Generally this method should be overridden.
  // It is called whenver we need to update what data is active
  // on the visualization. Generally after filtering we would want
  // to call this.
  public void update(){
  }
  
  /* *******************************
          Drawing Routines
     ******************************* */  
  
  // Draw a rectangle around our visualization
  // Useful for knowing where we can draw and position our visualization
  public void drawBounds(float r, float g, float b, float xPosition, float yPosition){
    fill(r,g,b);
    stroke(r,g,b);
    rect(xPosition+1,yPosition+1,xBounds,yBounds);
  }
  
  
  // Draw our actual visualization
  public void draw(int mode){
    // Do nothing, this method needs to be overridden
    rect(xPosition,yPosition,5,5);
    text("Visualization not rendering",xPosition,yPosition);
  }
  


  
}

/*
    This class serves as the details window to display other information.
*/
class DetailsPane extends PApplet {
  
  
  
  /* Purpose:
  
     A special mutable version of a java string.
     It exists within DetailsPane in order to transfer text around.
   
  */
  
  class DataString{
    String text;
    
    DataString(){
      text = new String("empty");
    }
    
    public void setText(String s){
      text = new String(s);
    }
    
    public String getString(){
      if(text!=null){
        return text;
      }else{
        return "";
      }
    }
    
  }
  

  
  // Used to pass and send data
  DataString dataString;
  
  // Our control panel
  ControlP5 detailsPanel;
  
  // re-route output from text to this details pane.
  Textarea myConsoleTextarea;
  Println console;
  
  /*
      Build the GUI for the Details Pane
  */
  public void initGUI(){
      detailsPanel = new ControlP5(this);
              // create a new button for something
              detailsPanel.addButton("More (todo)")
                   //.setValue(0) // Note that setting the value forces a call to this function (which sort of makes sense, as it will call your function at least once to set things up to align with the GUI).
                   .setPosition(width-180,0)
                   .setSize(180,19)
                   ;
              // create a new button for something
              detailsPanel.addButton("Highlight Similiar Nodes (todo)")
                   //.setValue(0) // Note that setting the value forces a call to this function (which sort of makes sense, as it will call your function at least once to set things up to align with the GUI).
                   .setPosition(width-180,20)
                   .setSize(180,19)
                   ;
                   
              // create a new button for outputting Dot files
              detailsPanel.addButton("OutputDOT")
                   //.setValue(0) // Note that setting the value forces a call to this function (which sort of makes sense, as it will call your function at least once to set things up to align with the GUI).
                   .setPosition(width-180,40)
                   .setSize(180,19)
                   ;
                   
              // create a new button for outputting Dot files
              detailsPanel.addButton("OutputSelectedDOT")
                   //.setValue(0) // Note that setting the value forces a call to this function (which sort of makes sense, as it will call your function at least once to set things up to align with the GUI).
                   .setPosition(width-180,60)
                   .setSize(180,19)
                   ;

              detailsPanel.addTextfield("StartsWith")
                 .setPosition(width-180,80)
                 .setSize(180,19)
                 .setFocus(true)
                 .setColor(color(255,0,0))
                 ;  
                 
             detailsPanel.addBang("FindFunction")
                 .setPosition(width-180,100)
                 .setSize(180,19)
                 .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                 ;    
                 
             detailsPanel.addRange("CallSites")
                 // disable broadcasting since setRange and setRangeValues will trigger an event
                 .setBroadcast(false) 
                 .setPosition(width-180,120)
                 .setSize(140,heightOfGUIElements)
                 .setHandleSize(10)
                 .setRange(0,maxNumberOfCallsites)
                 .setRangeValues(callSiteMin,callSiteMax)
                 // after the initialization we turn broadcast back on again
                 .setBroadcast(true)
                 .setColorForeground(color(255,40))
                 .setColorBackground(color(255,40))
                 ;
                 
              // create a new button for outputting Dot files
              detailsPanel.addButton("ApplyOurFilters")
                 .setPosition(width-180,140)
                 .setSize(180,19)
                 ;
  
                  
/*                   
              // Capture Console output here.
              myConsoleTextarea = detailsPanel.addTextarea("txt")
                  .setPosition(400, 0)
                  .setSize(300, height)
                  .setFont(createFont("", 10))
                  .setLineHeight(14)
                  .setColor(color(200))
                  .setColorBackground(color(0, 100))
                  .setColorForeground(color(255, 100));
              ;

              console = detailsPanel.addConsole(myConsoleTextarea);//
*/              
  }
  
  
  
  public DetailsPane() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    // Initialize a string of data that we can use to pass
    // between our different windows.
    dataString = new DataString();
    dataString.setText("Data");
    
    // Setup the GUI
    initGUI();
  }

  public void settings() {
    size(1440, 200, P3D);
    smooth();
  }
  public void setup() { 
    surface.setTitle("Details View");
    surface.setLocation(0, 800);
  }

  public void draw() {
    background(145,160,176);
    
    int xSize = width-180;
    int ySize = height;
    
    fill(0); stroke(0,255);

    text(dataString.getString(), 0,0, xSize, ySize);
  }
  
  // 
  public void setDataString(String s){
    dataString.setText(s);
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
  

  
  /*
      Search for functions that match the string
  */
 
  public void FindFunction() {
    String theText = detailsPanel.get(Textfield.class,"StartsWith").getText(); 
    if(theText.length() > 0){
      
        String FilterString = cd.nodeListStack.peek().name;
        // Apply the relevant filters
        cd.functionStartsWith(theText);
        cd.update(); // Make a call to update the visualization
        
        hw.m_histogram.functionStartsWith(theText);
        hw.m_histogram.update(); // Make a call to update the visualization
        hw.updateFunctionList();
        
        bw.m_buckets.functionStartsWith(theText);
        bw.m_buckets.update();
        bw.updateFunctionList();
        
        // Add our item to the list
        breadCrumbsBar.addItem(FilterString,cd.nodeListStack.size()-1);
        // Update the functions list with anything we have found.

    }
  }
  
  
    // function controlEvent will be invoked with every value change 
    // in any registered controller
    public void controlEvent(ControlEvent theEvent) {
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
        callSiteMin = PApplet.parseInt(theEvent.getController().getArrayValue(0));
        callSiteMax = PApplet.parseInt(theEvent.getController().getArrayValue(1));
        //println("range update, done. ("+callSiteMin+","+callSiteMax+")");
      }
      
    }
    
    /*
      Apply a Filter based on the options we have selected.
    */
    public void ApplyOurFilters(int theValue){
      String FilterString = cd.nodeListStack.peek().name;
      // Apply the relevant filters
      cd.filterCallSites(callSiteMin, callSiteMax);
      cd.update(); // Make a call to update the visualization
      
      hw.m_histogram.filterCallSites(callSiteMin, callSiteMax);
      hw.m_histogram.update(); // Make a call to update the visualization
      hw.updateFunctionList();
      
      bw.m_buckets.filterCallSites(callSiteMin, callSiteMax);
      bw.m_buckets.update();
      bw.updateFunctionList();
      
      // Add our item to the list
      breadCrumbsBar.addItem(FilterString,cd.nodeListStack.size()-1);
      
    }
    
}
/*
  Class for loading DotGraphs

*/






/*
  This class loads a DOT Graph file and populates a node list
*/
class DotGraph{
  
  // Contains a hashmap that consits of: 
  // key -- The source node, which is a String
  // value -- The Destination nodes this source points to, which is an arraylist.
  public ConcurrentHashMap<nodeMetaData,LinkedHashSet<nodeMetaData>> graph = new ConcurrentHashMap<nodeMetaData,LinkedHashSet<nodeMetaData>>();
  // Contains a list of all of the nodes (sources and destinations)
  // Can be useful if we need to populate all nodes in a visualization
  //
  // Note, I had to make this Concurrent so things do not crash :)
  public ConcurrentHashMap<String,nodeMetaData> fullNodeList = new ConcurrentHashMap<String,nodeMetaData>();
  int totalSources = 0;
  
  /* 
    Dot Graph Parser
  */
  public DotGraph(String file){
    //simpleDot(file);
    println("DotGraph Constructor");
    readStructDOT(file);
  }
  
  
  /*
  // Simple Parser
  public void simpleDot(String file){
      String[] lines = loadStrings(file);   
      
      for(int i =0; i < lines.length; i++){
        if (lines[i].contains("->")){
          // This is a lazy way of splitting a dot graph
          // assuming there are spaces and an arrow, and no extra data
          String[] tokens = lines[i].split(" ");
          
          // Add nodes with associated meta-data
          nodeMetaData src = new nodeMetaData(tokens[0],tokens[3]);
          nodeMetaData dst = new nodeMetaData(tokens[2],tokens[3]);
          // Lazily attempt to add everything to our set
          // DataStructure is a Set, thus guaranteeing only one unique copy
          fullNodeList.add(src);
          fullNodeList.add(dst);
          
          // If the function exists, then add a new destination
          if(graph.containsKey(src)){
            LinkedHashSet<nodeMetaData> temp = (LinkedHashSet<nodeMetaData>)(graph.get(src));
            temp.add(dst);
            graph.put(src,temp);
          }else{
            // Create a new node
            LinkedHashSet<nodeMetaData> incidentEdges = new LinkedHashSet<nodeMetaData>();
            incidentEdges.add(dst);
            graph.put(src,incidentEdges);
            totalSources++;
          }
                  
        }
      }
  }
  */
  
  /*
      Build a ChordNode from the node
  */
  public nodeMetaData processStruct(String line){
    //"_ZL10crc32_byteh"[shape=record,label="_ZL10crc32_byteh|{Attributes|zeroext}|{Metadata}|{Annotations}|{PGO Data}|{Perf Data}|{Opcodes|alloca 1|and 2|call 1|getelementptr 1|load 4|lshr 1|ret 1|store 2|xor 2|zext 2}|"];
    // Replace the delimiters with spaces and then we can easily split the line
    // Once the line is split, we can populate the metaData
    line = line.replace("|"," ");
    line = line.replace("{"," ");
    line = line.replace("}"," ");
    line = line.trim(); //Get rid of tabs
    
    // Find out what our function name is
    int funNameStart = line.indexOf("\"", 1);
    // 
    String functionName = line.substring(0, funNameStart+1);
    
    int labelStart = line.indexOf("label=");
    String restOfLine = line.substring(labelStart,line.length());
    String attributes = "";
    String annotations = "";
    String metaData = "";
    String OpCodes = "";
    String PGOData = "";
    String PerfData = ""; 
    String ControlFlowData = "";
    
    // Parse the data
    // Unfortunately this is going to work as a state machine
    // Perhpas JSON is a better data format for these kinds of things.
    boolean read_attributes = false;    boolean read_annotations = false;    boolean read_metaData = false;
    boolean read_OpCodes = false;       boolean read_PGOData = false;        boolean read_PerfData = false;
    boolean read_ControlFlowData = false;
    
    String[] tokens = restOfLine.split(" ");
    for(int i =0; i < tokens.length; ++i){
      
        if(tokens[i].equals("Attributes")){
            read_attributes = true;    read_annotations = false;    read_metaData = false;
            read_OpCodes = false;      read_PGOData = false;        read_PerfData = false;
            read_ControlFlowData = false;
            continue; // move on to the next token once we've changed state
        }else if(tokens[i].equals("Annotations")){
            read_attributes = false;    read_annotations = true;    read_metaData = false;
            read_OpCodes = false;       read_PGOData = false;       read_PerfData = false;
            read_ControlFlowData = false;
            continue; // move on to the next token once we've changed state
        }
        else if(tokens[i].equals("Metadata")){
            read_attributes = false;    read_annotations = false;    read_metaData = true;
            read_OpCodes = false;      read_PGOData = false;         read_PerfData = false;
            read_ControlFlowData = false;
            continue; // move on to the next token once we've changed state
        }
        else if(tokens[i].equals("Opcodes")){
            read_attributes = false;    read_annotations = false;     read_metaData = false;
            read_OpCodes = true;        read_PGOData = false;         read_PerfData = false;
            read_ControlFlowData = false;
            continue; // move on to the next token once we've changed state
        }
        
        else if(tokens[i].equals("PGO Data")){
            read_attributes = false;    read_annotations = false;    read_metaData = false;
            read_OpCodes = false;       read_PGOData = true;         read_PerfData = false;
            read_ControlFlowData = false;
            continue; // move on to the next token once we've changed state
        }
        else if(tokens[i].equals("Perf Data")){
            read_attributes = false;    read_annotations = false;    read_metaData = false;
            read_OpCodes = false;       read_PGOData = false;        read_PerfData = true;
            read_ControlFlowData = false;
            continue; // move on to the next token once we've changed state
        }
        else if(tokens[i].equals("Control Flow Data")){
            read_attributes = false;    read_annotations = false;    read_metaData = false;
            read_OpCodes = false;       read_PGOData = false;        read_PerfData = false;
            read_ControlFlowData = true;
            continue; // move on to the next token once we've changed state
        }
        
        // Append to the appropriate field
        if(read_attributes){
          attributes += tokens[i];
        }
        if(read_annotations){
          annotations += tokens[i];
        }
        if(read_metaData){
          metaData += tokens[i];
        }
        if(read_OpCodes){
          OpCodes += tokens[i];
        }
        if(read_PGOData){
          PGOData += tokens[i];
        }
        if(read_PerfData){
          PerfData += tokens[i];
        }
        if(read_ControlFlowData){
          ControlFlowData += tokens[i];
        }
    }
        
    nodeMetaData src = new nodeMetaData(functionName,restOfLine, attributes,annotations,metaData,OpCodes,PGOData,PerfData,ControlFlowData);
    
    return src;
  }
  
  
  /*
    Read a DOT file where node=struct is the default.
  */
  synchronized public void readStructDOT(String file){
    println("readStructDOT");
    println("Something is blowing up here");
      String[] lines = loadStrings(file);   
      // Do one iteration through the list to build the nodes
      println("read in file with "+lines.length+" lines");
        for(String s: lines){
            // Build up all of the sources first
            // For every node we need to add it in our graph
            if(s.contains("shape=record") && !s.equals("node [shape=record];")){
              nodeMetaData md = processStruct(s);
            
              fullNodeList.put(md.name, md);
            }
        }
      
      println("made it to here in readStructDOT");
      
      // Do a second iteration through the lines to build the relationship(src->dst i.e. caller and callees)
      for(String line: lines){
        // Read in a line
        // Find that node in our fullNodeList
        // Add to its destinations
        if (line.contains("->")){
            // Split the line, parse it, and retrieve our
            // source and destination nodes.
            String[] tokens = line.split(" ");
            
            // Create temporary nodes with the ones we found
            nodeMetaData src = (nodeMetaData)fullNodeList.get(tokens[0]);
            nodeMetaData dst = (nodeMetaData)fullNodeList.get(tokens[2]);
            
            // If the function exists, then add a new destination
            if(graph.containsKey(src)){
              LinkedHashSet<nodeMetaData> temp = (LinkedHashSet<nodeMetaData>)(graph.get(src));
              temp.add(dst);
              graph.put(src,temp);
            }else{
              // Create a new node
              LinkedHashSet<nodeMetaData> incidentEdges = new LinkedHashSet<nodeMetaData>();
              incidentEdges.add(dst);
              graph.put(src,incidentEdges);
              totalSources++;
            }
          
        } // if (lines[i].contains("->"))
      } // for(int i =0; i < lines.length; i++)
  }
  
  /*
      Process a single line of data when we read it in.
  */
  public void processLine(String line){
      println("");
  }
  

  
  public void printGraph(){
    
    Set<nodeMetaData> keys = graph.keySet();
    for(nodeMetaData aKey: keys){
      println(aKey.name + " -> " + graph.get(aKey));
    }
  }
  
  /*
  @Override
  public Iterator<nodeMetaData> iterator(){
    return fullNodeList.iterator();
  }
  */
  
}
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
int CalleeDepth = 15;

int heightOfGUIElements = 20;

public void initGUI(){
  filtersPanel = new ControlP5(this);
  
  breadCrumbsBar = filtersPanel.addButtonBar("theBreadCrumbsBar")
                       .setPosition(0, height-20)
                       .setSize(width, 20)
                       ;                                      
       
}



// function controlEvent will be invoked with every value change 
// in any registered controller
public void controlEvent(ControlEvent theEvent) {
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
    ChordNodeList temp2 = (ChordNodeList)hw.m_histogram.nodeListStack.pop();
    ChordNodeList temp3 = (ChordNodeList)bw.m_buckets.nodeListStack.pop();
    
    if(temp!=null){  // If we didn't pop anything off of the stack, then do not remove any items
      filtersPanel.get(ButtonBar.class, "theBreadCrumbsBar").removeItem(temp.name);
      cd.fastUpdate(); // Make a call to update the visualization
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
      ChordNodeList temp2 = (ChordNodeList)hw.m_histogram.nodeListStack.pop();
      ChordNodeList temp3 = (ChordNodeList)bw.m_buckets.nodeListStack.pop();
      
      if(temp!=null){  // If we didn't pop anything off of the stack, then do not remove any items
        filtersPanel.get(ButtonBar.class, "theBreadCrumbsBar").removeItem(temp.name);
        cd.fastUpdate(); // Make a call to update the visualization
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
/*
    This class serves as the details window to display other information.
*/
class HistogramWindow extends commonWidget {
  
  // a self-contained 
  Histogram m_histogram;
  String filename;

  public HistogramWindow(String filename){
    this.filename = filename;
    println("a from Histogram");
    m_histogram = new Histogram(filename,0,height-30,0);
  }
  
  public void settings() {
    size(1440, 350, P3D);
    smooth();
  }
    
  public void setup() { 
      println("setup Histogram");
      surface.setTitle(windowTitle);
      surface.setLocation(1440, 350);
  }
  
  int p_node_old = -1;
  int p_node = -1;
  Set<Integer> selectedNodes = new HashSet<Integer>();
  
  public void draw() {
    float m_x = mouseX;
    float m_y = mouseY;   
    
    if(m_histogram != null){
    // Refresh the screen    
      background(0,64,128);
        text("FPS :"+frameRate,width-100,height-20);
        text("Camera Position ("+MySimpleCamera.cameraX+","+MySimpleCamera.cameraY+","+MySimpleCamera.cameraZ+")",5,height-20);
        text("(x,y) => ("+m_x+","+m_y+")",width-200,height-20);
           
           //m_histogram.draw(0); // TODO: FIXME: This is a bug, for some reason I "Cannot run the OpenGL renderer outside the main thread, change your code so the drawing calls are all inside the main thread"
           //m_histogram.drawBounds(0,64,128, m_histogram.xPosition,m_histogram.yPosition-m_histogram.yBounds);
           // What is interesting about the drawing, is that it is all happening in the
          // ChordNode itself. This way we can have any arbritrary shape in ChordNode
          // drawn and handle all of the selection there. It also would allow us to have
          // different types of shaped nodes mixed in a visualization much more easily.
          for(int i =0; i < m_histogram.nodeListStack.peek().size();i++){
            ChordNode temp = (ChordNode)m_histogram.nodeListStack.peek().get(i);
                       
            fill(temp.metaData.c); stroke(255);
            
            // Highlight nodes we are over
            if(m_x > temp.x && m_x < temp.x+temp.rectWidth){
              fill(192);
              text("selected: "+i+" prev: "+p_node+" prev2: "+p_node_old,200,150);
              // Highlight nodes we are hovering over
              fill(255,255,0,255); stroke(255);
              
              // Unhighlight all of the previous buckets that were highlighted.
              if(p_node != i){
                p_node_old = p_node;
                p_node = i;
                cd.highlightNode(temp,true);
                // Store the list of nodes we had previously highlighted
                // This allows us to quickly unhighlight them.
                if(p_node_old > -1){
                    ChordNode old = (ChordNode)m_histogram.nodeListStack.peek().get(p_node_old);
                    cd.highlightNode(old,false);
                }
              }
              
                // If the mouse is pressed
                if(mousePressed==true){
                   if(mouseButton==LEFT){
                     if(selectedNodes.contains(i)){
                       cd.toggleActiveNode(temp);
                       selectedNodes.remove(i);
                     }else{
                       cd.toggleActiveNode(temp);
                       selectedNodes.add(i);
                     }
                   }
                }
            }
            
            // If our node has been selected, then highlight it green
            if(selectedNodes.contains(i)){
              fill(0,255,0,255); stroke(255);
            }
            
            // Draw rectangle for each of the buckets.
            rect(temp.x,temp.y - temp.rectHeight,temp.rectWidth,temp.rectHeight);
          }
     }   
  }
  
}

class Histogram extends DataLayer{
  
  int scaledHeight = 250; // Normalize visualization height and values to this
  
  // Default Constructor for the Histogram
  public Histogram(String file, float xPosition, float yPosition, int layout){
    this.visualizationName = "Histogram";
    println("a m_histogram");
    super.init(file, xPosition, yPosition,layout);
    println("b m_histogram");
    // Set a layout
    this.setLayout(layout);
    // Compute initial statistics
    //FIXME: Put me back in later nodeListStack.computeSummaryStatistics();
  }
  

  // Get all of the points into our node list
  private void plotPoints2D(){
    float xPos = xPosition;
    
    for(int i =0; i < nodeListStack.peek().size();i++){
      nodeListStack.peek().get(i).x = xPos;
      nodeListStack.peek().get(i).y = yPosition;
      xPos += defaultWidth+1;
      xBounds = xPos;
    }
  }
  
  
  /*
      Currently there is only one layout supported.
  */
  public void setLayout(int layout){
    this.layout = layout;
        
    // Quick hack so the visualization can render quickly, also calculates the number of callees from the caller
    // This is called after we have positioned all of our nodes in the visualization
    storeLineDrawings(1);
    // Draw the mapping of the visualization (Different layouts may need different 
    // functions called.
    // This function cycles through all of the nodes and generates a numerical value that can be sorted by
    // for some attribute that we care about
    this.generateHeatForCalleeAttribute(scaledHeight);
    
    sortNodesByCallee();
    
    // Modify all of the physical locations in our nodeList
    fastUpdate();
    
    // Quick hack so the visualization can render quickly, also calculates the number of callees from the caller
    // This is called after we have positioned all of our nodes in the visualization
    storeLineDrawings(0);
  }
    
  
  // Here maxHeight represents how many pixels we scale to (
  // (i.e. the maximum value in the set will equal this)
  public void generateHeatForCalleeAttribute(float maxHeight){
    // Find the max and min from the ChordNode metadata
    float themin = 0;
    float themax = 0;
    for(int i =0; i < nodeListStack.peek().size();i++){
      themin = min(themin,nodeListStack.peek().get(i).metaData.callees);
      themax = max(themax,nodeListStack.peek().get(i).metaData.callees);
    }
    
    // Set the yBounds to the max value that our visualization scales to.
    yBounds = (int)map(themax, themin, themax, 0, maxHeight);
    
    println("themin:"+themin);
    println("themax:"+themax);
    // Then map that value into the ChordNode so that it can render correctly.
    // We scale from 
    for(int i =0; i < nodeListStack.peek().size();i++){
      // Get our callees and map it agains the min and max of other callees so we know how to make it stand out
      nodeListStack.peek().get(i).metaData.callees = (int)map(nodeListStack.peek().get(i).metaData.callees, themin, themax, 0, maxHeight);
      nodeListStack.peek().get(i).metaData.c = nodeListStack.peek().get(i).metaData.callees;
      // Our shapes are rectangular, so we need to set this in the ChordNode
      nodeListStack.peek().get(i).rectWidth = defaultWidth;
      nodeListStack.peek().get(i).rectHeight = nodeListStack.peek().get(i).metaData.callees;
    }
  }
  
  /*
      Useful for being used in update where we don't need to do anything else with the data.
      This means setLayout should only be called once initially.
      
      Fast layout will layout the nodes. It is nice to have this abstracted away
      into its own function so we can quickly re-plot the nodes without doing additional
      computations.
  */
  public void fastUpdate(){
    // Modify all of the positions in our nodeList
    if(this.layout <= 0){
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
     this.setLayout(layout);
  }
    
  /*
      Draw using our rendering modes
  */
  public void draw(int mode){
    if(showData){
           // Draw a background
          pushMatrix();
            drawBounds(0,64,128, xPosition,yPosition-yBounds);
          popMatrix();
          // What is interesting about the drawing, is that it is all happening in the
          // ChordNode itself. This way we can have any arbritrary shape in ChordNode
          // drawn and handle all of the selection there. It also would allow us to have
          // different types of shaped nodes mixed in a visualization much more easily.
          for(int i = 0; i < nodeListStack.peek().size(); ++i){
            ChordNode temp = (ChordNode)nodeListStack.peek().get(i);
            temp.render(2);
          }
    
      }
  }
  
  
}
/*
    Purpose is to be used to store the location of a callee
    
    We can also name the point in space.
    The most pragmatic use case will be to name the point in space after the callee.
*/

// Represents a point in space
class LocPoint{
 float x;
 float y;
 float z;
 String name;
 /*
 LocPoint(float x, float y){
   this.x = x;
   this.y = y;
   this.z = 0;
 }
 
  LocPoint(float x, float y, float z){
   this.x = x;
   this.y = y;
   this.z = z;
 }
 */
 LocPoint(float x, float y, float z, String name){
   this.x = x;
   this.y = y;
   this.z = z;
   this.name = name;
 }
}

/*
  The purpose of this class is to store the translations from the camera
  so that we don't have to pass them around in a stack or some other nasty way.
*/
protected static class MySimpleCamera{
   protected static float cameraX = 0;
   protected static float cameraY = 0;
   protected static float cameraZ = 0 ;
   
   // Camera speed
   public static float cameraSpeed = 10;
   
    // Setup the mouse
      // These three values take into account the mouseX,mouseY positions, and camera orientation
    protected static float xSelection;
    protected static float ySelection;
    protected static float zSelection;

   // This constructor is not called
   // unless this class is an inner class I believe.
   public MySimpleCamera(){
     cameraX = 0;
     cameraY = 0;
     cameraZ = 0;
     cameraSpeed = 10;
     println("HI from the static constructor");
   }
   
   public static void setCameraSpeed(float speed){
      cameraSpeed = speed; 
   }
   
   public static void moveForward(){
     cameraZ += cameraSpeed;
   }
   
   public static void moveBack(){
     cameraZ -= cameraSpeed;
   }
   
   public static void moveUp(){
     cameraY -= cameraSpeed;
   }
   
   public static void moveDown(){
     cameraY += cameraSpeed;
   }
   
   public static void moveLeft(){
     cameraX += cameraSpeed;
   }
   
   public static void moveRight(){
     cameraX -= cameraSpeed;
   }
   
   /*
       Pass in mouse x and mouse y
   */
   public static void update(float mx, float my){
      // Translate the mouse coordinates to the pixel-space coordinates appropriately, so if we move the camera we can see everything.
      xSelection = (mx-cameraX);
      ySelection = (my-cameraY);
      zSelection = cameraZ;
   }
   
}


/*
    This data structure is a stack.
    The elements of the stack are of the type ''
    
    We can push and pop items off of the stack
*/
public class NodeListStack{
  
     /*
        The purpose of this class is to exist within the NodeListStack
        
        Instances of this object will collect interesting data information
        and be able to output and save the statistics somewhere.
    */
    class SummaryStatistics{
      
       // Attributes
       int callers; // Total number of caller functions
       int callees; // Total number of callees (i.e. the sum of all of the call sites for each caller function).
      
       SummaryStatistics(){
         this.callers = 0;
         this.callees = 0;
       }
       
       /*
         Prints out a string with the statistics
       */
       synchronized public String output(){
         String result = "Callers: " + callers +
                         "Callees: " + callees;
         return result;
       }
       
    }
  
  
  
  // The all important stack
  Deque <ChordNodeList> stack;
  
  // Store statistics about the data 
  // Note that these statistics are always in reference to
  // the top node of the stack.
  // Anytime we push or pop, we need to recompute the summary statistics
  public SummaryStatistics summaryStatistics;
  
   // Store the total elements that are at the first level
   // This is conveinient so we can see how much data we have filtered out.
   int bottomOfStackCallers = 0; 
   int bottomOfStackCallees = 0;
  
  /*
      Default Constructor
  */
  public NodeListStack(){
    // Instantiate our stack
    stack = new ArrayDeque<ChordNodeList>();
    // Instantiate summary statistics
    summaryStatistics = new SummaryStatistics();
  }
  
  public int size(){
    return stack.size();
  }
 
  
  /*
    Add on a new filter
    Then compute summary Statistics
  */
  public void push(ChordNodeList activeNodeList){
        stack.push(activeNodeList);
        // FIXME: Put this back in the code computeSummaryStatistics();
  }
  
  /*
    Remove our last filter
    Then compute summary statistics
    
    // Notice that this does not work like a traditional stack
    // We never want our stack to be empty.
  */
  public ChordNodeList pop(){
      if(stack.size()>1){
        // FIXME: Put this back in the code computeSummaryStatistics();
        return stack.pop();
      }
    return null;
  }
  
  /*
    Peek at the top of our stack
  */
  public ChordNodeList peek(){
        
    if(stack.size() > 0){
      return (ChordNodeList)stack.peek();
    }else{
      return null;
    }
  }
  
  // Update the summary statistics based on the active nodes.
  synchronized public void computeSummaryStatistics(){
    println("computeSummaryStatistics()");

         summaryStatistics.callers = 0; // Total number of caller functions
         summaryStatistics.callees = 0; // Total number of callees (i.e. the sum of all of the call sites for each caller function).
         println("might crash");
         ChordNodeList temp = stack.peek();
         println("temp.size():"+temp.size());
         
          for(int i =0; i < stack.peek().size();i++){
            summaryStatistics.callees += stack.peek().get(i).metaData.callees;
            // A caller is defined as a function that calls at least one other callee.
            if(stack.peek().get(i).metaData.callees > 0){
               summaryStatistics.callers++; // Total number of caller functions
            }
          }
         
         // Figure out how much of the data we are seeing.
         // Store our first push onto the stack here
         if (stack.size()==1){
           bottomOfStackCallers = summaryStatistics.callers; // Total number of caller functions
           bottomOfStackCallees = summaryStatistics.callees; // Total number of callees (i.e. the sum of all of the call sites for each caller function).
         }
                 
         println("Total Callers:"+summaryStatistics.callers + " of "+bottomOfStackCallers);
         println("Total Callees:"+summaryStatistics.callees + " of "+bottomOfStackCallees);
         printStack();
  }
  
  /*  Returns how many active nodes there are on the visualization by getting the
      size of the nodeList that lives on the stack.
  */
  public int totalActiveNodes(){
      return stack.peek().size();
  }
  
  // Outputs the stack from top to bottom
  public void printStack(){
      Iterator<ChordNodeList> iter = stack.iterator();
      
      int counter = 0;     
      while (iter.hasNext()){
          //ChordNodeList temp = iter;
          System.out.println(counter+".) ");
          counter++;
          iter.next();
          iter.remove();  // Avoid ConcurrentModificationException
      }
  }
  
  // Generates a dot graph from the top of the stack
  // The mode specifies how to output nodes
  // mode 0 (default) - Output all of the nodes that are visible in our visualization
  // mode 1           - Output all of the nodes that are selected.
  public void outputDot(String filepath, int mode){
    PrintWriter output;

    output = createWriter(filepath);
    output.println("digraph{");
    
    for(int i =0; i < stack.peek().size();i++){
      ChordNode currentNode = stack.peek().get(i);
      
      if(mode <= 0){
          output.println(currentNode.metaData.name + " -> " + "some_callee");
      }else if(mode ==1){
        // Check if our node is selected first, and then output it. Otherwise we don't care.
        if(currentNode.selected){
          // Get all of the callees from our node that has been selected
          for(int j = 0; j < currentNode.LocationPoints.size(); j++){
            output.println(currentNode.metaData.name + " -> " + currentNode.LocationPoints.get(j).metaData.name);
          }          
        }
      }
    }
    
    output.println("}");
    output.flush();
    output.close();
  }
  
  // Return map
  // This is useful, if we want to search very quickly
  // over our collection of nodes, then we can learn the list
  // very quickly (O(1)) instead of O(n).
  //
  // Note that the key is a node's name, as often we want to search by the nodes name
  //
  public Map<String,ChordNode> getTopStackMap(){
    // Create a temporary map
    Map<String,ChordNode> tempMap = new HashMap<String,ChordNode>();  

    // Iterate through all of the items on the top of our stack
//    if(stack!=null && stack.peek()!=null){
//     println("stack is not null");
      for(int i =0; i < stack.peek().size();++i){
          // FIXME: Umm, this might be where I need to fix a bunch of crap // println("Doing some dangerous iteration!");
          ChordNode temp = stack.peek().get(i);
          tempMap.put(temp.metaData.name,temp);
      }
//    }

    return tempMap;
  }

  
  
  
}

/*
    How visualizations work in this framework
    
    (1) Build a new class that implements Visualization Layouts
    (2) Create a dotGraph object within that class that you load a file into
    (3) Get access to the fullNodeList from the dotGraph instance in your class
    (4) Create a custom plotting method that is called from regenerate Layout
    (5) Add ways to make the nodes stand out.
    (6) draw all of the nodes
        (If necessary add new modes within the ChordNode)

*/



// In order to build a unified API, we 
// want all of our files to work through
// this framework
interface VisualizationLayout{
  
  /* Every visualization needs a way to 
  position the ChordNodes in the visualization.
  Doing this helps keep the program running fast.
  It also allows us to get multiple(say a 2D and 3D) visualization
  of one type of graph within one class
  
  Typically this function is called once in the constructor of a visualization
  and then only called again from the user based on input(they select to re-render.
  
  regenerateLayout should just simply make calls out to other private rendering
  functions within the class.*/
  public void regenerateLayout(int layout);
  
  /* Position at which to draw the visualization */
  public void setPosition(float x, float y);
  
  /* Every visualization needs a draw method with at least one mode */
  public void draw(int mode);
  
}




/*
    This class is made use of from ChordNode to store metaData.
*/
class nodeMetaData implements Comparable<nodeMetaData>{
  
  String name;
  String extra_information;
  int callees = 0;
  float c;  // the color of the node
  
  String attributes;
  String annotations;
  String metaData;
  String OpCodes;
  String PGOData;
  String PerfData;
  String ControlFlowData;
    
  public nodeMetaData(String name, String extra_information, String attributes, String annotations, String metaData, String OpCodes, String PGOData, String PerfData, String ControlFlowData){
    this.name = name;
    this.extra_information = extra_information;
    this.attributes=attributes;
    this.annotations=annotations;
    this.metaData=metaData;
    this.OpCodes=OpCodes;
    this.PGOData=PGOData;
    this.PerfData=PerfData;
    this.ControlFlowData=ControlFlowData;
    
    c = 0;
  }
  
  public nodeMetaData(String name){
    this.name = name;
    c = 0;
  }
  
  // Prints all of the metaData to a string.
  public String getAllMetadata(){
    String result = "";
    result += "\nname: "+name + "\n";
    result += "Callees: "+callees + "\n";
    result += "attributes: "+attributes + "\n";
    result += "metaData: "+metaData + "\n";
    result += "OpCodes: "+OpCodes + "\n";
    result += "PGOData: "+PGOData + "\n";
    result += "PerfData: "+PerfData + "\n";
    result += "ControlFlowData: "+ControlFlowData + "\n";
    result += "extra_information: "+extra_information + "\n";
    
    return result;
  }
 
  // Copies in the metadata from another node into this one.
  // Generally this is used for making new instances (i.e. we need a copy constructor)
  // 
  public void copyMetaData(nodeMetaData n){
    n.name              = this.name;
    n.extra_information = this.extra_information;
    n.callees           = this.callees;
    n.c                 = this.c;  // the color of the node
  }
 
  public int compareTo(nodeMetaData other){
    /*
    if (this.name < other.name || this.name == other.name) {
      return -1;
    }else{
      return this.name == other.name ? 0 : 1;
    }
    */
      return name.compareTo(other.name);
  }
  
  // Use the name of the node as the hashcode
  @Override
  public int hashCode(){
    return name.hashCode();
  }
  
  // Test for string equality. This maintains 3 properties: reflexive, symmetric, and transitivity.
  @Override
  public boolean equals(Object obj){

    if(this==obj){
      return true;
    }
    if(obj==null){
      return false;
    }
    if(!(obj instanceof nodeMetaData)){
      return false;
    }
    nodeMetaData temp = (nodeMetaData)obj;
    return (temp.name.equals(this.name));
  }
  
  
} // ends class nodeMetaData implements Comparable<nodeMetaData>{
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
  public void filterSelector(int n) {
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ChordPlot" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
