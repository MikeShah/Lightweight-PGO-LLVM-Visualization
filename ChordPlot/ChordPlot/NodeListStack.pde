/*
    This data structure is a stack.
    The elements of the stack are of the type ''
    
    We can push and pop items off of the stack
*/
public class NodeListStack{
  
  // The all important stack
  Deque<ChordNodeList> stack;
  
  // Store statistics about the data 
  // Note that these statistics are always in reference to
  // the top node of the stack.
  // Anytime we push or pop, we need to recompute the summary statistics
  public SummaryStatistics summaryStatistics;
  
   // Store the total elements that are at the first level
   // This is conveinient so we can see how much data we have filtered out.
   int bottomOfStackCallers = 0; 
   int bottomOfStackCallees = 0;
  
  /*
      Default Constructor
  */
  public NodeListStack(){
    // Instantiate our stack
    stack = new ArrayDeque<ChordNodeList>();
    // Instantiate summary statistics
    summaryStatistics = new SummaryStatistics();
  }
  
  public int size(){
    return stack.size();
  }
 
  
  /*
    Add on a new filter
    Then compute summary Statistics
  */
  public void push(ChordNodeList activeNodeList){
    stack.push(activeNodeList);
    computeSummaryStatistics();
  }
  
  /*
    Remove our last filter
    Then compute summary statistics
    
    // Notice that this does not work like a traditional stack
    // We never want our stack to be empty.
  */
  public ChordNodeList pop(){
    
    if(stack.size()>1){
      computeSummaryStatistics();
      return stack.pop();
    }
    
    return null;
  }
  
  /*
    Peek at the top of our stack
  */
  public ChordNodeList peek(){
    if(stack.size() >0){
      return (ChordNodeList)stack.peek();
    }else
    {
      return null;
    }
  }
  
  // Update the summary statistics based on the active nodes.
  public void computeSummaryStatistics(){
    
    
     summaryStatistics.callers = 0; // Total number of caller functions
     summaryStatistics.callees = 0; // Total number of callees (i.e. the sum of all of the call sites for each caller function).
     
      for(int i =0; i < stack.peek().size();i++){
        summaryStatistics.callees += stack.peek().get(i).metaData.callees;
        
        // A caller is defined as a function that calls at least one other callee.
        if(stack.peek().get(i).metaData.callees > 0){
           summaryStatistics.callers++; // Total number of caller functions
        }
      }
     
     // Figure out how much of the data we are seeing.
     // Store our first push onto the stack here
     if (stack.size()==1){
       bottomOfStackCallers = summaryStatistics.callers; // Total number of caller functions
       bottomOfStackCallees = summaryStatistics.callees; // Total number of callees (i.e. the sum of all of the call sites for each caller function).
     }
             
     println("Total Callers:"+summaryStatistics.callers + " of "+bottomOfStackCallers);
     println("Total Callees:"+summaryStatistics.callees + " of "+bottomOfStackCallees);
     printStack();
  }
  
  /*  Returns how many active nodes there are on the visualization by getting the
      size of the nodeList that lives on the stack.
  */
  public int totalActiveNodes(){
      return stack.peek().size();
  }
  
  // Outputs the stack from top to bottom
  public void printStack(){
      Iterator<ChordNodeList> iter = stack.iterator();
      
      int counter = 0;     
      while (iter.hasNext()){
          //ChordNodeList temp = iter;
          System.out.println(counter+".) ");
          counter++;
          iter.next();
      }
  }
  
  // Generates a dot graph from the top of the stack
  // The mode specifies how to output nodes
  // mode 0 (default) - Output all of the nodes that are visible in our visualization
  // mode 1           - Output all of the nodes that are selected.
  public void outputDot(String filepath, int mode){
    PrintWriter output;

    output = createWriter(filepath);
    output.println("digraph{");
    
    for(int i =0; i < stack.peek().size();i++){
      ChordNode currentNode = stack.peek().get(i);
      
      if(mode <= 0){
          output.println(currentNode.metaData.name + " -> " + "some_callee");
      }else if(mode ==1){
        // Check if our node is selected first, and then output it. Otherwise we don't care.
        if(currentNode.selected){
          // Get all of the callees from our node that has been selected
          for(int j = 0; j < currentNode.LocationPoints.size(); j++){
            output.println(currentNode.metaData.name + " -> " + currentNode.LocationPoints.get(j).metaData.name);
          }          
        }
      }
    }
    
    output.println("}");
    output.flush();
    output.close();
  }
  
  // Return map
  // This is useful, if we want to search very quickly
  // over our collection of nodes, then we can learn the list
  // very quickly (O(1)) instead of O(n).
  //
  // Note that the key is a node's name, as often we want to search by the nodes name
  //
  public Map<String,ChordNode> getTopStackMap(){
    // Create a temporary map
    Map<String,ChordNode> tempMap = new HashMap<String,ChordNode>();  
    // Iterate through all of the items on the top of our stack
    for(int i =0; i < stack.peek().size();++i){
        ChordNode temp = stack.peek().get(i);
        tempMap.put(temp.metaData.name,temp);
    }
  
    return tempMap;
  }

  
  
  
}