/*
arduino_input

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

Arduino arduino;

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
float analogvalue = 0;
float freq=100;
float durr=0.1;
float threshhi=80;
float threshlo=40;
int tripval=0;
int tripval2=0;
float counter2=0;
int outputvoltage=1;

void setup() {
  size(470, 280);

  // Prints out the available serial ports.
  println(Arduino.list());
  
  // Modify this line, by changing the "0" to the index of the serial
  // port corresponding to your Arduino board (as it appears in the list
  // printed by the line above).
  arduino = new Arduino(this, Arduino.list()[5], 57600);
  
  // Alternatively, use the name of the serial port corresponding to your
  // Arduino (in double-quotes), as in the following line.
  //arduino = new Arduino(this, "/dev/tty.usbmodem621", 57600);
  
  // Set the Arduino digital pins as inputs.
  for (int i = 0; i <= 13; i++)
    arduino.pinMode(i, Arduino.INPUT);
    
    //for audio:
    
      minim = new Minim(this);
  
  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
    
      // load BD.wav from the data folder
  kick = minim.loadSample( "BD.mp3", // filename
                            512      // buffer size
                         );
    
      // load SD.wav from the data folder
  snare = minim.loadSample("SD.wav", 512);
  if ( snare == null ) println("Didn't get snare!");


}

void draw() {
  background(bgg);
  stroke(on);
  
  analogvalue=arduino.analogRead(0);//channel is 0
  



  if (analogvalue-66 < 1) {
    outputvoltage=1;
  } else {
    outputvoltage=int(analogvalue-66);
  }
  
  arduino.analogWrite(9,outputvoltage);





      fill(off);
      rect(400, 30, 20, analogvalue, 5);
  line(400,30+threshhi,450,30+threshhi);
  line(400,30+threshlo,450,30+threshlo);

  // Draw a circle whose size corresponds to the value of an analog input.
  noFill();
  for (int i = 0; i <= 5; i++) {
    ellipse(100 + i * 60, 240, analogvalue / 4, analogvalue / 4);
  }
  
  
  bgg= color(analogvalue*2-20, 79, 111);
  freq=analogvalue*2+50;
  durr=10/freq;
  
  text(analogvalue,100,100);
text(millis(),200,100);
  
  //out.playNote(0,0.1,freq);


  if (analogvalue>threshhi  && tripval==1) {
    
    kick.trigger();

  
     
  }
  
    if (analogvalue<threshlo &&  tripval2==1) {
    snare.trigger();
  
      for (int i =0; i<=50; i++){
       arduino.analogWrite(9,255);
      }
  }
  
  if (analogvalue<threshhi) {
    tripval=1 ;
  } else {
    tripval=0;
  }
  
    if (analogvalue>threshlo) {
    tripval2=1 ;
  } else {
    tripval2=0;
  }
  
  //waveforms
   for(int i = 0; i < out.bufferSize() - 1; i++)
  {

    line( i, 150 + out.right.get(i)*50, i+1, 150 + out.right.get(i+1)*50 );
  }
  

}
