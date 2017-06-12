import processing.video.*;
import processing.net.*;
import java.io.*;
import java.net.*;

import processing.serial.*;
ServoGrid[] sg = new ServoGrid[100];
Serial myPort;       

String data;
JSONObject json; 
int value = 0;
String[] lines;
long currentTime;
float gridSize;

Capture cam;
PImage croppedCam;

color black = color(0);
color white = color(255);

void setup(){
  size(500,500);
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[3], 2000000);

  
  gridSize = width/10;
  for(int i = 0; i < 10; i++){
    for(int j = 0; j < 10; j++){
      //allocate servogrid to 10x10 table
      sg[i*10+j] = new ServoGrid(i*10+j,i*(gridSize)+gridSize/2,j*(gridSize+1)+gridSize/2, gridSize, myPort);
    }
  }
  
  //new NewSensorFeed("sensor1").start(); //using threading so that the main function wont held
  
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, 80, 60, 15);
    cam.start();     
  }      

  croppedCam = new PImage(50,50);
}

void draw(){
  if (cam.available() == true) {
    cam.read();
    croppedCam = cam.get(0,0,50,50);
  }
  
  croppedCam.loadPixels();
  for (int i = 0; i < croppedCam.width*croppedCam.height; i++) {
    if(brightness(croppedCam.pixels[i]) < 100){
      croppedCam.pixels[i] = black;
    }else{
      croppedCam.pixels[i] = white;
    }
  }
  croppedCam.updatePixels();
  image(croppedCam,0,0);  
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);
  
  PImage scaledImage = croppedCam.get();
  scaledImage.resize(10,10);
  image(scaledImage,0,0,width,height);
  
   for (int i = 0; i < scaledImage.width*scaledImage.height; i++) {
    int brightness = int(map(brightness(scaledImage.pixels[i]),0,255,0,180));
      sg[i].setNewTarget(brightness);
  }
 
 
  for(int i = 0; i < sg.length; i++){
    sg[i].update();
    sg[i].display();
  }
  
}