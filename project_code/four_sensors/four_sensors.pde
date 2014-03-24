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

import ddf.minim.*;
import ddf.minim.ugens.*;

// Declarations
OscP5 oscP5;
ControlP5 controlP5;
NetAddress myRemoteLocation;

Arduino arduino1;
Arduino arduino2;

Minim minim;
AudioOutput out;
AudioSample kick;
AudioSample snare;

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

float freq=100;
float duration=0.1;
float threshold0=1000;
float threshold1=1001;
float threshold2=1001;
float threshold3=1001;
float threshold4=700;

int trip0=0;
int trip1=0;
int trip4=0;



void setup() {
  
// make frame for the program
  size(800, 500);
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
//  arduino2 = new Arduino(this, "/dev/tty.usbmodem411", 57600);  
  
  
  
  // Alternatively, use the name of the serial port corresponding to your
  // Arduino (in double-quotes), as in the following line.
  //arduino = new Arduino(this, "/dev/tty.usbmodem621", 57600);
  
//  // Set the Arduino digital pins as inputs.
//  for (int i = 0; i <= 13; i++)
//    arduino1.pinMode(i, Arduino.INPUT);
//   // arduino2.pinMode(i, Arduino.INPUT);


  // Setup OSC
  oscP5 = new OscP5(this,9001); // was 9001
  myRemoteLocation = new NetAddress("localhost",9000);
   
  // Setup ControlP5
  controlP5 = new ControlP5(this);

  
  
  
  
// ***MAKE SURE TO LOAD MODIFIED STANDARDFIRMATA, THAT HAS analogReference(INTERNAL); IN THE LOOP() SO THAT VOLTAGES WILL BE CORRECT
 
 
 
 


//for audio:
      minim = new Minim(this);
  
// use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
    
// load BD.wav from the data folder
  kick = minim.loadSample( "BD.mp3", 512 );
    
// load SD.wav from the data folder
  snare = minim.loadSample("SD.wav", 512);



oscP5.plug(this,"incomingHandlerPlay","/live/play");

}


void draw() {
  background(color(20,20,20));
    stroke(on);
    fill(255, 255, 255);
  
//read in analog values from first arduino (rear port)
  analogvalue0=arduino1.analogRead(0);//channel is 0
  analogvalue1=arduino1.analogRead(1);//channel is 1
  analogvalue2=arduino1.analogRead(2);//channel is 2
  analogvalue3=arduino1.analogRead(3);//channel is 3
    analogvalue4=arduino1.analogRead(4);//channel is 4
  
//  analogvalue2=arduino2.analogRead(0);//channel is 0


//display values (value, x, y)
  text(analogvalue0,100,100);
  text(analogvalue1,200,100);
  text(analogvalue2,300,100);
  text(analogvalue3,400,100);
    text(analogvalue4,500,100);
  //display time (milliseconds)
text(millis(),400,200);

//draw bars indicating values (x,y,w,h,radius)
  fill(off);

  rect(100, 150, 20, 5*(analogvalue0-990), 5);
  rect(200, 150, 20, 5*(analogvalue1-990), 5);
  rect(300, 150, 20, 5*(analogvalue2-990), 5);
  rect(400, 150, 20, 5*(analogvalue3-990), 5);
  rect(500, 150, 20, 0.5*(analogvalue4-500), 5);
//  
  //indicators of threshold value(s)
  stroke(255);
  line(100,150+5*(threshold0-990),150,150+5*(threshold0-990));
line(200,150+5*(threshold1-990),250,150+5*(threshold1-990));
line(300,150+5*(threshold2-990),350,150+5*(threshold2-990));
line(400,150+5*(threshold3-990),450,150+5*(threshold3-990));
line(500,150+0.5*(threshold4-500),550,150+0.5*(threshold4-500));
  


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

//sensor 4 action
  if (analogvalue4>threshold4  ) {
    //send flipping signal via OSC
    OscMessage myMessage = new OscMessage("/arduino1_4");
    myMessage.add(0);
    oscP5.send(myMessage, myRemoteLocation);
    myMessage = new OscMessage("/arduino1_4");
    myMessage.add(1);
    oscP5.send(myMessage, myRemoteLocation);
     
     
      OscMessage myMessage2 = new OscMessage("/live/play");
    oscP5.send(myMessage2, myRemoteLocation);
    
    
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
  
  







  

}
