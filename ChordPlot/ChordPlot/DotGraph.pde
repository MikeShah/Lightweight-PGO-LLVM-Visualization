/*
  Class for loading DotGraphs

*/
import java.util.*;
import java.io.*;
import java.util.concurrent.*;


/*
  This class loads a DOT Graph file and populates a node list
*/
class DotGraph{
  
  // Contains a hashmap that consits of: 
  // key -- The source node, which is a String
  // value -- The Destination nodes this source points to, which is an arraylist.
  public ConcurrentHashMap<nodeMetaData,LinkedHashSet<nodeMetaData>> graph = new ConcurrentHashMap<nodeMetaData,LinkedHashSet<nodeMetaData>>();
  // Contains a list of all of the nodes (sources and destinations)
  // Can be useful if we need to populate all nodes in a visualization
  //
  // Note, I had to make this Concurrent so things do not crash :)
  public ConcurrentHashMap<String,nodeMetaData> fullNodeList = new ConcurrentHashMap<String,nodeMetaData>();
  int totalSources = 0;
  
  /* 
    Dot Graph Parser
  */
  public DotGraph(String file){
    //simpleDot(file);
    println("DotGraph Constructor");
    readStructDOT(file);
  }
  
  

  
  
  /*
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
  */
  
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
    line = line.replace(";"," ");
    line = line.replace("]"," ");
    line = line.trim(); //Get rid of tabs
    
    // Find out what our function name is
    int funNameStart = line.indexOf("\"", 1);
    // 
    String functionName = line.substring(0, funNameStart+1);
    
    int labelStart = line.indexOf("label=");
    String restOfLine = line.substring(labelStart,line.length());
    String attributes = "";
    String annotations = "";
    String metaData = "";
    String OpCodes = "";
    int PGOData = -1;
    String PerfData = ""; 
    String ControlFlowData = "";
    int bitCodeSize = 0;
    
    int lineNumber=1;
    int columnNumber=1;
    String sourceFile="no/file/information";
    
    // Parse the data
    // Unfortunately this is going to work as a state machine
    // Perhpas JSON is a better data format for these kinds of things.
    boolean read_attributes = false;    boolean read_annotations = false;    boolean read_metaData = false;
    boolean read_OpCodes = false;       boolean read_PGOData = false;        boolean read_PerfData = false;
    boolean read_ControlFlowData = false; boolean read_bitCodeSize = false;  boolean read_LineInformation = false;
    
    String[] tokens = restOfLine.split(" ");
    for(int i =0; i < tokens.length; ++i){
      
        if(tokens[i].equals("Attributes")){
            read_attributes = true;        read_annotations = false;    read_metaData = false;
            read_OpCodes = false;          read_PGOData = false;        read_PerfData = false;
            read_ControlFlowData = false;  read_bitCodeSize = false;    read_LineInformation = false;
            continue; // move on to the next token once we've changed state
        }else if(tokens[i].equals("Annotations")){
            read_attributes = false;       read_annotations = true;    read_metaData = false;
            read_OpCodes = false;          read_PGOData = false;       read_PerfData = false;
            read_ControlFlowData = false;  read_bitCodeSize = false;   read_LineInformation = false;
            continue; // move on to the next token once we've changed state
        }
        else if(tokens[i].equals("Metadata")){
            read_attributes = false;       read_annotations = false;    read_metaData = true;
            read_OpCodes = false;          read_PGOData = false;        read_PerfData = false;
            read_ControlFlowData = false;  read_bitCodeSize = false;    read_LineInformation = false;
            continue; // move on to the next token once we've changed state
        }
        else if(tokens[i].equals("Opcodes")){
            read_attributes = false;       read_annotations = false;     read_metaData = false;
            read_OpCodes = true;           read_PGOData = false;         read_PerfData = false;
            read_ControlFlowData = false;  read_bitCodeSize = false;     read_LineInformation = false;
            continue; // move on to the next token once we've changed state
        }
        
        else if(tokens[i].equals("PGOData")){
            read_attributes = false;       read_annotations = false;    read_metaData = false;
            read_OpCodes = false;          read_PGOData = true;         read_PerfData = false;
            read_ControlFlowData = false;  read_bitCodeSize = false;    read_LineInformation = false;
            continue; // move on to the next token once we've changed state
        }
        else if(tokens[i].equals("PerfData")){
            read_attributes = false;       read_annotations = false;    read_metaData = false;
            read_OpCodes = false;          read_PGOData = false;        read_PerfData = true;
            read_ControlFlowData = false;  read_bitCodeSize = false;    read_LineInformation = false;
            continue; // move on to the next token once we've changed state
        }
        else if(tokens[i].equals("ControlFlowData")){
            read_attributes = false;      read_annotations = false;    read_metaData = false;
            read_OpCodes = false;         read_PGOData = false;        read_PerfData = false;
            read_ControlFlowData = true;  read_bitCodeSize = false;    read_LineInformation = false;
            continue; // move on to the next token once we've changed state
        }
        else if(tokens[i].equals("BitCodeSize")){
            read_attributes = false;      read_annotations = false;    read_metaData = false;
            read_OpCodes = false;         read_PGOData = false;        read_PerfData = false;
            read_ControlFlowData = false; read_bitCodeSize = true;     read_LineInformation = false;
            continue; // move on to the next token once we've changed state
        }
        else if(tokens[i].equals("LineInformation")){
            read_attributes = false;      read_annotations = false;    read_metaData = false;
            read_OpCodes = false;         read_PGOData = false;        read_PerfData = false;
            read_ControlFlowData = false; read_bitCodeSize = false;    read_LineInformation = true;
            continue; // move on to the next token once we've changed state
        }
        
        // Clean up tokens[i]
        // Just ignore empty space
        if( tokens[i].equals(" ") || tokens[i].equals("\t") ){
          continue;
        }
        
        // Append to the appropriate field
        if(read_attributes){
          attributes += tokens[i];
        }
        else if(read_annotations){
          annotations += tokens[i];
        }
        else if(read_metaData){
          metaData += tokens[i];
        }
        else if(read_OpCodes){
          OpCodes += tokens[i];
        }
        if(read_PGOData){
          // PGOData += tokens[i]; // FIXME: PGO data is currently read from metadata, this should really be taken care of in the C++ pass.
        }
        else if(read_PerfData){
          PerfData += tokens[i];
        }
        else if(read_ControlFlowData){
          ControlFlowData += tokens[i];
        }
        else if(read_bitCodeSize){
          tokens[i] = tokens[i].replace("\"","");
          if(!tokens[i].equals("")){
              tokens[i] = tokens[i].trim();
              bitCodeSize = Integer.parseInt(tokens[i]);
          }
        }
        else if(read_LineInformation){
            //  LineInformation
            //println("reading in: "+tokens[i]);
            lineNumber = Integer.parseInt(tokens[i]);
            // Column Information
            if(i<tokens.length){++i;}
            //println("reading in: "+tokens[i]);
            columnNumber = Integer.parseInt(tokens[i]);
            // Source code information
            if(i<tokens.length){++i;}
            //println("reading in: "+tokens[i]);
            sourceFile = tokens[i];
            //println("Did I work?");
            break;
        }
    }
        
    nodeMetaData src = new nodeMetaData(functionName,restOfLine, attributes,annotations,metaData,OpCodes,PGOData,PerfData,ControlFlowData,bitCodeSize,lineNumber,columnNumber,sourceFile);
    
    return src;
  }
  
  
  /*
    Read a DOT file where node=struct is the default.
  */
  synchronized public void readStructDOT(String file){
    println("readStructDOT");
    println("Something is blowing up here");
      String[] lines = loadStrings(file);   
      // Do one iteration through the list to build the nodes
      println("read in file with "+lines.length+" lines");
        for(String s: lines){
            // Build up all of the sources first
            // For every node we need to add it in our graph
            if(s.contains("shape=record") && !s.equals("node [shape=record];")){
              nodeMetaData md = processStruct(s);
            
              fullNodeList.put(md.name, md);
            }
        }
      
      println("made it to here in readStructDOT");
      
      // Do a second iteration through the lines to build the relationship(src->dst i.e. caller and callees)
      for(String line: lines){
        // Read in a line
        // Find that node in our fullNodeList
        // Add to its destinations
        if (line.contains("->")){
            // Split the line, parse it, and retrieve our
            // source and destination nodes.
            String[] tokens = line.split(" ");
            
            // Create temporary nodes with the ones we found
            nodeMetaData src = (nodeMetaData)fullNodeList.get(tokens[0]);
            nodeMetaData dst = (nodeMetaData)fullNodeList.get(tokens[2]);
                             
            // Store the relationship between the source and destination
            // These locations will be set later on in layout algorithms,
            // but now we don't have to worry about computing this graph
            // feature.
            src.addPoint(0,0,0,0,dst.name);
            dst.addPoint(1,0,0,0,src.name);
            
            if(src.name.equals(dst.name)){
              src.recursive = 1;
              dst.recursive = 1;
            }
            
            // If the function exists, then add a new destination
            if(graph.containsKey(src)){
              LinkedHashSet<nodeMetaData> temp = (LinkedHashSet<nodeMetaData>)(graph.get(src));
              temp.add(dst);
              graph.put(src,temp);
            }else{
              // Create a new node
              // Store the relationship between the source and destination
              // These locations will be set later on in layout algorithms,
              // but now we don't have to worry about computing this graph
              // feature.
              src.addPoint(0,0,0,0,dst.name);
              dst.addPoint(1,0,0,0,src.name);
            
              LinkedHashSet<nodeMetaData> incidentEdges = new LinkedHashSet<nodeMetaData>();
              incidentEdges.add(dst);
              graph.put(src,incidentEdges);
              totalSources++;
            }
          
        } // if (lines[i].contains("->"))
      } // for(int i =0; i < lines.length; i++)
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