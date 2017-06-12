import processing.serial.*;
ServoGrid[] sg = new ServoGrid[16];
Serial myPort;       


void setup(){
  size(641,38);
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[3], 115200);
  
  
  for(int i = 0; i < sg.length; i++){
    sg[i] = new ServoGrid(i,width/sg.length, myPort);
  }

  for(int i = 0; i < sg.length; i++){
    sg[i].location.set(i*sg[i].size+sg[i].size/2, height/2);
  }

}

void draw(){

  for(int i = 0; i < sg.length; i++){
    sg[i].update();
    sg[i].display();
  }
  
}