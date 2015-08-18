/*
  The purpose of this class is to contain a list of chords.
  
  There are also other conveience functions attached.
*/
class ChordNodeList{
  
  // Backbone data structure for working with a list of Chord Nodes
  ArrayList<ChordNode> chordList;
  
  public ChordNodeList(){
     chordList = new ArrayList<ChordNode>(); 
  }
  
  /*
      Retrieve an element at the index of the chordList
  */
  public ChordNode get(int index){
    return chordList.get(index);
  }
  
  /*
      Add an element at the end of the chordList
  */
  public void add(ChordNode element){
    chordList.add(element);
  }
  
}