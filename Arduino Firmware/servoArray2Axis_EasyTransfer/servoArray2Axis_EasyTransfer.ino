#include <EasyTransfer.h>
#include <Wire.h>
#include <Adafruit_PWMServoDriver.h>

// called this way, it uses the default address 0x40
Adafruit_PWMServoDriver pwm1 = Adafruit_PWMServoDriver(0x40);
// you can also call it with a different address you want
Adafruit_PWMServoDriver pwm2 = Adafruit_PWMServoDriver(0x41);
Adafruit_PWMServoDriver pwm3 = Adafruit_PWMServoDriver(0x42);
Adafruit_PWMServoDriver pwm4 = Adafruit_PWMServoDriver(0x43);
Adafruit_PWMServoDriver pwm5 = Adafruit_PWMServoDriver(0x44);
Adafruit_PWMServoDriver pwm6 = Adafruit_PWMServoDriver(0x45);
Adafruit_PWMServoDriver pwm7 = Adafruit_PWMServoDriver(0x46);
Adafruit_PWMServoDriver pwm8 = Adafruit_PWMServoDriver(0x47);

// Depending on your servo make, the pulse width min and max may vary, you 
// want these to be as small/large as possible without hitting the hard stop
// for max range. You'll have to tweak them as necessary to match the servos you
// have!

//min-max: 110-540 (>180 degree), 485=180 degree

#define SERVOMIN  110 // this is the 'minimum' pulse length count (out of 4096)
#define SERVOMAX  470 // this is the 'maximum' pulse length count (out of 4096)

// our servo # counter
uint16_t servoNum = 0; //0-65,535
int servoVal = 0; 

//create object
EasyTransfer ET; 

struct RECEIVE_DATA_STRUCTURE{
  uint16_t index;
  uint16_t degree;
};

RECEIVE_DATA_STRUCTURE mydata;



void setup() {
  Serial.begin(115200);

  ET.begin(details(mydata), &Serial);

  pwm1.begin();  
  pwm1.setPWMFreq(50);  // Tower Pro SG 90 servos run at ~50 Hz updates

  pwm2.begin();  
  pwm2.setPWMFreq(50);  // Tower Pro SG 90 servos run at ~50 Hz updates

  pwm3.begin();  
  pwm3.setPWMFreq(50);  // Tower Pro SG 90 servos run at ~50 Hz updates

  pwm4.begin();  
  pwm4.setPWMFreq(50);  // Tower Pro SG 90 servos run at ~50 Hz updates

  pwm5.begin();  
  pwm5.setPWMFreq(50);  // Tower Pro SG 90 servos run at ~50 Hz updates

  pwm6.begin();  
  pwm6.setPWMFreq(50);  // Tower Pro SG 90 servos run at ~50 Hz updates

  pwm7.begin();  
  pwm7.setPWMFreq(50);  // Tower Pro SG 90 servos run at ~50 Hz updates
 
  pwm8.begin();  
  pwm8.setPWMFreq(50);  // Tower Pro SG 90 servos run at ~50 Hz updates

  yield();

}


void loop() {

  if(ET.receiveData()){

//  setPWM(channel, on, off)
    uint16_t pulselength = map(mydata.degree, 0, 180, SERVOMIN, SERVOMAX);


    
    if(mydata.index<16){
      pwm1.setPWM(mydata.index, 0, pulselength); 
    }else if(mydata.index<32){
      pwm2.setPWM(mydata.index%16, 0, pulselength); 
    }else if(mydata.index<48){
      pwm3.setPWM(mydata.index%16, 0, pulselength); 
    }else if(mydata.index<64){
      pwm4.setPWM(mydata.index%16, 0, pulselength); 
    }else if(mydata.index<80){
      pwm5.setPWM(mydata.index%16, 0, pulselength); 
    }else if(mydata.index<96){
      pwm6.setPWM(mydata.index%16, 0, pulselength); 
    }else if(mydata.index<112){
      pwm7.setPWM(mydata.index%16, 0, pulselength); 
    }else if(mydata.index<128){
      pwm8.setPWM(mydata.index%16, 0, pulselength); 
    }

  }
}




