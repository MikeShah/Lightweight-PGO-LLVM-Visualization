
ChordDiagram cd;

void setup(){
  size(900 , 900,P3D);
  
  
  
  cd = new ChordDiagram(400, "output.dot",1);    
}




void draw(){
   background(192);
   cd.draw();
}

int keyIndex = 0;
// Determine how deep in the tree we go.
void keyPressed() {
  
  if (key >= '0' && key <= '9') {
    keyIndex = key - '0';
    println(key-'0');
    cd.regenerateLayout(keyIndex);
  } else if (key >= 'a' && key <= 'z') {
    keyIndex = key - '0';
    println(key-'0');
  }

}