import controlP5.*;
import processing.serial.*;
import processing.opengl.*;

import peasy.*;
PeasyCam cam;
ControlP5 cp5;

float cursorXVal = 300;
float cursorYVal = 300;
float cursorZVal = 123;


Serial myPort;       
int indexOffset = 48;
Node[] ns= new Node[16];
int numOfRow = 4;

int gridGap = 500;
int adjustments[] ={
  4,1, -5,5, 10,12, -7,0,
  -7,0,  3,0,  2,0,  0,0,
  -3,-5,  1,0,  7,1,  -5,0,
  -5,2,  8,0,  8,3,  2,0,
  0,0, 0,0, 0,0, 0,0,
  0,0, 0,0, 0,0, 0,0,
  0,0, 0,0, 0,0, 0,0,
  0,0, 0,0, 0,0, 0,0,
  0,0, 0,0, 0,0, 0,0,

};

void setup(){
  size(1000,1000,P3D);
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[3], 115200);
  
  for(int i = 0; i < ns.length; i++){
    ns[i] = new Node(i+indexOffset, i%numOfRow*gridGap,int(i/numOfRow)*gridGap,0, adjustments[i*2],adjustments[i*2+1]);
  }
  
  cp5 = new ControlP5(this);
  cp5.addSlider("cursorXVal")
      .setRange(0,3000)
      .setPosition(20,20)
      .setSize(500,20);
  cp5.addSlider("cursorYVal")
      .setRange(0,3000)
      .setPosition(20,50)
      .setSize(500,20);
  cp5.addSlider("cursorZVal")
      .setRange(0,3000)
      .setPosition(20,80)
      .setSize(500,20);

  

}


void draw(){

  background(100);
  noFill();

  pushMatrix();
  
  translate(-3*gridGap/2,-3*gridGap/2,-5000);
  rotateX(PI/4);


  allTraceSinglePoint(cursorXVal, cursorYVal, cursorZVal);

  for(int i = 0; i < ns.length; i++){
    //ns[i].drawRect(0,0,1255,2000,2000,10);
    //ns[i].setNewTarget(0,90);
    ns[i].update();
    ns[i].display();
  }
  
 
  popMatrix();

  delay(10);

}

void allTraceSinglePoint(float x, float y, float z){
  
    PVector singlePoint = new PVector(x, y, z);

    pushMatrix();
    pushStyle();
    fill(255);
    translate(x,y,z);
    box(50);
    popStyle();
    popMatrix();
      
  
  
    for(int i = 0; i < ns.length; i++){
    //ns[i].setNewTarget(int(map(mouseX,0,width,0,180)),int(map(mouseY,0,height,0,180)));
    //ns[i].setNewTarget(int(map(ns[i].tipPosition.x-mouseX,0,width,0,180)),int(map(mouseY,0,height,0,180)));


    // tracking mode
    PVector dir = PVector.sub(singlePoint,ns[i].location);
    PVector dir2 = PVector.sub(singlePoint,ns[i].location);
    PVector offset = new PVector(0,0,ns[i].s1.h+ns[i].s2.l/2);
    dir2.add(offset);

    dir.normalize();
    dir2.normalize();
    float a1 = atan2(-dir.y,dir.x);
    float a2 = atan2(dir2.z,sqrt(dir2.x*dir2.x+dir2.y*dir2.y));

    //println(degrees(a2));

    //println(int(degrees(a2)));
    //ns[i].setNewTarget(int(degrees(a1)),int(90-degrees(a2)));
    //ns[i].setNewTarget(int(degrees(a1)),int(-degrees(a2)));

    if(a1<0){
      a1 = PI+a1;
      a2 = PI-a2;
    }

    ns[i].setNewTarget(int(degrees(a1)),int(degrees(a2)));

    }
}