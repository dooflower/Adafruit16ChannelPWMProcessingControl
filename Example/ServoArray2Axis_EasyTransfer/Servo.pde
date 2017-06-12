class Servo{
  int index;
  float angle;
  PVector location;
  int w;
  int h;
  int l;
  float cylinderHeight;
  float cylinderRadius;
  int targetAngle;
  int offset;
  Servo(int i, int of){
    index = i;
    angle = 0;
    w = 230;
    h = 230;
    l = 125;
    cylinderHeight =40;
    cylinderRadius = l/2;
    offset = of;
  }
  
  void display(){
    pushMatrix();
    drawCylinder(24,cylinderRadius,cylinderHeight);
    translate(-50,0,h/2+cylinderHeight/2);
    box(w,l,h);
    popMatrix();
    
  }
  
  void update(){

     et_send(myPort,et_prepareMessage(index,int(angle+offset)));

  }
  
    //Easy Transfer stuff
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
  
  
  
  void drawCylinder(int sides, float r, float h)
  {
      float angle = 360 / sides;
      float halfHeight = h / 2;
      // draw top shape
      beginShape();
      for (int i = 0; i < sides; i++) {
          float x = cos( radians( i * angle ) ) * r;
          float y = sin( radians( i * angle ) ) * r;
          vertex( x, y, -halfHeight );    
      }
      endShape(CLOSE);
      // draw bottom shape
      beginShape();
      for (int i = 0; i < sides; i++) {
          float x = cos( radians( i * angle ) ) * r;
          float y = sin( radians( i * angle ) ) * r;
          vertex( x, y, halfHeight );    
      }
      endShape(CLOSE);
      
      beginShape(TRIANGLE_STRIP);
      for (int i = 0; i < sides + 1; i++) {
          float x = cos( radians( i * angle ) ) * r;
          float y = sin( radians( i * angle ) ) * r;
          vertex( x, y, halfHeight);
          vertex( x, y, -halfHeight);    
      }
      endShape(CLOSE); 
  } 

}