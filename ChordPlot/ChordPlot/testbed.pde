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
  
  
  
  List<String> strings = new ArrayList<String>();
  try{
      // Attempt to read file fast
      BufferedReader br = new BufferedReader(new FileReader(filename));
      String line = null;
      while( (line = br.readLine()) != null ){
        strings.add(line);
      }
      br.close();
  }
  catch(IOException e){
    
  }
  
  // Start processing the file
  String[] lineArray = strings.toArray(new String[strings.size()]);
  // Spawn some threads
  int numberOfThreads = 10;
  int workOfThreads = lineArray.length/numberOfThreads; // Note that the last thread will read any leftover.
  
  for(int i =0; i < numberOfThreads; ++i){
    
  }

}


public void multiThreadedFileRead(){
    
}