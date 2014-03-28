/**
* Testing LiveOSC.
* Just a testing of how to control Ableton Live with Processing
*
* Sends PLAY or STOP message to Live
* Handles 3 incoming messages:
*   /live/play
*   /live/clip/info
*   /live/volume
*/

import oscP5.*;
import netP5.*;
import controlP5.*;

//GUI library
ControlP5 controlP5;

//OSC related libraries
OscP5 oscP5;
NetAddress myRemoteLocation;

//Ports defined by LiveOSC,cannot be changed
int inPort = 9001;
int outPort = 9000;

void setup() {
  size(400,400);
  
  //OSC Server
  oscP5 = new OscP5(this,inPort);
  //Remote address
  myRemoteLocation = new NetAddress("localhost",outPort);
  
  //GUI settings and buttons
  frameRate(30);
  controlP5 = new ControlP5(this);
  controlP5.addButton("Play");
  controlP5.addButton("Stop");
  
  //OSC address mapping
  oscP5.plug(this,"incomingHandlerPlay","/live/play");
  oscP5.plug(this,"incomingHandlerClipInfo","/live/clip/info");
  oscP5.plug(this,"incomingHandlerVolume","/live/volume");
}

void draw() {
  background(0);
}
/**
* implements button click handler
* button: play
*
*/
void Play() {
  println("clicked play");
  OscMessage myMessage = new OscMessage("/live/play");
  oscP5.send(myMessage, myRemoteLocation); 
}
/**
* implements button click handler
* button: stop
*
*/
void Stop() {
  println("clicked stop");
  OscMessage myMessage = new OscMessage("/live/stop");
  oscP5.send(myMessage, myRemoteLocation);
 
}
/**
* implements incoming message handler.
* address: /live/play
*
* @param int state Current state of the song
*/
void incomingHandlerPlay(int state){
  switch(state){
    case 1:
      println("Song STOP");
      break;
    case 2:
      println("Song PLAY");
      break;
  }
}
/**
* implements incoming message handler.
* address: /live/clip/info
*
* @param int track Track number
* @param int clip Clip number
* @param int state Current state of the clip
*/
void incomingHandlerClipInfo(int track,int clip,int state){
  switch(state){
      //STOP
      case 1:
        println("Stopped clip - Track:"+track+" Clip:"+clip);
        break;
      //PLAY
      case 2:
        println("Playing clip - Track:"+track+" Clip:"+clip);
        break;
      //LAUNCHED
      case 3:
        println("Triggered clip - Track:"+track+" Clip:"+clip); 
       break; 
    }
}
/**
* implements incoming message handler.
* address: /live/volume
*
* @param int track Track number
* @param float value The actual volume of the track
*/
void incomingHandlerVolume(int track,float value){
  println("Track:" + track + " vol:"+value);    
}
/*
* OSC event handler
*/
void oscEvent(OscMessage theOscMessage) {
  
  if(theOscMessage.isPlugged()==false) {
    //we just print the not plugged messages.
    println("[NOT HANDLED] addr:" + theOscMessage.addrPattern() + " | typetag: " + theOscMessage.typetag());
  }
}