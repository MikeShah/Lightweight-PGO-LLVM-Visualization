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