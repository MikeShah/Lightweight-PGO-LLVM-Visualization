import java.util.Hashtable;
import java.util.*;


/*
    This class is made use of from ChordNode to store metaData.
*/
class nodeMetaData implements Comparable<nodeMetaData>{
  
  String name;
  String extra_information;
  // Values that need to be computed after the data is loaded in
  int callees = 0;
  int calleInto = 0;  // How many functions call this function.
  boolean recursive = false; // Check to see if function ever calls itself
  int maxNestedLoopCount = 0;
  int bitCodeSize = 0;
  
  float c;  // the color of the node
  
  String attributes;
  String annotations;
  String metaData;
  String OpCodes;
  String PGOData;
  String PerfData;
  String ControlFlowData;
    
  public nodeMetaData(String name, String extra_information, String attributes, String annotations, String metaData, String OpCodes, String PGOData, String PerfData, String ControlFlowData, int bitCodeSize){
    this.name = name;
    this.extra_information = extra_information;
    this.attributes=attributes;
    this.annotations=annotations;
    this.metaData=metaData;
    this.OpCodes=OpCodes;
    this.PGOData=PGOData;
    this.PerfData=PerfData;
    this.ControlFlowData=ControlFlowData;
    this.bitCodeSize = bitCodeSize;
    
    c = 0;
  }
  
  public nodeMetaData(String name){
    this.name = name;
    c = 0;
  }
  
  // Prints all of the metaData to a string.
  public String getAllMetadata(){
    String result = "";
    result += "\nname: "+name + "\n";
    result += "Callees: "+callees + "\n";
    result += "attributes: "+attributes + "\n";
    result += "metaData: "+metaData + "\n";
    result += "OpCodes: "+OpCodes + "\n";
    result += "PGOData: "+PGOData + "\n";
    result += "PerfData: "+PerfData + "\n";
    result += "ControlFlowData: "+ControlFlowData + "\n";
    result += "BitCodeSize: "+bitCodeSize + "\n";
    result += "extra_information: "+extra_information + "\n";
    
    return result;
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