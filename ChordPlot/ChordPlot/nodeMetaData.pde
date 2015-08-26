import java.util.Hashtable;
import java.util.*;


/*
    This class is made use of from ChordNode to store metaData.
*/
class nodeMetaData implements Comparable<nodeMetaData>{
  
  String name;
  String extra_information;
  int callees = 0;
  float c;  // the color of the node
  
  String attributes;
  String metaData;
  String OpCodes;
  String PGOData;
  String PerfData;
    
  public nodeMetaData(String name, String extra_information){
    this.name = name;
    this.extra_information = extra_information;
    c = 0;
  }
  
  public nodeMetaData(String name){
    this.name = name;
    this.extra_information = "n/a";
    c = 0;
  }
  
  // Prints all of the metaData to a string.
  public String getAllMetadata(){
    String result = "";
    result += "\nname: "+name + "\n";
    result += "Callees: "+callees + "\n";
    result += "info: "+extra_information + "\n";
    
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