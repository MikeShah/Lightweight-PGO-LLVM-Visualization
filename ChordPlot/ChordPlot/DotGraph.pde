/*
  Class for loading DotGraphs

*/
import java.util.Hashtable;
import java.util.*;
import java.io.*;


/*

  This class loads a DOT Graph file and populates a node list

*/
class DotGraph{
  
  // Contains a hashmap that consits of: 
  // key -- The source node, which is a String
  // value -- The Destination nodes this source points to, which is an arraylist.
  public Map<nodeMetaData,LinkedHashSet<nodeMetaData>> graph = new Hashtable<nodeMetaData,LinkedHashSet<nodeMetaData>>();
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
        
        // Add nodes with associated meta-data
        nodeMetaData src = new nodeMetaData(tokens[0],tokens[3]);
        nodeMetaData dst = new nodeMetaData(tokens[2],tokens[3]);
        // Lazily attempt to add everything to our set
        // DataStructure is a Set, thus guareenteeing only one unique copy
        fullNodeList.add(src);
        fullNodeList.add(dst);
        
        // If the function exists, then add a new destination
        if(graph.containsKey(src)){
          LinkedHashSet<nodeMetaData> temp = (LinkedHashSet<nodeMetaData>)(graph.get(src));
          temp.add(dst);
          graph.put(src,temp);
        }else{
          // Create a new node
          LinkedHashSet<nodeMetaData> incidentEdges = new LinkedHashSet<nodeMetaData>();
          incidentEdges.add(dst);
          graph.put(src,incidentEdges);
          totalSources++;
        }
                
      }
    }
  }
  
  /*
      Process a single line of data when we read it in.
  */
  public void processLine(String line){
      println("");
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