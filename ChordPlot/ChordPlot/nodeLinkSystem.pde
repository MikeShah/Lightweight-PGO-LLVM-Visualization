/*
    A collection of nodeLinks
    
    that can work together.
    
    The goal of this class is to 'listen'
    for nodes that are being interacted with
    and then keep track of the relationships
    of which nodes are connected.
    
    The purpose of this class is to take in a metaDataNode
    From that metaData node we can see what fields it has available.
    Of those fields, we can assign them to different properties that will
    affect the rest of the visualization.
*/
class nodeLinkSystem extends PApplet{
  
  /*
      Store all of the links
  */
  ArrayList<nodeLink> links;
  
  public nodeLinkSystem(){
     super();
     PApplet.runSketch(new String[]{this.getClass().getName()}, this);
      
     links = new ArrayList<nodeLink>();
  }
  
  /*
    Add a nodeLink into the system
  */
  public void addNode(nodeLink a){
    links.add(a);
  }
  
  public void settings() {
    size(300, 400, P3D);
    smooth();
  }
    
  public void setup() {
     surface.setTitle("Encodings");
     surface.setLocation(1440, 0);
  }
  

  /*
      If we are a source, then we can connect to other nodes
  */
  void connectTo(nodeLink n){
    float m_x = mouseX;
    float m_y = mouseY;
 
    if(mousePressed && n.drawFrom){
      n.drawFrom = false;
    }
    
    stroke(0);
    
    if(dist(n.x+n.rectWidth,n.y+n.rectHeight/2,m_x,m_y) < n.connectorSize){
      fill(255);
      ellipse(n.x+n.rectWidth,n.y+n.rectHeight/2,n.connectorSize,n.connectorSize);
      if(mousePressed && mouseButton==LEFT){
        n.drawFrom = true;
      }
      if(mousePressed && mouseButton==RIGHT){
// FIXME: make sure the destination        n.connectedTo.connectedFrom = null; // disconnect source from destination
        n.connectedTo = null;  // disconnect our node
      }
    }
    
    if(n.drawFrom){
      stroke(255,255,0);
      line(n.x+n.rectWidth,n.y+n.rectHeight/2,m_x,m_y);
    }
    
    // If we are already connected to something, then draw a line)
    if(n.connectedTo!=null){
      stroke(0,255,0);
      line(n.x+n.rectWidth,n.y+n.rectHeight/2,n.connectedTo.x,n.connectedTo.y+n.connectedTo.rectHeight/2);
    }
     
    stroke(0); 
  }
  
  /*
      If another node is drawing, then potentially
      connect if the mouse connects to a node.
  */
  void connectFrom(nodeLink n){
    float m_x = mouseX;
    float m_y = mouseY;
    
    if(dist(n.x,n.y+n.rectHeight/2,m_x,m_y) < n.connectorSize){
      fill(255);
      ellipse(n.x,n.y+n.rectHeight/2,n.connectorSize,n.connectorSize);
    }
    
    // If we are already connected to something, then draw a line)
    if(n.connectedFrom!=null){
      //line(x,y+rectWidth/2,connectedFrom.x,connectedFrom.y+connectedFrom.rectWidth/2);
    }
  }
  
  /*
      Draw a node and if it is connected to something
      render that line.
      
      Update the
  */
  public void render(nodeLink n){
    
      fill(0,128,192);
      rect(n.x,n.y,n.rectWidth,n.rectHeight);
      fill(0);
      text(n.name,n.x+2,n.y+10);
      if(n.connectedTo!=null){
        text("dest:"+n.connectedTo.name,n.x+2,n.y+30);
      }
      if(n.connectedFrom!=null){
        text("source:"+n.connectedFrom.name,n.x+2,n.y+50);
      }
      
      // If there is a source, update it
      if(n.source){
        fill(0);
        ellipse(n.x+n.rectWidth,n.y+n.rectHeight/2,n.connectorSize,n.connectorSize);
        connectTo(n);
      }
      
      // If there is a receiver, update it
      if(n.receive){
         fill(0);
         ellipse(n.x,n.y+n.rectHeight/2,n.connectorSize,n.connectorSize);
         connectFrom(n);
      }
  }
  
  void drawConnectors(){
  }



  /*
      The purpose of this function is to update all
      of the datalayers in the visualization to render
      according to the encodings we have defined.
  */
  public void updateEncodings(){
      
  }



  /*
    Draw all the nodes
  */
  public void draw(){
     float m_x = mouseX;
     float m_y = mouseY;
     
     if(links!=null){
       background(192);
       fill(255);
       text("Click a source, and then extend to receiver",0,height-15);
       text("Right-click to disconnect",0,height-5);
           /*
             Draw all of the nodes, and make new connections
           */
           for(int i = 0; i < links.size(); ++i){
             render(links.get(i));  // Render all the nodes
             // If we are drawing from a link, and 
             // the mouse is released
             if(links.get(i).drawFrom){
                 // Check to see if we are at at any receivers
                 // If we are, then store that connection
                 for(int j=0; j<links.size(); ++j){
                   float dest_x = links.get(j).x;
                   float dest_y = links.get(j).y+links.get(j).rectHeight/2;
                   float connector_size = links.get(j).connectorSize;
                   if(dist(m_x,m_y,dest_x,dest_y) < connector_size){
                     links.get(i).connectedTo = links.get(j);
                     links.get(j).connectedFrom = links.get(i); 
                     links.get(i).drawFrom = false;
                     break;
                   }
                 }
             } 
           }
     }
     
  }
      
}