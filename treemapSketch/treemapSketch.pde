/**
 * Patterns. 
 * 
 * Move the cursor over the image to draw with a software tool 
 * which responds to the speed of the mouse. 
 */
 import java.util.*;
 

class treeNode{

    String name;
    float size;
    color c;
    
    Vector<treeNode> children; 
    float totalSizeOfSubtree;
  
    // Add a node that has a known name and a size.
    treeNode(String name, float size){
       this.name = name;
       this.size = size;
       this.totalSizeOfSubtree = size;
       this.c = color(random(128)+64,50);
       children = null; 
       
       
    }
    
    // Copy Constructor for treeNode
    treeNode(treeNode t){
      name = t.name;
      size = t.size;
      
      children = t.children;
      totalSizeOfSubtree = t.totalSizeOfSubtree;
    }
    
    // Returns the size of this node
    float getSize(){
      return this.size;
    }
    
    // Returns the name of this node
    String getName(){
      return this.name;
    }
    
    // Returns the size of all children.
    float computeChildrenSize(){
       // reset size
       totalSizeOfSubtree = 0;
       
       if(children != null){
            // Perform a BFS to walk the tree
                  Queue<treeNode> bfs = new LinkedList<treeNode>();
                  // Add our root to the tree by default
                  bfs.add(this);
                  // Perform a breadth-first search of our treemap
                  while(bfs.peek()!=null){
                    treeNode head = bfs.remove();  
                    totalSizeOfSubtree += head.getSize();
                    
                    // Add all of the children
                    if(head.children!=null){
                      for(int i =0; i < head.children.size();i++){
                        bfs.add(head.children.get(i));
                      }
                    }
                  } //<>//
       }
       
       return totalSizeOfSubtree;
    }
    
    // Add a new child, and be sure to compute the
    // size of the treeNode.
    void addChild(treeNode t){
      if(children == null){
        children = new Vector<treeNode>();
      }
      
      children.add(t);
      this.computeChildrenSize();
    }
    
    String outputNodeData(){
      String namesOfChildren = "";
      if(children!=null){
        for(int i =0;i<children.size();i++){
          namesOfChildren += children.get(i).getName()+"("+children.get(i).getSize()+"),";
        }
      }
      return name + ": \tsize:"+size+"\ttotal size:"+totalSizeOfSubtree+" children:"+namesOfChildren;
    }
    
  
}

class Point{
  float x;
  float y;
  
  Point(){
    x =0;
    y =0;
  }
  
  void set(int x, int y){
    this.x = x;
    this.y = y;
  }
  
  Point get(){
    return this;
  }
  
}
class TreeMap{
    
    // TotalSize is the size of all of the trees children.
    int totalSize;
    int x1;
    int y1;
    int w;
    int h;

    // The root tree node
    // Special node that always gives us the top-level access to our tree.
    // Note that root.size will always equal root.totalChildrenSize
    treeNode root;
  
    // x1,y1,x2,y2 are the top-left and bottom-right corners of the treemap
    TreeMap(int x1,int y1,int w,int h){
      this.x1 = x1;
      this.y1 = y1;
      this.w = w;
      this.h = h;
            
      this.root = new treeNode("root",0);
    }
    
    // We print out the tree
    // We also need to recompute the sizes of each of the nodes when we traverse
    void walkTree(){
      // Perform a BFS to walk the tree
      Queue<treeNode> bfs = new LinkedList<treeNode>();
      // Add our root to the tree by default
      bfs.add(root);
      // Perform a breadth-first search of our treemap
      while(bfs.peek()!=null){
        treeNode head = bfs.remove();  
        totalSize += head.getSize();
        
        println(head.getName()+"\t"+head.outputNodeData());
        if(head.children!=null){
          for(int i =0; i < head.children.size();i++){
            bfs.add(head.children.get(i));
          }
        }
      }
      
    }
    
    // Load a file that will build a TreeMap
    void loadFile(){
        // Build a dummy tree
        
        treeNode a = new treeNode("a",50);   a.c = color(255,0,0); // red
        treeNode b = new treeNode("b",50);   b.c = color(204,102,0); // orange
        treeNode bb = new treeNode("bb",50); bb.c = color(0,102,204); // green
        treeNode c = new treeNode("c",50);   c.c = color(0,204,204); // sky blue
        treeNode d = new treeNode("d",50);   d.c = color(0,0,255);    // blue
        treeNode e = new treeNode("e",50);   e.c = color(255,103,255); // pink
        
        c.addChild(d);
        b.addChild(e);
        b.addChild(bb);
        a.addChild(b);
        a.addChild(c);
        root.addChild(a);
        
        
        root.size = root.computeChildrenSize();
    }
    
    

    
    // Draws a tree map
    //
    // params:
    // axis - Whether we are cutting along the x or y axis
    // cushion - initial cushion to have on the treeMap
    // border - How much to grow the cushion at each level of the tree
    void drawTreeMap(treeNode root, float x1, float y1, float x2, float y2, int axis,int cushion, int border){
        
      // This is where we draw our actual node
        fill(root.c,128);
        rect(x1+cushion,y1+cushion,x2-x1-cushion-cushion,y2-y1-cushion-cushion);  // Background layer of treemap
             
        stroke(255);
        textSize(16);
        fill(16);
        text(root.name,x1+cushion,y2-cushion);
        
        // Debug line for figuring out where boundaries are drawn
        println("\n"+root.getName()+"--start("+x1+","+y1+")"+"--end("+x2+","+y2+") axis--"+axis);
        println("\t"+root.getName()+": draw rect("+x1+","+y1+","+(x2-x1)+","+(y2-y1)+")");

        
        if(root.children != null){
                  // In this if-conditional, the goal is to flip the axis (x or y) that we are partioning
                  // and drawing new slices

            for(int i =0; i < root.children.size();i++){
                  treeNode child = root.children.get(i);
                  
                  float x3 = x2-x1;
                  float y3 = y2-y1;
                  
                  float x_width = x3 * (child.totalSizeOfSubtree / root.totalSizeOfSubtree);
                  float y_width = x3 * (child.totalSizeOfSubtree / root.totalSizeOfSubtree);

                  
                  if (axis == 0){
                    // x3 is where we are drawing on the x-axis
                    // Making slices on the x-axis
                    print("\tNext node placed at--x3:"+x3);
                    drawTreeMap(child, x_width, y1, x2, y2, 1,cushion+border,border); //<>//
                    x1 = x3;
                  }
                  else{
                    // Making slices on the y-axis
                    print("\tNext node placed at--y3:"+y3);
                    drawTreeMap(child, x1, y_width, x2, y2, 0,cushion+border,border); //<>//
                    y1 = y3;
                  }
            }
        }
        
    }
    
}



TreeMap myTreeMap;

void setup() {
  size(640, 360);
  background(102);
  
  
  if(frame != null){
    //frame.setResizable(true);
  }
  
  myTreeMap = new TreeMap(0,0,200,200);
  myTreeMap.loadFile();
  myTreeMap.walkTree();
  
  float[] P = new float[2];
  float[] Q = new float[2];
  
  P[0] = 0;    P[1] = 0;
  Q[0] = 480;  Q[1] = 240;
  
  myTreeMap.drawTreeMap(myTreeMap.root,0,0,width,height,0,0,0);
  //myTreeMap.drawTreeMap2(myTreeMap.root,P,Q,0,0,0);
}



void draw() {

    
   
}