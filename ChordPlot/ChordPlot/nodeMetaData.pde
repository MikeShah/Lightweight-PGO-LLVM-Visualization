import java.util.Hashtable;
import java.util.*;


/*
    This class is made use of from ChordNode to store metaData.
*/
class nodeMetaData implements Comparable<nodeMetaData>{
  
  // This arrayList holds all of the locations that the node points to(all of its callees).
  ChordNodeList calleeLocations;
  // This arrayList holds all of the locations of functions that call this specific function.
  ChordNodeList callerLocations;
  
  
  
  String name;
  String extra_information;
  // Values that need to be computed after the data is loaded in
  int callees = 0;
  int max_callees = 0;
  int callers = 0;  // How many functions call this function.
  int max_callers = 0;
  int recursive = 0; // Check to see if function ever calls itself. Note we use 0 or 1 so we can sort.
  int maxNestedLoopCount = 0;
  int bitCodeSize = 0;
  
  String attributes;
  String annotations;  
  String metaData;
  String OpCodes;
  int PGOData;  
  String PerfData;
  String ControlFlowData;
  
  //  LineInformation
  int lineNumber;
  int columnNumber;
  String sourceFile;
  
  String packageName;  // If in Java, store the package name
  
  // Encodings
  float c;  // the color of the node
  boolean stroke_encode=false;
    float strokeValue; // Outline of the node
  boolean blink_encode = false;
    float blink_color = 0;
  boolean symbol_encode = false;
    String symbol = "$"; // Draw a symbol on top of the item of some sort.
  boolean rect_encode = false;  // Draw a smaller rectangle in the middle of another.
    float small_rect_color = 0;
    boolean spin_small_rect = false;
      float spin_rotation = 0;
    
    
    
    
  public nodeMetaData(String name, String extra_information, String attributes, String annotations, String metaData, String OpCodes, int PGOData, String PerfData, String ControlFlowData, int bitCodeSize, int lineNumber, int columnNumber, String sourceFile){
    
    this.name = name;
    this.packageName = name.substring(2,name.indexOf(':'));
    this.extra_information = extra_information;
    this.attributes=attributes;
    this.annotations=annotations;
    this.metaData=metaData;
    this.OpCodes=OpCodes;
    this.PGOData=PGOData;
    this.PerfData=PerfData;
    this.ControlFlowData=ControlFlowData;
    this.bitCodeSize = bitCodeSize;
    
    this.lineNumber = lineNumber;
    this.columnNumber = columnNumber;
    this.sourceFile = sourceFile;
    if(sourceFile==null){
      sourceFile="no/information/available";
    }
    
    c = 0;
    
    calleeLocations = new ChordNodeList();
    callerLocations = new ChordNodeList();
    
    
  }
  
  public nodeMetaData(String name){
    this.name = name;
    this.packageName = name.substring(2,name.indexOf(':'));
    
    c = 0;
    
    calleeLocations = new ChordNodeList();
    callerLocations = new ChordNodeList();
    
    /*
    if(cnl==null){
      calleeLocations = new ChordNodeList();
    }else{
      this.calleeLocations = cnl;
    }
    
    if(callerLocations==null){
      callerLocations = new ChordNodeList();
    }
    
    */
  }

  // Prints all of the metaData to a string.
  public String getAllMetadata(){
    String result = "";
    result += "\nname: "+name + "\n";
    result += "Namespace/Package: "+packageName + "\n";
    result += "Callees: "+callees +"/"+ max_callees + " Callers:" + callers +"/" + max_callers+ " recursive:" + recursive + " maxNestedLoopCount: " + maxNestedLoopCount + "\n";    
    result += "attributes: "+attributes + "\n";
    result += "metaData: "+metaData + "\n";
    result += "OpCodes: "+OpCodes + "\n";
    result += "PGOData: "+PGOData + "\n";
    result += "PerfData: "+PerfData + "\n";
    result += "BitCodeSize: "+bitCodeSize + "\n";
    result += "LineInformation: "+lineNumber + ":" + columnNumber + " " + sourceFile + "\n";
    result += "ControlFlowData: "+ControlFlowData + "\n";
    result += "extra_information: "+extra_information + "\n";
    
    return result;
  }
 
 
   // for 2D
  //
  // mode asks which list to add the point to
  //
  public void addPoint(int mode, float x, float y, String name){
    if(mode<=0){
      calleeLocations.add(new ChordNode(name,x,y,0));
      callees = calleeLocations.size();
      max_callees = max(max_callees,callees);  // Set the maximum (which shouldn't change anyway)
    }else if(mode==1){
      callerLocations.add(new ChordNode(name,x,y,0));
      callers = callerLocations.size();
      max_callers = max(max_callers,callers);  // Set the maximum (which shouldn't change anyway)
    }
  }
  
    // for 2D
  public void addPoint(int mode, float x, float y, String name, nodeMetaData nmd, ChordNodeList cnl){
    if(mode<=0){
      calleeLocations.add(new ChordNode(name,x,y,0, nmd, cnl));
      callees = calleeLocations.size();
      max_callees = max(max_callees,callees);  // Set the maximum (which shouldn't change anyway)
    }else if(mode==1){
      callerLocations.add(new ChordNode(name,x,y,0, nmd, cnl));
      callers = callerLocations.size();
      max_callers = max(max_callers,callers);  // Set the maximum (which shouldn't change anyway)
    }
  }
  
  // For 3D
  public void addPoint(int mode, float x, float y, float z, String name){
    if(mode<=0){
      calleeLocations.add(new ChordNode(name,x,y,z));
      callees = calleeLocations.size();
      max_callees = max(max_callees,callees);  // Set the maximum (which shouldn't change anyway)
    }else if(mode==1){
      callerLocations.add(new ChordNode(name,x,y,z));
      callers = callerLocations.size();
      max_callers = max(max_callers,callers);  // Set the maximum (which shouldn't change anyway)
    }
  }
 
 
  // Copies in the metadata from another node into this one.
  // Generally this is used for making new instances (i.e. we need a copy constructor)
  // 
  public void copyMetaData(nodeMetaData n){
    n.name              = this.name;
    n.extra_information = this.extra_information;
    n.callees           = this.callees;
    n.c                 = this.c;  // the color of the node
  }
 
  public int compareTo(nodeMetaData other){
    /*
    if (this.name < other.name || this.name == other.name) {
      return -1;
    }else{
      return this.name == other.name ? 0 : 1;
    }
    */
      return name.compareTo(other.name);
  }
  
  // Use the name of the node as the hashcode
  @Override
  public int hashCode(){
    return name.hashCode();
  }
  
  // Test for string equality. This maintains 3 properties: reflexive, symmetric, and transitivity.
  @Override
  public boolean equals(Object obj){

    if(this==obj){
      return true;
    }
    if(obj==null){
      return false;
    }
    if(!(obj instanceof nodeMetaData)){
      return false;
    }
    nodeMetaData temp = (nodeMetaData)obj;
    return (temp.name.equals(this.name));
  }
  
  
} // ends class nodeMetaData implements Comparable<nodeMetaData>{