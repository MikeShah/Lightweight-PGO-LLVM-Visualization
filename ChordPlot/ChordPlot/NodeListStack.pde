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
  */
  public void pop(){
    if(stack.size()>1){
      stack.pop();
    }
    computeSummaryStatistics();
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
     summaryStatistics.callers = stack.peek().size(); // Total number of caller functions
     summaryStatistics.callees = 0; // Total number of callees (i.e. the sum of all of the call sites for each caller function).
     
      for(int i =0; i < stack.peek().size();i++){
        summaryStatistics.callees += stack.peek().get(i).metaData.callees;
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
  public void outputDot(String filepath){
    PrintWriter output;

    output = createWriter(filepath);
    
    for(int i =0; i < stack.peek().size();i++){
      output.println(stack.peek().get(i).metaData.name + " -> "+"some_callee");
    }
    
    output.flush();
    output.close();
  }
  
  
}