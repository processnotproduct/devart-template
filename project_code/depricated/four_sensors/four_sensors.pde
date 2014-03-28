/*
takes input from four sensors on one arduino


removed analog output to LED light

Demonstrates the reading of digital and analog pins of an Arduino board
running the StandardFirmata firmware.

To use:
* Using the Arduino software, upload the StandardFirmata example (located
  in Examples > Firmata > StandardFirmata) to your Arduino board.
* Run this sketch and look at the list of serial ports printed in the
  message area below. Note the index of the port corresponding to your
  Arduino board (the numbering starts at 0).  (Unless your Arduino board
  happens to be at index 0 in the list, the sketch probably won't work.
  Stop it and proceed with the instructions.)
* Modify the "arduino = new Arduino(...)" line below, changing the number
  in Arduino.list()[0] to the number corresponding to the serial port of
  your Arduino board.  Alternatively, you can replace Arduino.list()[0]
  with the name of the serial port, in double quotes, e.g. "COM5" on Windows
  or "/dev/tty.usbmodem621" on Mac.
* Run this sketch. The squares show the values of the digital inputs (HIGH
  pins are filled, LOW pins are not). The circles show the values of the
  analog inputs (the bigger the circle, the higher the reading on the
  corresponding analog input pin). The pins are laid out as if the Arduino
  were held with the logo upright (i.e. pin 13 is at the upper left). Note
  that the readings from unconnected pins will fluctuate randomly. 
  
For more information, see: http://playground.arduino.cc/Interfacing/Processing
*/

// Imports
import oscP5.*;
import netP5.*;
import controlP5.*;

import processing.serial.*;

import cc.arduino.*;

//for audio=====================

//import ddf.minim.*;
//import ddf.minim.ugens.*;

// Declarations
OscP5 oscP5;
ControlP5 controlP5;
NetAddress myRemoteLocation;

Arduino arduino1;
Arduino arduino2;

//Minim minim;
//AudioOutput out;
//AudioSample kick;
//AudioSample snare;

//// to make an Instrument we must define a class
//// that implements the Instrument interface.
//class SineInstrument implements Instrument
//{
//  Oscil wave;
//  Line  ampEnv;
//  
//  SineInstrument( float frequency )
//  {
//    // make a sine wave oscillator
//    // the amplitude is zero because 
//    // we are going to patch a Line to it anyway
//    wave   = new Oscil( frequency, 0, Waves.SINE );
//    ampEnv = new Line();
//    ampEnv.patch( wave.amplitude );
//  }
//  
//  // this is called by the sequencer when this instrument
//  // should start making sound. the duration is expressed in seconds.
//  void noteOn( float duration )
//  {
//    // start the amplitude envelope
//    ampEnv.activate( duration, 0.5f, 0 );
//    // attach the oscil to the output so it makes sound
//    wave.patch( out );
//  }
//  
//  // this is called by the sequencer when the instrument should
//  // stop making sound
//  void noteOff()
//  {
//    wave.unpatch( out );
//  }
//}

  //=====================

color off = color(4, 79, 111);
color on = color(84, 145, 158);
color bgg= color(4, 79, 111);

float analogvalue0 = 0;
float analogvalue1 = 0;
float analogvalue2 = 0;
float analogvalue3 = 0;
float analogvalue4 = 0;
float analogvalue5 = 0;
//for 2nd arduino
float analogvalue20 = 0;
float analogvalue21 = 0;
float analogvalue22 = 0;
float analogvalue23 = 0;

//input nominal values for the thresholds
float threshold0=218;
float threshold1=999;
float threshold2=995;
float threshold3=174;
float threshold4=140;
float threshold5=260;

float threshold20=1009;
float threshold21=1017;
float threshold22=1017;
float threshold23=1013;


float sliderTicks0 = 900;
float sliderTicks1 = 900;
float sliderTicks2 = 900;
float sliderTicks3 = 900;
float sliderTicks4 = 900;
float sliderTicks5 = 900;

float sliderTicks20 = 900;
float sliderTicks21 = 900;
float sliderTicks22 = 900;
float sliderTicks23 = 900;


void setup() {
  
// make frame for the program
  size(800, 800);
  frameRate(25);

//  // Prints out the available serial ports.
//  println(Arduino.list());
//  
//  // Modify this line, by changing the "0" to the index of the serial
//  // port corresponding to your Arduino board (as it appears in the list
//  // printed by the line above).

//rear USB port on macbook pro
  arduino1 = new Arduino(this, "/dev/tty.usbmodem621", 57600);
  
////front USB port on macbook pro
  arduino2 = new Arduino(this, "/dev/tty.usbmodem411", 57600);  
  

  
  // Alternatively, use the name of the serial port corresponding to your
  // Arduino (in double-quotes), as in the following line.
  //arduino = new Arduino(this, "/dev/tty.usbmodem621", 57600);
  


  // Setup OSC
  oscP5 = new OscP5(this,9001); // was 9001
  myRemoteLocation = new NetAddress("localhost",9000);
   
  // Setup ControlP5
  controlP5 = new ControlP5(this);

      // add a vertical sliders
  controlP5.addSlider("sliderTicks0")
     .setPosition(50,140)
     .setSize(20,100)
     .setRange(210,220)
     .setValue(threshold0)
     ;

  controlP5.addSlider("sliderTicks1")
     .setPosition(150,140)
     .setSize(20,100)
     .setRange(985,1020)
     .setValue(threshold1)
     ;
     controlP5.addSlider("sliderTicks2")
     .setPosition(250,140)
     .setSize(20,100)
     .setRange(985,1015)
     .setValue(threshold2)
     ;
   
     controlP5.addSlider("sliderTicks3")
     .setPosition(350,140)
     .setSize(20,100)
     .setRange(150,250)
     .setValue(threshold3)
     ;
   
     controlP5.addSlider("sliderTicks4")
     .setPosition(450,140)
     .setSize(20,100)
     .setRange(100,200)
     .setValue(threshold4)
     ;  

     controlP5.addSlider("sliderTicks5")
     .setPosition(550,140)
     .setSize(20,100)
     .setRange(200,300)
     .setValue(threshold5)
     ; 

     controlP5.addSlider("sliderTicks20")
     .setPosition(50,300)
     .setSize(20,100)
     .setRange(990,1025)
     .setValue(threshold20)
     ;  
    
         controlP5.addSlider("sliderTicks21")
     .setPosition(150,300)
     .setSize(20,100)
     .setRange(995,1025)
     .setValue(threshold21)
     ;
    
         controlP5.addSlider("sliderTicks22")
     .setPosition(250,300)
     .setSize(20,100)
     .setRange(995,1025)
     .setValue(threshold22)
     ;
    
         controlP5.addSlider("sliderTicks23")
     .setPosition(350,300)
     .setSize(20,100)
     .setRange(995,1025)
     .setValue(threshold23)
     ; 
  
// ***MAKE SURE TO LOAD MODIFIED STANDARDFIRMATA, THAT HAS analogReference(INTERNAL); IN THE LOOP() SO THAT VOLTAGES WILL BE CORRECT
 


}


void draw() {
  background(color(20,20,20));
    stroke(on);
    fill(255, 255, 255);
  
int scalefactor1=10;
float offset1=990;
  
//read in analog values from first arduino (rear port)
  analogvalue0=arduino1.analogRead(0);//channel is 0
  analogvalue1=arduino1.analogRead(1);//channel is 1
  analogvalue2=arduino1.analogRead(2);//channel is 2
  analogvalue3=arduino1.analogRead(3);//channel is 3
  analogvalue4=arduino1.analogRead(4);//channel is 4
  analogvalue5=arduino1.analogRead(5);//channel is 5
    
//read in values from second arduino (front port)
    analogvalue20=arduino2.analogRead(0);//channel is 0
    analogvalue21=arduino2.analogRead(1);//channel is 1
    analogvalue22=arduino2.analogRead(2);//channel is 2
    analogvalue23=arduino2.analogRead(3);//channel is 3  
  
float scaledval0=scalefactor1*(analogvalue0-offset1);
float scaledval1=scalefactor1*(analogvalue1-offset1);
float scaledval2=scalefactor1*(analogvalue2-offset1);
float scaledval3=2*(analogvalue3-100);
//float scaledval3=0.3*(analogvalue3-500);
float scaledval4=2*(analogvalue4-100);
float scaledval5=scalefactor1*(analogvalue5-offset1);
  
float scaledval20=scalefactor1*(analogvalue20-offset1);
float scaledval21=scalefactor1*(analogvalue21-offset1);
float scaledval22=scalefactor1*(analogvalue22-offset1);
float scaledval23=scalefactor1*(analogvalue23-offset1);
  
  
//  analogvalue2=arduino2.analogRead(0);//channel is 0



  
    
  //display time (milliseconds)
text(millis(),20,20);

//draw bars indicating values (x from left,y from top,w,h,radius)
  fill(off);

  rect(100, 150, 20, scaledval0, 5);
  rect(200, 150, 20, scaledval1, 5);
  rect(300, 150, 20, scaledval2, 5);
  rect(400, 150, 20, scaledval3, 5);
  rect(500, 150, 20, scaledval4, 5);
  rect(600, 150, 20, scaledval5, 5);
  
  
  rect(100, 350, 20, scaledval20, 5);
  rect(200, 350, 20, scaledval21, 5);
  rect(300, 350, 20, scaledval22, 5);
  rect(400, 350, 20, scaledval23, 5);
//  
fill(255, 255, 255);

  float ypos1=100;

//display values (value, x, y)
  text(analogvalue0,110,ypos1);
  text(analogvalue1,210,ypos1);
  text(analogvalue2,310,ypos1);
  text(analogvalue3,410,ypos1);
  text(analogvalue4,510,ypos1);
  text(analogvalue5,610,ypos1);
    
    float ypos2=300;
    //for second arduino
  text(analogvalue20,100,ypos2);
  text(analogvalue21,200,ypos2);
  text(analogvalue22,300,ypos2);
  text(analogvalue23,400,ypos2);
  
  
//reset threshold values with sliders
threshold0=sliderTicks0;
threshold1=sliderTicks1;
threshold2=sliderTicks2;
threshold3=sliderTicks3;
threshold4=sliderTicks4;
threshold5=sliderTicks5;

threshold20=sliderTicks20;
threshold21=sliderTicks21;
threshold22=sliderTicks22;
threshold23=sliderTicks23;


  //indicators of threshold value(s)
  stroke(255);
line(100,150+scalefactor1*(threshold0-990),150,150+scalefactor1*(threshold0-990));
line(200,150+scalefactor1*(threshold1-990),250,150+scalefactor1*(threshold1-990));
line(300,150+scalefactor1*(threshold2-990),350,150+scalefactor1*(threshold2-990));
line(400,150+0.3*(threshold3-500),450,150+0.3*(threshold3-500));
line(500,150+0.3*(threshold4-500),550,150+0.3*(threshold4-500));
line(600,150+scalefactor1*(threshold5-990),650,150+scalefactor1*(threshold5-990));

line(100,300+scalefactor1*(threshold20-990),150,300+scalefactor1*(threshold20-990));
line(200,300+scalefactor1*(threshold21-990),250,300+scalefactor1*(threshold21-990));
line(300,300+scalefactor1*(threshold22-990),350,300+scalefactor1*(threshold22-990));
line(400,300+scalefactor1*(threshold23-990),450,300+scalefactor1*(threshold23-990));


//sensor 0 action
  if (analogvalue0>threshold0  ) {
    //send flipping signal via OSC
    OscMessage myMessage = new OscMessage("/arduino1_0");
    myMessage.add(0);
    oscP5.send(myMessage, myRemoteLocation);
    myMessage = new OscMessage("/arduino1_0");
    myMessage.add(1);
    oscP5.send(myMessage, myRemoteLocation);
  }    
  
  //sensor 1 action
  if (analogvalue1>threshold1  ) {
    //send flipping signal via OSC
    OscMessage myMessage = new OscMessage("/arduino1_1");
    myMessage.add(0);
    oscP5.send(myMessage, myRemoteLocation);
    myMessage = new OscMessage("/arduino1_1");
    myMessage.add(1);
    oscP5.send(myMessage, myRemoteLocation);
  }  
  
  //sensor 2 action
  if (analogvalue2>threshold2  ) {
    //send flipping signal via OSC
    OscMessage myMessage = new OscMessage("/arduino1_2");
    myMessage.add(0);
    oscP5.send(myMessage, myRemoteLocation);
    myMessage = new OscMessage("/arduino1_2");
    myMessage.add(1);
    oscP5.send(myMessage, myRemoteLocation);
  }  
  
  //sensor 3 action
  if (analogvalue3>threshold3  ) {
    //send flipping signal via OSC
    OscMessage myMessage = new OscMessage("/arduino1_3");
    myMessage.add(0);
    oscP5.send(myMessage, myRemoteLocation);
    myMessage = new OscMessage("/arduino1_3");
    myMessage.add(1);
    oscP5.send(myMessage, myRemoteLocation);
  }  

//sensor 4 action
  if (analogvalue4>threshold4  ) {
    //send flipping signal via OSC
    OscMessage myMessage = new OscMessage("/arduino1_4");
    myMessage.add(0);
    oscP5.send(myMessage, myRemoteLocation);
    myMessage = new OscMessage("/arduino1_4");
    myMessage.add(1);
    oscP5.send(myMessage, myRemoteLocation);
  }
  
//sensor 5 action
  if (analogvalue5>threshold5  ) {
    //send flipping signal via OSC
    OscMessage myMessage = new OscMessage("/arduino1_5");
    myMessage.add(0);
    oscP5.send(myMessage, myRemoteLocation);
    myMessage = new OscMessage("/arduino1_5");
    myMessage.add(1);
    oscP5.send(myMessage, myRemoteLocation);
  }  
  
  
  //sensor 2,0 action
  if (analogvalue20>threshold20  ) {
    //send flipping signal via OSC
    OscMessage myMessage = new OscMessage("/arduino2_0");
    myMessage.add(0);
    oscP5.send(myMessage, myRemoteLocation);
    myMessage = new OscMessage("/arduino2_0");
    myMessage.add(1);
    oscP5.send(myMessage, myRemoteLocation);
  }  
  
    //sensor 2,1 action
  if (analogvalue21>threshold21  ) {
    //send flipping signal via OSC
    OscMessage myMessage = new OscMessage("/arduino2_1");
    myMessage.add(0);
    oscP5.send(myMessage, myRemoteLocation);
    myMessage = new OscMessage("/arduino2_1");
    myMessage.add(1);
    oscP5.send(myMessage, myRemoteLocation);
  }  
    //sensor 2,2 action
  if (analogvalue22>threshold22  ) {
    //send flipping signal via OSC
    OscMessage myMessage = new OscMessage("/arduino2_2");
    myMessage.add(0);
    oscP5.send(myMessage, myRemoteLocation);
    myMessage = new OscMessage("/arduino2_2");
    myMessage.add(1);
    oscP5.send(myMessage, myRemoteLocation);
  }  
    //sensor 2,3 action
  if (analogvalue23>threshold23  ) {
    //send flipping signal via OSC
    OscMessage myMessage = new OscMessage("/arduino2_3");
    myMessage.add(0);
    oscP5.send(myMessage, myRemoteLocation);
    myMessage = new OscMessage("/arduino2_3");
    myMessage.add(1);
    oscP5.send(myMessage, myRemoteLocation);
  }  

//      OscMessage myMessage2 = new OscMessage("/live/play");
//    oscP5.send(myMessage2, myRemoteLocation);



//    int trackNum = 0;
//    int clipNum = 0;
//     
//    println("Track: " + trackNum + "  Clip: " + clipNum);
// 
//    OscMessage myMessage = new OscMessage("/live/play/clipslot");
//    myMessage.add(trackNum);
//    myMessage.add(clipNum);
//    oscP5.send(myMessage, myRemoteLocation);
//    
//    
//    clipNum = 1;
//     
//    println("Track: " + trackNum + "  Clip: " + clipNum);
//    
//    myMessage = new OscMessage("/live/play/clipslot");
//    myMessage.add(trackNum);
//    myMessage.add(clipNum);
//    oscP5.send(myMessage, myRemoteLocation);



  

}
