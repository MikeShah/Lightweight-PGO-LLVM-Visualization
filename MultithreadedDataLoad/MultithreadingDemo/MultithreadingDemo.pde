// This is a random file for testing ideas
// Consider this a sandbox.
// Totally not necessary to keep this file in the project.

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
public void readFile(String filename){
  // Load data into a byte array.
  byte b[] = loadBytes(filename);
  for(int i =0; i < b.length; i++){
    println(b[i]);
  }

}


public void spawnFileReadingThread(){
  
}


public void multiThreadedFileRead(int offset,int start, int stop){
    
}