class ChildApplet extends PApplet {
  
  // Used to pass and send data
  DataString dataString;
  


  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    dataString = new DataString();
    dataString.setText("Data");
  }

  public void settings() {
    size(400, 400, P3D);
    smooth();
  }
  public void setup() { 
    surface.setTitle("Data View");
  }

  public void draw() {
    background(0);
    
    int xSize = width;
    int ySize = height;
    
    stroke(192,255);
    fill(0,255);
    rect(0,0,xSize,ySize);
    fill(255,0,0,255);
    text(dataString.getString(), 0,0, xSize, ySize);
  }
  
  // 
  void setDataString(String s){
    dataString.setText(s);
  }
  
  
}