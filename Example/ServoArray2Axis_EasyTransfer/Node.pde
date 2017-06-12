class Node{
  PVector location;
  PVector tipPosition;
  PVector pivotPosition;
  PVector[] smoke = new PVector[20];
  
  PVector cursor;
  
  Servo s1;
  Servo s2;
  Handle h1;
  boolean doneMoving;
  int numOfSteps;
  int step;
  
  int index;
  Node(int i, int x, int y, int z, int s1off, int s2off){
    index = i;
    location = new PVector(x,y,z);
    s1 = new Servo(index*2,s1off);
    s2 = new Servo(index*2+1,s2off);
    h1 = new Handle(900);
    step = 0;
    numOfSteps = 0;
    tipPosition = new PVector();
    cursor = new PVector(x,y,s1.h+s2.l+h1.len);
    doneMoving = true;
    pivotPosition = new PVector();
    for(int j = 0; j < smoke.length;j++){
      smoke[j] = new PVector();
    }

    //controlPointZ = 0;
    //controlPointX = 0;
    //controlPointY = 0;

  }
  

  void update(){
    
    //controlPointZ = 500;
    //if(controlPointX>1500) controlPointX =0;
    //else controlPointX+=10;

    
    //float s2Angle = degrees(asin((mouseY - location.z - s1.h-s2.cylinderRadius)/h1.len));
    //s2.angle = s2Angle;
    
    //float s1Angle = degrees(acos((mouseX-location.x)/(-h1.len*cos(radians(s2.angle))+1)));
    ////println(s1Angle);
    //s1.angle = s1Angle;
    
    //followCursor();
    
    s1.update(); //send command to servo 1
    s2.update(); //send command to servo 2
  }


  void display(){
    //draw base servo
    pushMatrix();
    translate(location.x,location.y, location.z);
    rotate(radians(-s1.angle)); // screen is mirrored
    translate(0,0,-s1.cylinderHeight/2);
    s1.display();
    
    //draw arm servo
    //translate(0,s2.cylinderHeight/2+s1.l/2, s1.cylinderHeight/2+s1.h+s2.l/2);
    translate(0,-s2.cylinderHeight/2, s1.cylinderHeight/2+s1.h+s2.l/2);
    rotateY(-PI/2);

    rotateX(PI/2);
    s2.display();
    
    //draw arm 
    rotateX(-PI/2);
    //translate(0,s2.cylinderHeight/2,0);
    rotateY(radians((180-s2.angle)));
    h1.display();

    //store last transfromed location (second servo center)
    float x = modelX(0, 0, 0);
    float y = modelY(0, 0, 0);
    float z = modelZ(0, 0, 0);
    
    pivotPosition.set(x,y,z);

    popMatrix();
    
    //draw tip and keep the position record
    float xpos = location.x+cos(radians(s1.angle))*(h1.len*cos(radians(s2.angle)));
    float ypos = location.y+sin(radians(s1.angle))*(-h1.len*cos(radians(s2.angle)));
    float zpos = location.z+s1.h+s2.cylinderRadius+sin(radians(s2.angle))*h1.len;


    tipPosition.set(xpos,ypos,zpos);
    pushMatrix();
    pushStyle();
    noStroke();
    fill(255,0,0);
    translate(tipPosition.x,tipPosition.y,tipPosition.z);
    sphere(20);

    popStyle();
    popMatrix();
    
    //draw cursor
    pushMatrix();
    pushStyle();
    fill(255);
    translate(cursor.x,cursor.y,cursor.z);
    box(30);
    popStyle();
    popMatrix();
    
    //draw smoke
    for(int i= smoke.length-1; i >0 ;i--){
      pushMatrix();
      smoke[i].set(smoke[i-1].x,smoke[i-1].y,smoke[i-1].z);
      smoke[i].z+=10;
      translate(smoke[i].x,smoke[i].y,smoke[i].z);
      pushStyle();
      noStroke();
      fill(255,255/(i*2));
      sphere(10);
      popStyle();
      popMatrix();
    }
    smoke[0].set(tipPosition.x,tipPosition.y,tipPosition.z);
    
  }
  
  void moveCursorToPoint(float x, float y, float z, float spd){
    PVector destination = new PVector(x,y,z);
    PVector diff = PVector.sub(destination,cursor);
    if(diff.mag()>1){
      println("not there yet");
      cursor.add(diff.normalize().mult(spd));
      doneMoving = false;
    }else{
      println("arrived");
      cursor.set(destination);  
      doneMoving = true;
    }
  }
  
  void jumpToPoint(float x, float y, float z){
      cursor.set(x,y,z);      
  }
 
  void drawRect(float x, float y, float z,float w, float h, float spd){
    numOfSteps = 4;
    //println("step: "+ step);

    switch(step){
    case 0:
      //moveCursorToPoint(x,y,z,spd);
      jumpToPoint(x,y,z);
      step++;
      delay(1000);
//      if(doneMoving){
//        step++;
//      }
      break;
    case 1:
      //moveCursorToPoint(x+w,y,z,spd);
      //if(doneMoving){
      //  step++;
      //}     
            jumpToPoint(x+w,y,z);
      step++;
      //delay(1000);
      break;
    case 2:
      //moveCursorToPoint(x+w,y+h,z,spd);
      //if(doneMoving){
      //  step++;
      //}      
            jumpToPoint(x+w,y+h,z);
      step++;
      //delay(1000);
      break;
    case 3:
      //moveCursorToPoint(x,y+h,z,spd);
      //if(doneMoving){
      //  step++;
      //}      
            jumpToPoint(x,y+h,z);
      step++;
      //delay(1000);
      break;
    case 4:
      //moveCursorToPoint(x,y,z,spd);
      //if(doneMoving){
      //  step++;
      //}      
            jumpToPoint(x,y,z);
      step++;
      //delay(1000);
      break;

    }
  }

  void followCursor(){
    PVector dir = PVector.sub(cursor,location);
    PVector dir2 = PVector.sub(cursor,location);
    PVector offset = new PVector(0,0,s1.h+s2.l/2);
    dir2.add(offset);

    dir.normalize();
    dir2.normalize();
    float a1 = atan2(-dir.y,dir.x);
    float a2 = atan2(dir2.z,sqrt(dir2.x*dir2.x+dir2.y*dir2.y));
    
    if(a1<0){
      a1 = PI+a1;
      a2 = PI-a2;
    }
    
    setNewTarget(int(degrees(a1)),int(degrees(a2)));
  }
  
  
  void setNewTarget(int s1a, int s2a){
    //s1.targetAngle = s1a;
    //s2.targetAngle = s2a;
    s1.angle = s1a;
    s2.angle = s2a;
  }
}