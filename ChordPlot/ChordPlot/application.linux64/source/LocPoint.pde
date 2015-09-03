/*
    Purpose is to be used to store the location of a callee
    
    We can also name the point in space.
    The most pragmatic use case will be to name the point in space after the callee.
*/

// Represents a point in space
class LocPoint{
 float x;
 float y;
 float z;
 String name;
 /*
 LocPoint(float x, float y){
   this.x = x;
   this.y = y;
   this.z = 0;
 }
 
  LocPoint(float x, float y, float z){
   this.x = x;
   this.y = y;
   this.z = z;
 }
 */
 LocPoint(float x, float y, float z, String name){
   this.x = x;
   this.y = y;
   this.z = z;
   this.name = name;
 }
}