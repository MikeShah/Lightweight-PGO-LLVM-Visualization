
/*
  The purpose of this class is to store the translations from the camera
  so that we don't have to pass them around in a stack or some other nasty way.
*/
public static class MySimpleCamera{
   public static float cameraX = 0;
   public static float cameraY = 0;
   public static float cameraZ = 0 ;
   
   public static float cameraSpeed = 10;
   
   // This constructor is not called
   // unless this class is an inner class I believe.
   public MySimpleCamera(){
     cameraX = 0;
     cameraY = 0;
     cameraZ = 0;
     cameraSpeed = 10;
     println("HI from the static constructor");
   }
   
   public static void setCameraSpeed(float speed){
      cameraSpeed = speed; 
   }
   
   public static void moveForward(){
     cameraZ += cameraSpeed;
   }
   
   public static void moveBack(){
     cameraZ -= cameraSpeed;
   }
   
   public static void moveUp(){
     cameraY -= cameraSpeed;
   }
   
   public static void moveDown(){
     cameraY += cameraSpeed;
   }
   
   public static void moveLeft(){
     cameraX += cameraSpeed;
   }
   
   public static void moveRight(){
     cameraX -= cameraSpeed;
   }
   
}