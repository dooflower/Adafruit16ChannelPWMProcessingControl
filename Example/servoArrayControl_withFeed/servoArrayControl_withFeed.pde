import processing.video.*;
import processing.net.*;
import java.io.*;
import java.net.*;

import processing.serial.*;
ServoGrid[] sg = new ServoGrid[48];
Serial myPort;       

String data;
JSONObject json; 
int value = 0;
String[] lines;
long currentTime;
float gridSize;


void setup(){
  size(500,500);
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[3], 115200);

  float gridSize = width/16;
  for(int i = 0; i < sg.length; i++){
      sg[i] = new ServoGrid(i, i*gridSize+gridSize/2,height/2, gridSize, myPort);
  }
  
  new NewSensorFeed("sensor1").start(); //using threading so that the main function wont held
}

void draw(){
  
  for(int i = 0; i < sg.length; i++){
    sg[i].update();
    sg[i].display();
  }
  
}