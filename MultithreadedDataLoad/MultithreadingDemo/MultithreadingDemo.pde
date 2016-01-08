/*
      Algorithm
      
      1.) Open a Random Access File
      2.) (multithreaded) Split file into n distinct sections
          a.) Distinct sections need to explicitly start at the start of a line
          b.) Distinct sections ened to explicitly end at the end of the line ('\n') found
      3.) (single threaded bottleneck) Add entries from file into a data structure
      4.) (single threaded bottleneck) Sort the data structure
      5.) 


*/
import java.util.*;

int[] bigArray;


void setup()
{
  
  bigArray = new int[1000000];
 
  Runnable task = () => {
      String threadName = Thread.currentThread().getName();
  };
  
}

void draw(){

  background(0);
  rect(0,0,20,20);

}