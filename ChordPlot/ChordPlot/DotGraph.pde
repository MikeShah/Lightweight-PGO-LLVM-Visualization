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
  
  /* 
    Dot Graph Parser
  */
  public DotGraph(String file){
    simpleDot(file);
  }
  
  // Simple Parser
  public void simpleDot(String file){
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
          // DataStructure is a Set, thus guaranteeing only one unique copy
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
      Build a ChordNode from the node
  */
  public nodeMetaData processStruct(String line){
    //"_ZL10crc32_byteh"[shape=record,label="_ZL10crc32_byteh|{Attributes|zeroext}|{Metadata}|{Annotations}|{PGO Data}|{Perf Data}|{Opcodes|alloca 1|and 2|call 1|getelementptr 1|load 4|lshr 1|ret 1|store 2|xor 2|zext 2}|"];
    // Replace the delimiters with spaces and then we can easily split the line
    // Once the line is split, we can populate the metaData
    line = line.replace("|"," ");
    line = line.replace("{"," ");
    line = line.replace("}"," ");
  }
  
  
  /*
    Read a DOT file where node=struct is the default.
  */
  public void readStructDot(String file){
      String[] lines = loadStrings(file);   
      
      for(int i =0; i < lines.length; i++){
        // Build up all of the sources first
        if(lines[i].contains("shape=record")){
          nodeMetaData src = processStruct(lines[i]);
          fullNodeList.add(src);
          //"_ZL10crc32_byteh"[shape=record,label="_ZL10crc32_byteh|{Attributes|zeroext}|{Metadata}|{Annotations}|{PGO Data}|{Perf Data}|{Opcodes|alloca 1|and 2|call 1|getelementptr 1|load 4|lshr 1|ret 1|store 2|xor 2|zext 2}|"];
        }
        // Read in a line
        // Find that node in our fullNodeList
        // Add to its destinations
        if (lines[i].contains("->")){
          
        }
        
        //
        // TODO: Callers and callees should be able to be calculated from here I think 
        //
        
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