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

import processing.serial.*;

import cc.arduino.*;

Arduino arduino1;
Arduino arduino2;

//for audio=====================

import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;
AudioSample kick;
AudioSample snare;


// to make an Instrument we must define a class
// that implements the Instrument interface.
class SineInstrument implements Instrument
{
  Oscil wave;
  Line  ampEnv;
  
  SineInstrument( float frequency )
  {
    // make a sine wave oscillator
    // the amplitude is zero because 
    // we are going to patch a Line to it anyway
    wave   = new Oscil( frequency, 0, Waves.SINE );
    ampEnv = new Line();
    ampEnv.patch( wave.amplitude );
  }
  
  // this is called by the sequencer when this instrument
  // should start making sound. the duration is expressed in seconds.
  void noteOn( float duration )
  {
    // start the amplitude envelope
    ampEnv.activate( duration, 0.5f, 0 );
    // attach the oscil to the output so it makes sound
    wave.patch( out );
  }
  
  // this is called by the sequencer when the instrument should
  // stop making sound
  void noteOff()
  {
    wave.unpatch( out );
  }
}

  //=====================

color off = color(4, 79, 111);
color on = color(84, 145, 158);
color bgg= color(4, 79, 111);

float analogvalue0 = 0;
float analogvalue1 = 0;
float analogvalue2 = 0;
float analogvalue3 = 0;

float freq=100;
float duration=0.1;
float threshold0=995;
float threshold1=998;
float threshold2=1001;
float threshold3=1001;

int trip0=0;
int trip1=0;


void setup() {
  
// make frame for the program
  size(800, 500);

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




 //    MAKE SURE TO LOAD MODIFIED STANDARDFIRMATA, THAT HAS analogReference(INTERNAL); IN THE LOOP() SO THAT VOLTAGES WILL BE CORRECT
 
 
 
 


//for audio:
      minim = new Minim(this);
  
// use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
    
// load BD.wav from the data folder
  kick = minim.loadSample( "BD.mp3", 512 );
    
// load SD.wav from the data folder
  snare = minim.loadSample("SD.wav", 512);

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
  
//  analogvalue2=arduino2.analogRead(0);//channel is 0


//display values (value, x, y)
  text(analogvalue0,100,100);
  text(analogvalue1,200,100);
  text(analogvalue2,300,100);
  text(analogvalue3,400,100);
  //display time (milliseconds)
text(millis(),400,200);

//draw bars indicating values (x,y,w,h,radius)
  fill(off);

  rect(100, 150, 20, 5*(analogvalue0-990), 5);
  rect(200, 150, 20, 5*(analogvalue1-990), 5);
  rect(300, 150, 20, 5*(analogvalue2-990), 5);
  rect(400, 150, 20, 5*(analogvalue3-990), 5);
//  
  //indicators of threshold value(s)
  stroke(255);
  line(100,150+5*(threshold0-990),150,150+5*(threshold0-990));
line(200,150+5*(threshold1-990),250,150+5*(threshold1-990));
line(300,150+5*(threshold2-990),350,150+5*(threshold2-990));
line(400,150+5*(threshold3-990),450,150+5*(threshold3-990));
  


//sensor 0 action
// (if value is above threshold and has not been tripped)
  if (analogvalue0>threshold0  && trip0==0) {
    kick.trigger();
  } 
  if (analogvalue0<threshold0) {
    trip0=0;
  }  else {
   trip0=1; 
  }
  
//sensor 1 action
// (if value is above threshold and has not been tripped)
  if (analogvalue1>threshold1  && trip1==0) {
    snare.trigger();
    trip1=1;
  } else {
   trip1=0; 
  }  

  




  // Draw circles whose size corresponds to the value of an analog input.
//  noFill();
//  for (int i = 0; i <= 5; i++) {
//    ellipse(100 + i * 60, 240, analogvalue / 4, analogvalue / 4);
//  }
//  


//  //change background color
//  bgg= color(analogvalue*2-20, 79, 111);
  
//  freq=analogvalue*2+50;
//  duration=10/freq;
  
  //out.playNote(0,0.1,freq);
  

  
//  //waveforms
//   for(int i = 0; i < out.bufferSize() - 1; i++)
//  {
//
//    line( i, 150 + out.right.get(i)*50, i+1, 150 + out.right.get(i+1)*50 );
//  }
  

}
