/*
  The purpose of this class is to contain a list of chords.
  
  There are also other conveience functions attached.
*/
class ChordNodeList{
  
  // Backbone data structure for working with a list of Chord Nodes
  // Note that in order to avoid ConcurrentModifcationException, we make a CopyOnWriteArrayList.
  // This use to be a regular ArrayList, but since we are passing lists around so often, we had to be
  // extra safe and make sure it is thread-safe.
  CopyOnWriteArrayList<ChordNode> chordList;
  
  // The name of the ChordNode List if we want to identify how to work with it.
  public String name = "Dataset";
  
  public ChordNodeList(){
     chordList = new CopyOnWriteArrayList<ChordNode>(); 
  }
  
  public ChordNodeList(String name){
     chordList = new CopyOnWriteArrayList<ChordNode>();
     this.name = name;    
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
  
  /*
      Clear all of the elements
  */
  public void clear(){
    chordList.clear();
  }
  
  /*
      Return the size of our ChordNode List
  */
  public int size(){
    return chordList.size();
  }
  
  /*
      Simple sorting function which takes advantage of the ArrayList
  */
  public void sortNodes(){
    Collections.sort(chordList, new Comparator<ChordNode>(){
      @Override
      public int compare(ChordNode item1, ChordNode item2){
          Integer val1 = item1.metaData.callees;
          Integer val2 = item2.metaData.callees;
          
          // Descending order (reverse comare to do ascending order)
          return val2.compareTo(val1);
          //return item1.metaData.name.compareTo(item2.metaData.name); // uncomment this to sort based on 'string' value
      }
    });
  }
  
}