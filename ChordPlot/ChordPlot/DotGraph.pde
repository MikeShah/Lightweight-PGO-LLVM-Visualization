/*
  Class for loading DotGraphs

*/
import java.util.Hashtable;
import java.util.*;

class nodeMetaData implements Comparable<nodeMetaData>{
  
  String name;
  public nodeMetaData(String name){
    this.name = name;
  }
  
  public int compareTo(nodeMetaData d){
    if(d.name == this.name){
      return 1;
    }
    return 0;    
  }
  
  // Use the name of the node as the hashcode
  @Override
  public int hashCode(){
    return name.hashCode();
  }
  
  // Test for string equality. This maintains 3 properties: reflexive, symmetric, and transitivity.
  @Override
  public boolean equals(Object obj){
    if(!(obj instanceof nodeMetaData)){
      return false;
    }
    nodeMetaData temp = (nodeMetaData)obj;
    return (temp.name == this.name);
  }
  
  
} // ends class nodeMetaData implements Comparable<nodeMetaData>{



class DotGraph{
  
  // Contains a hashmap that consits of: 
  // key -- The source node, which is a String
  // value -- The Destination nodes this source points to, which is an arraylist.
  public Map<nodeMetaData,ArrayList> graph = new Hashtable<nodeMetaData,ArrayList>();
  // Contains a list of all of the nodes (sources and destinations)
  // Can be useful if we need to populate all nodes in a visualization
  public SortedSet<nodeMetaData> fullNodeList = new TreeSet<nodeMetaData>();
  int totalSources = 0;
  
  public DotGraph(String file){
    String[] lines = loadStrings(file);
    
    for(int i =0; i < lines.length; i++){
      if (lines[i].contains("->")){
        // This is a lazy way of splitting a dot graph
        // assuming there are spaces and an arrow, and no extra data
        String[] tokens = lines[i].split(" ");
        
        nodeMetaData src = new nodeMetaData(tokens[0]);
        nodeMetaData dst = new nodeMetaData(tokens[2]);
        // Lazily attempt to add everything to our set
        // DataStructure is a Set, thus guareenteeing only one unique copy
        fullNodeList.add(src);
        fullNodeList.add(dst);
        
        // If the function exists, then add a new destination
        if(graph.containsKey(src)){
          ArrayList temp = (ArrayList)(graph.get(src));
          temp.add(dst);
          graph.put(src,temp);
        }else{
          // Create a new node
          ArrayList incidentEdges = new ArrayList();
          incidentEdges.add(dst);
          graph.put(src,incidentEdges);
          totalSources++;
        }
                
      }
    }
  }
  
  public void printGraph(){
    
    Set<nodeMetaData> keys = graph.keySet();
    for(nodeMetaData aKey: keys){
      println(aKey.name + " -> " + graph.get(aKey));
    }
  }
  
  /*
  @Override
  public Iterator<nodeMetaData> iterator(){
    return fullNodeList.iterator();
  }
  */
  
}