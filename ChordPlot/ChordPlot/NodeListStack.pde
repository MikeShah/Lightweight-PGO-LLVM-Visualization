/*
    This data structure is a stack.
    The elements of the stack are of the type ''
    
    We can push and pop items off of the stack
*/
public class NodeListStack{
  
  // The all important stack
  Deque<ArrayList<ChordNode>> stack;
  
  // Store statistics about the data 
  // Note that these statistics are always in reference to
  // the top node of the stack.
  // Anytime we push or pop, we need to recompute the summary statistics
  public SummaryStatistics summaryStatistics;
  
  
  /*
      Default Constructor
  */
  public NodeListStack(){
    // Instantiate our stack
    stack = new ArrayDeque<ArrayList<ChordNode>>();
    // Instantiate summary statistics
    summaryStatistics = new SummaryStatistics();
  }
  
  /*
      Filter Design pattern
      
      1.) Create a new ArrayList<ChordNode>
      2.) Loop through all nodes that are on the top of the stack
      3.) If they do not meet the criteria, then do not add them to the list.
      4.) Push the arrayList we have built on top of the stack
  */
  public void filterCallSites(int min, int max){
      ArrayList<ChordNode> filteredNodes = new ArrayList<ChordNode>();
      for(int i =0; i < stack.peek().size();i++){
        if(stack.peek().get(i).metaData.callees >= min && stack.peek().get(i).metaData.callees <= max){
          filteredNodes.add(stack.peek().get(i));
        }
      }
      stack.push(filteredNodes);
  }
  
  
  /*
    Add on a new filter
    Then compute summary Statistics
  */
  public void push(ArrayList<ChordNode> activeNodeList){
    stack.push(activeNodeList);
    computeSummaryStatistics();
  }
  
  /*
    Remove our last filter
    Then compute summary statistics
  */
  public void pop(){
    stack.pop();
    computeSummaryStatistics();
  }
  
  /*
    Peek at the top of our stack
  */
  public ArrayList<ChordNode> peek(){
    if(stack.size() >0){
      return (ArrayList<ChordNode>)stack.peek();
    }else
    {
      return null;
    }
  }
  
  
  // Update the summary statistics based on the active nodes.
  public void computeSummaryStatistics(){
   summaryStatistics.callers = 0; // Total number of caller functions
   summaryStatistics.callees = 0; // Total number of callees (i.e. the sum of all of the call sites for each caller function).
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
      Iterator<ArrayList<ChordNode>> iter = stack.iterator();
      
      int counter = 0;
      while (iter.hasNext()){
          System.out.println(counter+".) nodeList");
          counter++;
          iter.next();
      }
  }
  
  
}