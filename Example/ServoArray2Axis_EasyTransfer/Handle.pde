class Handle{
  int len;
  
  
  Handle(int l){
    len = l;
  }
  
  void display(){
    pushMatrix();
    translate(0,0,len/2);
    box(5,5,len);
    popMatrix();
    
    
  }
  
  void update(){
  }
}