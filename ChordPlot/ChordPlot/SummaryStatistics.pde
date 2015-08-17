/*
    The purpose of this class is to exist within the DataLayer
    
    Instances of this object will collect interesting data information
    and be able to output and save the statistics somewhere.
*/
class SummaryStatistics{
  
   // Attributes
   int callers; // Total number of caller functions
   int callees; // Total number of callees (i.e. the sum of all of the call sites for each caller function).
  
   SummaryStatistics(){
     this.callers = 0;
     this.callees = 0;
   }
   
   /*
     Prints out a string with the statistics
   */
   public String output(){
     String result = "Callers: " + callers +
                     "Callees: " + callees;
     return result;
   }
   
}