import processing.video.*;
import processing.net.*;
import java.io.*;
import java.net.*;

import processing.serial.*;
ServoGrid[] sg = new ServoGrid[144];
Serial myPort;       

String data;
JSONObject json; 
int value = 0;
String[] lines;
long currentTime;
float gridSize;
int waveTimer = 0;


void setup(){
  size(1000,1000);
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[3], 250000);

  float gridSize = width/16;
  int gridRows = int(sg.length/16);
  println("grid rows:"+gridRows);
  for(int i = 0; i < 16; i++){
    for(int j = 0; j < gridRows; j++){
      sg[i+j*16] = new ServoGrid(i+j*16, i*gridSize+gridSize/2,j*gridSize+gridSize/2, gridSize, myPort);
    }
  }
  

  //new NewSensorFeed("sensor1").start(); //using threading so that the main function wont held

}

void draw(){
  if(waveTimer>360) waveTimer = 0;
  for(int k = 0; k < sg.length; k++){
    sg[k].setNewTarget(int(cos(radians(waveTimer+k%16*10))*60)+60);

    //sg[k].setNewTarget(int(cos(radians(waveTimer+k%16*10))*90)+90);
    //sg[k].setNewTarget(90);

    //println(int(cos(radians(waveTimer+k%16*10))*60)+60);
  }
  waveTimer++;
  
  for(int i = 0; i < sg.length; i++){
    //sg[i].noise = true;
    sg[i].update();
    sg[i].display();
  }
  
}