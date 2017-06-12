class ServoGrid{
  PVector location;
  int degree;
  float size;
  int index;
  int direction =1;
  Serial port; 
  float nOff = random(1);

  
  ServoGrid(int id,float sz, Serial p){
    index = id;
    size = sz;
    location = new PVector();
    //brightness = id%180+1;
    degree = 0;

    port = p;
  }
  
  void display(){
    pushMatrix();
    pushStyle();
    translate(location.x,location.y);
    rectMode(CENTER);
    stroke(255);
    //fill(degree);
    fill(20);
    rect(0,0,size,size);
    
    rotate(radians(degree));
    line(0,0,15,0);

    popStyle();
    
    
    
    popMatrix();
  }
  
  void update(){

    degree = (int)map(noise(nOff),0,1,0,180);
    nOff+=0.01;
    
    et_send(port,et_prepareMessage(index,degree));

  }  
  
  
  void et_send(Serial port, char[] buffer) {
    byte checksum = (byte) buffer.length;
    
    port.write((byte)0x06);        // these magic bytes define the start
    port.write((byte)0x85);        // of a message for EasyTransfer.
    port.write((byte)checksum);    // The starter is followed by the length of the payload...
    
    for (int i = 0; i < buffer.length; i++) {
      port.write((byte)buffer[i]); // ...the payload itself...
      checksum ^= buffer[i];
    }
    port.write((byte)checksum);    // ...and a checksum (the length and each payload byte xor'ed)
  }

  //To send data other than plain chars it would have to be prepared for sending with the above function, like so (example for int and String):
  char[] et_prepareMessage(String toSend) {
    char[] buffer = new char[toSend.length()];
    for (int i = 0; i < toSend.length(); i++) {
      buffer[i] = toSend.charAt(i);
    }
    return buffer;
  }



  char[] et_prepareMessage(int toSend1, int toSend2) {
    char[] buffer = new char[4];
    
    buffer[0] = (char) (toSend1        & 0xFF);
    buffer[1] = (char)((toSend1 >>  8) & 0xFF);
    buffer[2] = (char) (toSend2        & 0xFF);
    buffer[3] = (char)((toSend2 >>  8) & 0xFF);
  
    return buffer;
  }
}