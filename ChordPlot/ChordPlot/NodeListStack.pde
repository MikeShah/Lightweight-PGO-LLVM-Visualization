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
    stack = new ArrayDeque<ArrayList<ChordNode>>();
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
  
  
  // Update the summary statistics based on the active nodes.
  public void computeSummaryStatistics(){
   summaryStatistics.callers = 0; // Total number of caller functions
   summaryStatistics.callees = 0; // Total number of callees (i.e. the sum of all of the call sites for each caller function).
  }
  
  /*  Returns how many active nodes there are on the visualization by getting the
      size of the nodeList that lives on the stack.
  */
  public int totalActiveNodes(){
      return stack.peek().size();
  }
  
  
}