
// Node class consits of a source
class ChordNode{
  float x;
  float y;
  float z;
  
  // Special x,y for the force-directed graph window
  float fdg_x;
  float fdg_y;
  
  
  public nodeMetaData metaData;
  int nodeSize = 3; // needed if we are rendering 2D circles or spheres
    
  float rectWidth  = 0; // needed if we are rendering 2D rectangular shapes (Such as when we render histogram)
  float rectHeight = 0; // needed if we are rendering 2D rectangular shapes (Such as when we render histogram)

  int bucket = 0;      // If we are clustering the nodes together, figure out which bucket they should be put in.

  // Selecting nodes
  boolean selected = false; // By default, we show everything, so we render all nodes
  // Color of the node when it is selected.
  int r = 0;
  int g = 255;
  int b = 0;
  
  // Highlighted
  boolean highlighted = false; // By default, nodes are not highlighted. This is the same as selection, but does not show the call sites
  
  /*
      The most default constructor that will be used
  */
  public ChordNode(String name, float x, float y, float z){
    this.metaData = new nodeMetaData(name);
    this.x = x;
    this.y = y;
    this.z = z;
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
  }
  
  void getMetaData(nodeMetaData n){
    metaData.copyMetaData(metaData);
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
          //render3D(); // DEPRECATED: Handling 3D rendering is not supported right now.
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
              if(selected) { fill(r,g,b); }
              ellipse(x,y,nodeSize*2,nodeSize*2);
              
              // Fill in the nodes color
              fill(r,g,b);
              
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
              fill  (255-metaData.c,255-metaData.c,255-metaData.c);
              stroke(255-metaData.c,255-metaData.c,255-metaData.c);
              ellipse(x,y,nodeSize*2,nodeSize*2);
          }
     }
  }
  
  
/*  
  // Imlements selection and onHover for 3D spheres
  private void render3D(){
     if( dist(x,y,0,MySimpleCamera.xSelection,MySimpleCamera.ySelection,0) < nodeSize || selected){
        fill(0);
        if(selected){fill(r,g,b);}
        
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
        fill(255-metaData.c,255-metaData.c,255-metaData.c);
        pushMatrix();
        translate(x,y,z);
          sphere(nodeSize);
        popMatrix();
     }
  }
*/

  /*
      Bring up information about the node.
      
      Attempt to fit box to the screen. Note this behavior may be confusing
  */
  public void onRightClick(){
     if(mouseButton == RIGHT){
       float _w = 500;
       float _h = 300;
       float padding = 5;
       
       // Find the mouse position and move text box so that it always fits on the screen
       float display_x = x;
       float display_y = y;
       
       if(mouseX + _w > width){
         display_x -= ((mouseX+_w)-width);
       }
       if(mouseY + _h > height){
         display_y -= ((mouseY+_h)-height);
       }
       
       
       pushMatrix();
         translate(0,0,MySimpleCamera.cameraZ+20);
         fill(192,192);
         rect(display_x,display_y,_w,_h);
         fill(0,255);
         text("MetaData: "+metaData.getAllMetadata(),display_x+padding,display_y+padding,_w-padding,_h-padding);
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
                 if (selected) {fill(r,g,b);}  // Provide feedback if we're hovering over a selected node.
                 rect(x,y,metaData.name.length()*8,20);
                 fill(0,255);
                 text(metaData.name,x,y+10);
               popMatrix();
            }
            
            if(keyPressed){
                if (key == 's'){
                  cd.select(this,true);
                }else if(key == 'e'){
                  cd.select(this,false);
                }
                else if(key == 'a'){
                  // Select this node and all of its callees up to the callee depth
                  cd.selectCallees(this,true,CalleeDepth);
                }
                else if(key == 'b'){
                  // Select this node and all of its callers up to the selection depth
                  cd.selectCallers(this,true,CalleeDepth);
                }
                else if(key=='o'){
                  String[] params = {"gnome-terminal", "-e","/usr/bin/vim +"+metaData.lineNumber+" "+metaData.sourceFile};

                  // nodeMetaData.columnNumber; // TODO: Open to the appropriate column number 
               
                   // Create a delay so we don't open too many editors. This might need to be tweaked a bit.
                   int time = millis();
                   int delay = 1500;
                   // Loop that stalls the program so we don't click too many times
                   while(millis() - time <= delay){}
                   if(metaData.sourceFile!=null){
                     exec(params);
                   }
                }
                else if(key=='p'){
                  String find = metaData.name.replace("\"","");
                  String[] params = {"gnome-terminal", "-e","/usr/bin/vim +/"+find+" "+llbitcodefile};

                  // nodeMetaData.columnNumber; // TODO: Open to the appropriate column number 
               
                   // Create a delay so we don't open too many editors. This might need to be tweaked a bit.
                   int time = millis();
                   int delay = 1500;
                   // Loop that stalls the program so we don't click too many times
                   while(millis() - time <= delay){}
                   if(metaData.sourceFile!=null){
                     exec(params);
                   }
                }
            }
        }
    
        // If our node is selected, then highlight it a new color
        if( selected || (mouseX > x && MySimpleCamera.xSelection < (x+rectWidth) && MySimpleCamera.ySelection < y && MySimpleCamera.ySelection > (y-rectHeight))){ 
            fill(0);
            stroke(255);
            if(selected){ stroke(255,0,0); fill(r,g,b); }
            
            rect(x,y-rectHeight,rectWidth,rectHeight);
            pushMatrix();
              translate(0,0,MySimpleCamera.cameraZ+1);  // Translate forward
              
              if(keyPressed && key=='c'){
                drawToCallers(CalleeDepth);
              }else{
                drawToCallees(CalleeDepth);
              }
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
            fill(255-metaData.c,255-metaData.c,255-metaData.c);
            stroke(255-metaData.strokeValue);
            rect(x,y-rectHeight,rectWidth,rectHeight);
         }
         
         
      // Apply our encodings to the visualization
      applyEncodings();
         
  }
  
  
  public void applyEncodings(){
    
   if(metaData.stroke_encode){
     
   } 
    
   if(metaData.symbol_encode){
       // Apply Encodings
       fill(metaData.c,0,0);
       stroke(metaData.c,0,0);
       textSize(rectHeight);
       text(metaData.symbol,x,y);
       textSize(12);
   }
   
   if(metaData.rect_encode){
       fill(metaData.small_rect_color); stroke(255-metaData.small_rect_color);
       float halfWidth = rectWidth/2;
       float halfHeight = rectHeight/2;
        
       pushMatrix();
       if(metaData.spin_small_rect){
         rectMode(CENTER);  // Set rectMode to CENTER
         translate(x+halfWidth,y-halfWidth);
         rotate(radians(metaData.spin_rotation));
         rect(0,0,halfWidth,halfHeight);
         rectMode(CORNER);  // Set rectMode to CENTER
         metaData.spin_rotation++;
       }
       else{
         rect(x+halfWidth/2,y-halfWidth*1.5,halfWidth,halfHeight);
       }   
       popMatrix();
   }
   

   
   
   

  }
  
  /*
    Highlight a node in blue.
    
    This is used in drawToCallees to distinguish items.
  */
  public void drawOutline(float xMark, float yMark){          
      fill(r,g,b); stroke(0,0,255);
      strokeWeight(4);  // Thicker
      line(xMark, yMark, xMark, yMark-rectWidth);
      line(xMark+rectWidth, yMark, xMark+rectWidth, yMark-rectWidth);
      line(xMark, yMark, xMark+rectWidth, yMark);
      line(xMark, yMark-rectHeight, xMark+rectWidth, yMark-rectHeight);
      strokeWeight(1);  // Default
  }
  
  // Draw to all of the callee locations in 2D
  // Note that we are drawing exclusively to the secondGraphicsLayer here.
  // The depth is how many levels in the tree to draw to callees (essentially do a BFS).
  //
  // If 'h' is pressed, then hide the lines and only draw the rectangles.
  public void drawToCallees(int depth){
      
        if(keyPressed && key == 'h'){
            fill(0); stroke(0);
            for(int i =0; i < metaData.calleeLocations.size();i++){
              if(depth>0){
                  drawOutline(metaData.calleeLocations.get(i).x, metaData.calleeLocations.get(i).y);
                  //rect(LocationPoints.get(i).x,LocationPoints.get(i).y-rectHeight,rectWidth,rectHeight);
                  ChordNode blah = metaData.calleeLocations.get(i);
                  blah.drawToCallees(depth-1);     
               }
            }
        }else{
            fill(0); stroke(0);
            for(int i =0; i < metaData.calleeLocations.size();i++){
              if(depth>0){
                  noFill(); stroke(0);
                  rect(metaData.calleeLocations.get(i).x,metaData.calleeLocations.get(i).y-rectHeight,rectWidth,rectHeight);
                  pushMatrix();
                    translate(0,0,MySimpleCamera.cameraZ+10);
                    fill(0); stroke(0);
                    // TODO: FIXME: calleeLocations does not currently store rectWidth, only the position. So in the future
                    // we will have a problem if we have nodes that are not all square shaped. Remember, we are in Java land, in C++ this would be easy to fix...
                    line(x+rectWidth/2,y-rectHeight/2,metaData.calleeLocations.get(i).x+rectWidth/2,metaData.calleeLocations.get(i).y-rectHeight/2);
                  popMatrix();
                  ChordNode blah = metaData.calleeLocations.get(i);
                  blah.drawToCallees(depth-1);     
                }
            }
        }
  }
  
  
  // Draw to all of the caller locations in 2D

  // The depth is how many levels in the tree to draw to callees (essentially do a BFS).
  //
  // If 'h' is pressed, then hide the lines and only draw the rectangles.
  public void drawToCallers(int depth){
      
        if(keyPressed && key == 'h'){
            fill(0); stroke(0);
            for(int i =0; i < metaData.callerLocations.size();i++){
              if(depth>0){
                  drawOutline(metaData.callerLocations.get(i).x, metaData.callerLocations.get(i).y);
                  ChordNode blah = metaData.callerLocations.get(i);
                  blah.drawToCallers(depth-1);     
               }
            }
        }else{
            fill(0); stroke(0);
            for(int i =0; i < metaData.callerLocations.size();i++){
              if(depth>0){
                  noFill(); stroke(0);
                  rect(metaData.callerLocations.get(i).x,metaData.callerLocations.get(i).y-rectHeight,rectWidth,rectHeight);
                  pushMatrix();
                    translate(0,0,MySimpleCamera.cameraZ+10);
                    fill(255,0,0); stroke(255,0,0);
                    // TODO: FIXME: calleeLocations does not currently store rectWidth, only the position. So in the future
                    // we will have a problem if we have nodes that are not all square shaped. Remember, we are in Java land, in C++ this would be easy to fix...
                    strokeWeight(2);
                    line(x+rectWidth/2,y-rectHeight/2,metaData.callerLocations.get(i).x+rectWidth/2,metaData.callerLocations.get(i).y-rectHeight/2);
                    strokeWeight(1);
                  popMatrix();
                  ChordNode blah = metaData.callerLocations.get(i);
                  blah.drawToCallers(depth-1);     
                }
            }
        }
  }
  
  /*
  // Draw to all of the callee locations in 3D
  public void drawTo3DCallees(int depth){
    fill(255,0,0);
    for(int i =0; i < metaData.calleeLocations.size();i++){
      line(+rectWidth/2,y-rectHeight/2,z,metaData.calleeLocations.get(i).x,metaData.calleeLocations.get(i).y,metaData.calleeLocations.get(i).z);
    }
  }
  */
  
  
  /*
      Return information about a ChordNode
  */
  public String debug(){
    return "(x,y,z)=> (" + x + "," + y + "," + z + ")" + " name; "+metaData.name + "callees: "+metaData.callees;
  }
  
  /*
      Debug function that shows what information is in the node
      
      Useful to see what is being pushed
  */
  public String printAll(){
        String result = "(x,y,z)=> (" + x + "," + y + "," + z + ")" + metaData.getAllMetadata();
        return result;
  }
  
    
}