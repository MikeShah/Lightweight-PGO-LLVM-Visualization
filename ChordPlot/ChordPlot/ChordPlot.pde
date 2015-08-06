
ChordDiagram cd;

void setup(){
  size(800 , 800);
  
  
  
  cd = new ChordDiagram("moredata.dot");
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
  } else if (key >= 'a' && key <= 'z') {
    keyIndex = key - '0';
    println(key-'0');
  }

}