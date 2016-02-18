import controlP5.*;
import javax.swing.*; 
import java.io.*;


/*
    The different sorting critiera

public enum SortCriteria{
  CALLEE,
  CALLER,
  PGODATA,
  BITCODESIZE;  
}
*/

/*
    Work around because Processing cannot handle enum's properly.
*/
public static final int CALLEE       = 0;
public static final int CALLER       = 1;
public static final int PGODATA      = 2;
public static final int BITCODESIZE  = 3;
public static final int RECURSIVE    = 4;
public static final int FILENAME     = 5;

/*
  Create a second window
*/
DetailsPane dp;

/*
  Create an encoding window
*/
EncodingWindow ew;

/* Create our visualizations */
ChordDiagram cd;

// HistogramWindow hw;
BucketsWindow bw;

// Animation window
AnimationWindow aw;

// Small Force-directed graph window
forceDirectedGraphWindow fdgw;

//nodeLinkSystem encodings;

int programStart = 0;

String llbitcodefile = " /home/mdshah/Desktop/LLVMSample/RandomPrograms/chicago_merged.ll";

String traceFileName = "C:\\Users\\mshah08\\Desktop\\Lightweight-PGO-LLVM-Visualization\\ChordPlot\\ChordPlot\\data\\ProjectTemplate\\trace.txt"; // Windows
//String traceFileName = "/home/mike/Desktop/Lightweight-PGO-LLVM-Visualization/ChordPlot/ChordPlot/data/Blender/trace.txt";         // Unix
//String   traceFileName = "/Users/michaelshah/Desktop/Lightweight-PGO-LLVM-Visualization/ChordPlot/ChordPlot/data/ProjectTemplate/trace.txt"; // MAC

void settings(){
  size(900 ,900, P3D);
}

/*
    Processing program initialization
*/
void setup(){  
  programStart = millis();
  surface.setTitle("Microarray Visualization");
  surface.setLocation(0, 0);
  
  
  ortho(-width/2.0, width/2.0, -height/2.0, height/2.0); // same as ortho()

  //String filename = "/home/mdshah/Desktop/LLVMSample/blah.dot"; // has branch weights
  
  // Uncomment out the dataset you want to use.
  String filename = "./fullDotOgre.dot"; // Attempt to load Soot data
  //  filename = "horde3d.dot"; // Horde3D
  //filename = "fullDotOgre.dot";  // Load Ogre Data
  
  // Our base visualizations
  // It is best practice to intialize this first since we reference 'cd' across
  // the entire codebase.
  cd = new ChordDiagram(400, filename,1);
  
  //h = new Histogram(filename,20,height-30,0);

  // Create the second window with the details pane
  dp = new DetailsPane();
  dp.setDataString("File Loaded: "+filename);
  
  ew = new EncodingWindow();
  
  // Try to speed up loading times.
  // hw = new HistogramWindow(filename);
  bw = new BucketsWindow(filename);
  aw = new AnimationWindow(filename);
  
  fdgw = new forceDirectedGraphWindow();
  
 // encodings = new nodeLinkSystem();
  
  /* //What we are encoding(the attribute), and how it is decoded(the visual presentation)
  nodeLink recursive_enc =   new nodeLink("recursive",0,0,0,true,false);       encodings.addNode(recursive_enc);
  nodeLink callsite_enc =    new nodeLink("Callsite",0,80,0,true,false);       encodings.addNode(callsite_enc);
  nodeLink bitcode_enc =     new nodeLink("BitCode Size",0,160,0,true,false);  encodings.addNode(bitcode_enc);
  
  nodeLink heat_dec =       new nodeLink("heatmap",200,0,0,false,true);           encodings.addNode(heat_dec);
  nodeLink symbol_dec =     new nodeLink("symbol",200,80,0,false,true);           encodings.addNode(symbol_dec);
  nodeLink stroke_dec =     new nodeLink("stroke color",200,160,0,false,true);    encodings.addNode(stroke_dec);
  nodeLink rectangle_dec =  new nodeLink("Rectangle",200,240,0,false,true);       encodings.addNode(rectangle_dec);
  nodeLink rectspin_dec =   new nodeLink("Rectangle Spin",200,320,0,false,true);  encodings.addNode(rectspin_dec);
*/
  
  bw.m_buckets.debug();
  
  // Initialize our GUI after our data has been loaded
  initGUI();  
  
  println("setup time: " + (millis()-programStart));
}

/* =============================================
     Main draw function in the visualization
   ============================================= */
void draw(){
  // Update the mouse Coordidinates with our camera
  MySimpleCamera.update(mouseX, mouseY);
  
  // Refresh the screen
  background(128);
   
  text("FPS :"+int(frameRate),width-50,height-20);
   
   pushMatrix();
     translate(MySimpleCamera.cameraX,MySimpleCamera.cameraY,MySimpleCamera.cameraZ);
     cd.draw(drawMode);
     //h.draw(0);
   popMatrix();
}