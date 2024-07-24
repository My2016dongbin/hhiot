class CommonUtils{
  String msgString(String s){
    s = s.substring(s.indexOf(':')+1,s.length);
    return s;
  }
  String mobileString(String s){
    if(s.length == 11){
      s =  "${s.substring(0,3)}****${s.substring(7,s.length)}";
    }
    return s;
  }
}