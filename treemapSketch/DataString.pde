// Purpose:
//
// A special mutable version of a java string
//

class DataString{
  String text;
  
  DataString(){
    text = new String("empty");
  }
  
  void setText(String s){
    text = new String(s);
  }
  
  String getString(){
    if(text!=null){
      return text;
    }else{
      return "";
    }
  }
  
}