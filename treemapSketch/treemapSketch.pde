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
                    if(head.isLeaf())
                      {totalSizeOfSubtree += head.getSize();}
                    
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
    
    boolean isLeaf(){
      if(children == null){
        return true;
      }else{
        return false;
      }
      
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
        
        treeNode a = new treeNode("a",50);   a.c = color(123,0,143); // red
        treeNode b = new treeNode("b",50);   b.c = color(204,102,0); // orange
        treeNode bb = new treeNode("bb",50); bb.c = color(0,255,0); // green
        treeNode c = new treeNode("c",50);   c.c = color(0,204,204); // sky blue
        treeNode d = new treeNode("d",50);   d.c = color(0,0,255);    // blue
        treeNode e = new treeNode("e",50);   e.c = color(255,103,255); // pink
        treeNode f = new treeNode("f",50);   f.c = color(0,0,192); // light blue
        treeNode g = new treeNode("g",50);   g.c = color(200,200,200); // white
        treeNode h = new treeNode("h",50);   h.c = color(210,210,210); // white
        treeNode i = new treeNode("i",50);   i.c = color(220,0,0); // white
        treeNode j = new treeNode("j",50);   j.c = color(230,0,0); // white
        treeNode k = new treeNode("k",50);   k.c = color(230,230,230); // white
        treeNode l = new treeNode("L",50);   l.c = color(230,230,230); // white
        treeNode m = new treeNode("m",50);   m.c = color(0,230,0); // white
        treeNode n = new treeNode("n",50);   n.c = color(230,0,0); // white
        treeNode o = new treeNode("o",50);   o.c = color(230,0,0); // white
        
           
           l.addChild(m);
           c.addChild(l);
           c.addChild(k);
           h.addChild(o);
           h.addChild(n);
           h.addChild(j);
           h.addChild(i);
           g.addChild(h);
           f.addChild(g);
           d.addChild(f);
           b.addChild(bb);
           a.addChild(e);
           a.addChild(d);
        root.addChild(a);
        root.addChild(b);
        root.addChild(c);
        
        root.size = root.computeChildrenSize();
    }
    
    

    
    // Draws a tree map
    //
    // params:
    // axis - Whether we are cutting along the x or y axis
    // cushion - initial cushion to have on the treeMap
    // border - How much to grow the cushion at each level of the tree
    void drawTreeMap(treeNode root, float x1, float y1, float x2, float y2, int axis,int cushion, int border){
        
        
        if(root.children != null){
                  // In this if-conditional, the goal is to flip the axis (x or y) that we are partioning
                  // and drawing new slices
            float[] nodeXSizes = new float[root.children.size()];
            float[] nodeYSizes = new float[root.children.size()];
            for(int i =0; i < root.children.size();i++){
              treeNode child = root.children.get(i);
              nodeXSizes[i] = x1+((x2-x1) * (child.totalSizeOfSubtree / root.totalSizeOfSubtree));
              nodeYSizes[i] = y1+((y2-y1) * (child.totalSizeOfSubtree / root.totalSizeOfSubtree));
            }
            
            for(int i =0; i < root.children.size();i++){
                  treeNode child = root.children.get(i);

                  
                  if (axis == 0){
                    float move = x1;
                    if(i>0){
                      for(int j =0; j < i;j++){
                        move+= nodeXSizes[j];
                      }
                    }
                    fill(child.c,128); rect(move+cushion,y1+cushion,nodeXSizes[i]-cushion-cushion,y2-cushion-cushion);  // Background layer of treemap 
                    stroke(255,255);textSize(16);fill(16,255);text("|"+child.name+"|",move+cushion,y1+16+border+cushion);
                    
                    drawTreeMap(child, move, y1, nodeXSizes[i], y2, 1,cushion+border,border); 
                  }
                  else{
                    float move = y1;
                      if(i>0){
                        for(int j =0; j < i;j++){
                          move+= nodeYSizes[j];
                        }
                      }
                    
                    fill(child.c,128); rect(x1+cushion,move+cushion,x2-cushion-cushion,nodeYSizes[i]-cushion-cushion);  // Background layer of treemap    
                    stroke(255,255);textSize(16);fill(16,255);text("|"+child.name+"|",x1+cushion,move+16+border+cushion);
                    
                    drawTreeMap(child, x1, move, x2, nodeYSizes[i], 0,cushion+border,border);
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
    frame.setResizable(true);
  }
  
  myTreeMap = new TreeMap(0,0,200,200);
  myTreeMap.loadFile();
  myTreeMap.walkTree();
  
  float[] P = new float[2];
  float[] Q = new float[2];
  
  P[0] = 0;    P[1] = 0;
  Q[0] = 480;  Q[1] = 240;
  
  myTreeMap.drawTreeMap(myTreeMap.root,0,0,width,height,0,4,4);
  
  //myTreeMap.drawTreeMap2(myTreeMap.root,P,Q,0,0,0);
}



void draw() {

myTreeMap.drawTreeMap(myTreeMap.root,0,0,width,height,0,2,0);
   
}
