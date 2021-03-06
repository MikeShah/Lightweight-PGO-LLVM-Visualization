// Class that is to be used within a treeNode.
// The purpose is to be able to store more information
// than just the size, but perhaps other meta-data that can be queried.
//
// A good alias-name for this class would be 'data'
//
// 

import java.util.*;
import java.io.*;


class attributes{
  
  String Instruction;
  String context;          
  int mayReadFromMemory;
  int mayWriteToMemory;
  int isAtomic;
  int mayThrow;
  int mayReturn;
  int isAssociative;
  String callsfunction;
  String File;
  int Line;  // default value is set to 1
  int Column; // default value is set to 1
  
  attributes(){
    String context = "omitted";
  }
  
  void loadData(String filename){
    
  }
  
  String dumpAttributes(){
    return Instruction + "\n" + context + "\n" + File + "\n" + Line + ":" + Column;
  }
  
  
}

class treeNode{

    String name;
    float size;
    attributes _attributes;
    color c;
    int level;
    
    Vector<treeNode> children; 
    float totalSizeOfSubtree;
    
    // Add a node that has a known name and a size.
    treeNode(String name, float size){
       this.name = name;
       this.size = size;
       this.totalSizeOfSubtree = size;
       this.c = color(255-size,0,0);
       children = null; 
       
       this._attributes = new attributes();
       level = 0;
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
    void computeChildrenSize(){
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
                    
                    // If it's a node, then compute the size of this branch.
                    if(head.isLeaf()){
                        totalSizeOfSubtree += head.getSize();
                    }
                      
                    // Add all of the children and then increase the node level of our
                    // leve-order traversal
                    if(head.children!=null){
                      for(int i =0; i < head.children.size();i++){
                        head.children.get(i).level = head.level+1;  // Children will always be 1 more than their parent
                        bfs.add(head.children.get(i));
                      }
                    }
                  }
       }else{
         // If we have no children, then we are a leaf, and set our size
         // to our self.
         totalSizeOfSubtree = this.getSize();
       }
       
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
      return name + ": \tsize:"+size+"\ttotal size:"+totalSizeOfSubtree+" children:"+namesOfChildren+"\tlevel:"+level;
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
    
    // At any give time, the dataString will be loaded and can be acquired from.
    DataString dataString;

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
      dataString = new DataString();
      dataString.setText("default text");
    }
    
    // We print out the tree
    // We also need to recompute the sizes of each of the nodes when we traverse
    void walkTree(){
      // Perform a BFS to walk the tree
      Queue<treeNode> bfs = new LinkedList<treeNode>();
      // Add our root to the tree by default
      bfs.add(root);
      

      
      // Perform a breadth-first search of our treemap
      root.level = 0;
      while(bfs.peek()!=null){
        treeNode head = bfs.remove();  
        totalSize += head.getSize();
        head.computeChildrenSize();  // As we walk the tree, make sure each node also computes it's size. NOTE: this is expensive
        
        //--//--println(head.getName()+"\t"+head.outputNodeData());
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
        
        treeNode a = new treeNode("a",50);   a.c = color(255,255,255); // red
        treeNode b = new treeNode("b",50);   b.c = color(204,102,0); // orange
        treeNode bb = new treeNode("bb",50); bb.c = color(0,255,0); // green
        treeNode c = new treeNode("c",50);   c.c = color(0,204,204); // sky blue
        treeNode d = new treeNode("d",50);   d.c = color(0,0,255);    // blue
        treeNode e = new treeNode("e",50);   e.c = color(0,103,255); // pink
        treeNode f = new treeNode("f",50);   f.c = color(0,0,192); // light blue
        treeNode g = new treeNode("g",50);   g.c = color(200,200,200); // white
        treeNode h = new treeNode("h",50);   h.c = color(210,210,210); // white
        treeNode i = new treeNode("i",50);   i.c = color(220,0,0); // white
        treeNode j = new treeNode("j",50);   j.c = color(230,0,0); // white
        treeNode k = new treeNode("k",50);   k.c = color(230,230,230); // white
        treeNode l = new treeNode("L",50);   l.c = color(230,230,230); // white
        treeNode m = new treeNode("m",50);   m.c = color(0,230,0); // whites
        treeNode n = new treeNode("n",50);   n.c = color(230,0,0); // white
        treeNode o = new treeNode("o",50);   o.c = color(230,0,0); // white
        
        treeNode p = new treeNode("p",50);   p.c = color(0,230,0); // white
        treeNode q= new treeNode("q",50);   q.c = color(0,230,0); // white
        treeNode r= new treeNode("r",50);   r.c = color(0,230,255); // white   
           
           l.addChild(m);
           c.addChild(l);
           c.addChild(k);
           h.addChild(o); // o
           h.addChild(n); // n
           h.addChild(j); // j
           h.addChild(i); // i
           
           o.addChild(p);o.addChild(q);o.addChild(p);o.addChild(p);
           o.addChild(p);o.addChild(p);o.addChild(p);o.addChild(p);
           
           p.addChild(r);p.addChild(r);p.addChild(r);p.addChild(r);
           
           g.addChild(h);
           f.addChild(g);
           d.addChild(f);
           b.addChild(bb);
           
           bb.addChild(p);
           
           a.addChild(e);
           a.addChild(d);
        root.addChild(a);
        root.addChild(b);
        root.addChild(c);
        
        this.walkTree();
    }
    
    // Loads up a JSON File
    // sets up various properties of the
    void loadJSON(String fileName){
      
      // Giant JSONArray that will hold our values
      JSONArray values;
      // Testing json
      values = new JSONArray();
      values = loadJSONArray(fileName);
      
      //Get all of our functions at the top level
      for (int i = 0; i < values.size(); i++) {
        // Obtain one of these functions from our values collection
        JSONObject function = values.getJSONObject(i); 
    
        String functionName = function.getString("functionName");
        int functionSize = function.getInt("size");
        // Create a node from the top level
        treeNode temp = new treeNode(functionName,functionSize);   temp.c = color(random(255),0,0); // red

        JSONArray InstructionData = function.getJSONArray("InstructionData"); //<>//
        // For each of the instructions get the data    
        for(int j = 0; j < InstructionData.size();j++){
            JSONObject iData = InstructionData.getJSONObject(j); 

            // Name node after instruction and by default a size of 1
            String Instruction = iData.getString("Instruction");
            treeNode instructionNode = new treeNode(Instruction,1);   temp.c = color(random(255),0,0); // red
            // Populate node with
            instructionNode._attributes.Instruction = Instruction;
            //instructionNode._attributes.context = iData.getString("context");
            //instructionNode._attributes.mayReadFromMemory = iData.getInt("mayReadFromMemory");
            //instructionNode._attributes.mayWriteToMemory = iData.getInt("mayWriteToMemory");
            //instructionNode._attributes.isAtomic = iData.getInt("isAtomic");;
            //instructionNode._attributes.mayThrow = iData.getInt("mayThrow");;
            //instructionNode._attributes.mayReturn = iData.getInt("mayReturn");;
            //instructionNode._attributes.isAssociative = iData.getInt("isAssociative");;
            //instructionNode._attributes.callsfunction = iData.getString("callsfunction");
            instructionNode._attributes.File = iData.getString("File");
            instructionNode._attributes.Line = iData.getInt("Line Number");
            instructionNode._attributes.Column = iData.getInt("Column");
            
            if(instructionNode._attributes.File!="null"){
              temp.c = color(255,255,255);
            }else{
              temp.c = color(255,0,0);
            }
            temp.addChild(instructionNode);
        }
        
        
        root.addChild(temp);
        this.walkTree();
      }
      
      
      
    }
    

    
    // Function that gets called in the TreeMap
    // when you hover within a region.
    //
    // Returns true or false if we click
    boolean mouseOnHover(treeNode node, float x, float y, float _w, float _h){
      if(mouseX > x && mouseX < x+_w){
        if(mouseY > y && mouseY < y+_h){
          // Highlight the block
          fill(255,192);
          rect(x,y,_w,_h);

          dataString.setText("Function:"+node.name+"\n"+node._attributes.dumpAttributes());
          // What to do when the mouse is pressed
          if(mousePressed && (mouseButton == LEFT) && node._attributes.File!="null"){
            //--("mouse fired:");
            dataString.setText("Function:"+node.name+"\n"+node._attributes.dumpAttributes());
            //--(node._attributes.dumpAttributes());
            // Set our data string which can be displayed around other windows
            // or used for help
            // Note that Java is annoying and always passes in copies, so we have to write our function here.
            
            
             String[] params = {"gnome-terminal", "-e","/usr/bin/vim +"+node._attributes.Line+" "+node._attributes.File};
             
             int time = millis();
             int delay = 1500;
             // Loop that stalls the program so we don't click too many times
             while(millis() - time <= delay){}
             if(node._attributes.File!=null){
               exec(params);
             }
             return true;
          }
        }
      }
      return false;
    }
    
    
    
    // Draws a tree map
    //
    // params:
    // axis - Whether we are cutting along the x or y axis
    // cushion - initial cushion to have on the treeMap
    // border - How much to grow the cushion at each level of the tree
    // levels sets the level of recursion to do
    void drawTreeMap(treeNode root, float x1, float y1, float x2, float y2, int axis,int cushion, int border, int levels){
      int alpha = 192;  // alpha value of the rectangle
      
      if(root.level > levels){
        return;
      }
        
        if(root.children != null){
            
          boolean didWeClick;  
          // pre-compute how big each slice is going to be
            int debug =0;
            if(root.name=="h"){
              debug =0;
            }
            
              float[] nodeXSizes = new float[root.children.size()];
              float[] nodeYSizes = new float[root.children.size()];
              for(int j =0; j < root.children.size();j++){
                treeNode child = root.children.get(j);
                nodeXSizes[j] = ((x2) * (child.totalSizeOfSubtree / root.totalSizeOfSubtree));
                nodeYSizes[j] =((y2) * (child.totalSizeOfSubtree / root.totalSizeOfSubtree));
                if(debug==1){
                    //--(child.name+" subtree size:"+child.totalSizeOfSubtree+"root size:"+root.totalSizeOfSubtree+" nodeYSizes[j]:"+nodeYSizes[j]);
                }
              }
            
            for(int i =0; i < root.children.size();i++){
                  treeNode child = root.children.get(i);

                  // In this if-conditional, the goal is to flip the axis (x or y) that we are partioning
                  // and drawing new slices
                  if (axis == 0){
                    float move = x1;
                    if(i>0){
                      for(int j =0; j < i;j++){
                        move+= nodeXSizes[j];
                      }
                    }
                    fill(child.c,alpha); rect(move+cushion,y1+cushion,nodeXSizes[i]-cushion-cushion,y2-cushion-cushion);  // Background layer of treemap 
                    stroke(255,255);textSize(16);fill(16,255);text("|"+child.name+"|",move+cushion,y1+16+border+cushion);
                    didWeClick = mouseOnHover(child,move+cushion,y1+cushion,nodeXSizes[i]-cushion-cushion,y2-cushion-cushion);
                    drawTreeMap(child, move, y1, nodeXSizes[i], y2, 1,cushion+border,border,levels); 
                    
                  }
                  else{
                    float move = y1;
                      if(i>0){
                        for(int j =0; j < i;j++){
                          move += nodeYSizes[j];
                        }
                      }
                    if(debug==1){
                       //--//--println("y1:"+y1);
                       //--//--println("y2:"+y2);
                       //--//--println("move"+move);
                    }
                    fill(child.c,alpha); rect(x1+cushion,move+cushion,x2-cushion-cushion,nodeYSizes[i]-cushion-cushion);  // Background layer of treemap    
                    stroke(255,255);textSize(16);fill(16,255);text("|"+child.name+"|",x1+cushion,move+16+border+cushion);
                    didWeClick = mouseOnHover(child,x1+cushion,move+cushion,x2-cushion-cushion,nodeYSizes[i]-cushion-cushion);
                    drawTreeMap(child, x1, move, x2, nodeYSizes[i], 0,cushion+border,border,levels);
                  }
            }
        }
        
    }
    
}