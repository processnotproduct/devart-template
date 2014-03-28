 
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

Arduino arduino;
Minim minim;
AudioOutput out;
AudioSample kick;
AudioSample snare;

// Global variables
int columns;
int rows;
int NUM_TRACKS = 8;    // Current max TOTAL clips: 89
int NUM_CLIPS = 6;     // Adjust IDs in SetupDraw for more total clips
String name;
  
// Spacing between controls and size
int spacingX = 62;
int spacingY = 52;
int clipSize = 38;

//=====================

  color off = color(4, 79, 111);
  color on = color(84, 145, 158);
  color bgg = color(4, 79, 111);
  float analogvalue = 0;
  float freq = 100;
  float durr = 0.1;
  float threshhi = 70;
  float threshlo = 65;
  int tripval = 0;
  int tripval2 = 0;
  float counter2 = 0;
  int outputvoltage = 1;
  
// Setup loops
void setup()
{
  // Window properties
  size(800,700);
  frameRate(25);
  
  // Setup Arduino
  arduino = new Arduino(this, Arduino.list()[5], 57600);
  
  // Set the Arduino digital pins as inputs.
  for (int i = 0; i <= 13; i++)
  arduino.pinMode(i, Arduino.INPUT);
    
  //for audio:
  minim = new Minim(this);
  
  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
   
  // Setup OSC
  oscP5 = new OscP5(this,9001);
  myRemoteLocation = new NetAddress("localhost",9000);
   
  // Setup ControlP5
  controlP5 = new ControlP5(this);
  
  // Call setup functions
  setupClips(NUM_TRACKS, NUM_CLIPS);
//  setupScenes(NUM_CLIPS);
//  setupFaders(NUM_TRACKS);
//  setupStops(NUM_TRACKS);
//  setupMutes(NUM_TRACKS);
//  setupTransport();
   
  // OSC querying
}


void draw()
{
  // Clear frame
  background(0);
}

void oscEvent(OscMessage theOscMessage)
{
  String msg = theOscMessage.addrPattern();
  String args = theOscMessage.typetag();
   
  int track = 0;
  int clip = 0;
  int armed = 0;
  int clipStatus = 0;
  String name;
  float beats = 0;
 
  // println(msg);
 
  if (msg.equals("/live/track/info"))
  {
    // iiiifiifiifiifiifiifiifiifiifiifiifiifiifiifiifiifiifiifiifiif
     
    track = theOscMessage.get(0).intValue();
 
    int v = 0;
 
    //for(int i = 0; i < 5; i++)
    //{
    v = 0;
    track = theOscMessage.get(v).intValue();
    armed = theOscMessage.get(v+1).intValue();
    clip = theOscMessage.get(v+2).intValue();
    clip = theOscMessage.get(v+3).intValue();
    beats = theOscMessage.get(v+4).floatValue();
    //}
 
    //println("OSC Receive: " + " Track " + track + " Armed " + armed + " Clip1: " + clip + " C1 Status: " + clipStatus + " C1 Beats: " + beats);
  }
 
  if (msg.equals("/live/clip/info"))
  {  
    print(msg + "  " + args);
     
    track = theOscMessage.get(0).intValue();
    clip = theOscMessage.get(1).intValue();
    clipStatus = theOscMessage.get(2).intValue();
 
    if (track <= NUM_TRACKS && clip <= NUM_CLIPS && clipStatus > 0)
    {
      myClips[track][clip].getColor().setForeground(0xffff0000);
    }
     
    else if(track <= NUM_TRACKS && clip <= NUM_CLIPS && clipStatus == 0)
    {
      //myClips[track][clip].getColor().setForeground(0xff000000);
    }
  }
 
  if (msg.equals("/live/name/track"))
  {
    track = theOscMessage.get(0).intValue();
    name = theOscMessage.get(1).stringValue();
 
    if (track < NUM_TRACKS)
    {
//      myFaders[track].setLabel("" + name);
 
     //  println("Track: " + track + "  Name: " + name);
    }
  }
 
  if (msg.equals("/live/name/clip"))
  {
    track = theOscMessage.get(0).intValue();
    clip = theOscMessage.get(1).intValue();
    name = theOscMessage.get(2).stringValue();
 
    if (track < NUM_TRACKS && clip < NUM_CLIPS)
    {
      myClips[track][clip].setLabel("" + name);
      // println("Clip: " + track + "  Name: " + name);
    }
     
    else
    {
      myClips[track][clip].setLabel("");
    }
  }
}


// LiveOSC_Processing_SEND
// October 2012
//
// Setup functions
 
// ID ranges
int MIN_ID_CLIPS = 0;        // Clips 0-89  
int MAX_ID_CLIPS = 89;       //
//int MIN_ID_SCENES = 90;      // Scenes 90-99
//int MAX_ID_SCENES = 99;      //
//int MIN_ID_STOPS = 100;      // Stops 100-108
//int MAX_ID_STOPS = 108;      //
//int ID_STOP_ALL = 109;       // Stop All 109
//int MIN_ID_FADERS = 110;     // Faders 110-118
//int MAX_ID_FADERS = 118;     //
//int ID_MASTER_FADER = 119;   // Master Fader 119
//int MIN_ID_MUTES = 120;      // Mutes 120-129
//int MAX_ID_MUTES = 129;
//int ID_PLAY = 200;           // Play 200
//int ID_STOP = 201;           // Stop 201
 
Bang[][] myClips;
//Bang[] myStops;
//Bang[] myScenes;
//Slider[] myFaders;
//Slider masterFader;
//Toggle[] myMutes;
//Bang play;
//Bang stop;
//Bang stopAll;
 
// Setup and draw clips
void setupClips(int numCols, int numRows)
{
  int clipNumber = 0;
 
  myClips = new Bang[numCols][numRows];
  for (int r = 0; r < numRows; r++)
  {
    for (int c = 0; c < numCols; c++)
    {
      myClips[c][r] = controlP5.addBang("C" + clipNumber, ((c+1)*spacingX)-clipSize, ((r+1)*spacingY)-clipSize, clipSize, clipSize);
      myClips[c][r].setId(clipNumber);
      myClips[c][r].setLabel("");
      myClips[c][r].align(ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER);
      // myClips[c][r].getColor().setForeground(0xffff0000);
      // myClips[c][r].setLabelVisible(false);
      // println(myClips[c][r].getColor());
 
      clipNumber++;
    }
  }
   
  // Query names
  OscMessage myMessage = new OscMessage("/live/name/clip");
  oscP5.send(myMessage, myRemoteLocation);
   
  OscMessage myMessage2 = new OscMessage("/live/track/info");
  oscP5.send(myMessage2, myRemoteLocation);
   
  /*for (int t = 0; t < NUM_TRACKS; t++)
  {
    for (int c = 0; c < NUM_CLIPS; t++)
    {
      OscMessage myMessage3 = new OscMessage("/live/clip/info");
      myMessage3.add(t);
      myMessage3.add(c);
      oscP5.send(myMessage3, myRemoteLocation);
    }
  }*/
}
 
 
//// Setup and draw stops
//void setupStops(int numCols)
//{
//  myStops = new Bang[numCols];
//  for (columns = 0; columns < numCols; columns++)
//  {
//    myStops[columns] = controlP5.addBang("Stop" + columns, ((columns+1)*spacingX)-clipSize, ((NUM_CLIPS+1)*spacingY)-clipSize, clipSize, clipSize);
//    myStops[columns].setLabel("Stop" + columns);
//    myStops[columns].setId(MIN_ID_STOPS + columns);
//    myStops[columns].align(ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER);
//  }
// 
//  // Draw stop all
//  stopAll = controlP5.addBang("StopAll", 740, ((NUM_CLIPS+1)*spacingY)-clipSize, clipSize, clipSize);
//  stopAll.setLabel("Stop All");
//  stopAll.setId(ID_STOP_ALL);
//  stopAll.align(ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER);
//}
 
 
//// Setup and draw scenes
//void setupScenes(int numRows)
//{
//  myScenes = new Bang[numRows];
// 
//  for (rows = 0; rows < numRows; rows++)
//  {
//    myScenes[rows] = controlP5.addBang("Scene" + rows, 740, ((rows+1)*spacingY)-clipSize, clipSize, clipSize);
//    myScenes[rows].setLabel("Scene" + rows);
//    myScenes[rows].setId(MIN_ID_SCENES + rows);
//    myScenes[rows].align(ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER);
//  }
//}
 
 
//// Setup and draw Faders
//void setupFaders(int numFaders)
//{
//  myFaders = new Slider[numFaders];
//  for (int i = 0; i < numFaders; i++)
//  {
//    myFaders[i] = controlP5.addSlider("Fader" + i, 0, 1, 100, spacingX*(1+i)-clipSize, 400, clipSize, 150);
//    //myFaders[i].setLabel("Fader " + i);
//    myFaders[i].setValue(0.84);
//    myFaders[i].setId(110+i);
//    // myFaders[i].align(0,0,0,ControlP5.CENTER);
//  }
// 
//  // Master
//  masterFader = controlP5.addSlider("masterFader", 0, 1, 100, 740, 400, clipSize, 150);
//  masterFader.setLabel("Master");
//  masterFader.setValue(0.84);
//  masterFader.setId(119);
//  //masterFader.setLabelVisible(false);
// 
//  // Query names
//  OscMessage myMessage = new OscMessage("/live/name/track");
//  oscP5.send(myMessage, myRemoteLocation);
//}
 
 
//// Setup and draw Mutes
//void setupMutes(int numTracks)
//{
//  myMutes = new Toggle[numTracks];
//  for (int t = 0; t < numTracks; t++)
//  {
//    myMutes[t] = controlP5.addToggle("Mute"+t, false, spacingX*(t+1)-clipSize, 575, clipSize, clipSize);
//    myMutes[t].setId(MIN_ID_MUTES + t);
//    myMutes[t].align(ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER);
//  }
//}
 
//// Setup and draw Transport
//void setupTransport()
//{
//  play = controlP5.addBang("Play", 610, 575, clipSize*2, clipSize);
//  play.setId(ID_PLAY);
//  play.align(ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER);
// 
//  stop = controlP5.addBang("Stop", 610+clipSize+55, 575, clipSize*2, clipSize);
//  stop.setId(ID_STOP);
//  stop.align(ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER);
//}

// LiveOSC_Processing_controlEvent
// October 2012
//
// Controller actions for ControlP5 objects
 
 
void controlEvent(ControlEvent theEvent)
{
  int id = theEvent.getController().getId();
  // println("ControlEvent ID: " + id + "  Value: " + theEvent.getController().getValue());
 
  // Clips
  if (id >= MIN_ID_CLIPS && id <= MAX_ID_CLIPS)
  {
    int trackNum = id % NUM_TRACKS;
    int clipNum = (id - trackNum) / NUM_TRACKS;
     
    println("Track: " + trackNum + "  Clip: " + clipNum);
 
    OscMessage myMessage = new OscMessage("/live/play/clipslot");
    myMessage.add(trackNum);
    myMessage.add(clipNum);
    oscP5.send(myMessage, myRemoteLocation);
  }
 
//  // Scenes
//  if (id >= MIN_ID_SCENES && id <= MAX_ID_SCENES)
//  {
//    OscMessage myMessage = new OscMessage("/live/play/scene");
//    myMessage.add(id - MIN_ID_SCENES);
//    oscP5.send(myMessage, myRemoteLocation);
//  }
// 
//  // Faders
//  if (id >= MIN_ID_FADERS && id <= MAX_ID_FADERS)
//  { 
//    OscMessage myMessage = new OscMessage("/live/volume");
//    myMessage.add(id - MIN_ID_FADERS);
//    myMessage.add(theEvent.getController().getValue());
//    oscP5.send(myMessage, myRemoteLocation);
//  }
// 
//  // Master Fader
//  if (id == ID_MASTER_FADER)
//  {
//    OscMessage myMessage = new OscMessage("/live/master/volume");
//    myMessage.add(theEvent.getController().getValue());
//    oscP5.send(myMessage, myRemoteLocation);
//  }
// 
//  // Stops
//  if (id >= MIN_ID_STOPS && id <= MAX_ID_STOPS)
//  {
//    OscMessage myMessage = new OscMessage("/live/stop/track");
//    myMessage.add(id - MIN_ID_STOPS);
//    oscP5.send(myMessage, myRemoteLocation);
//  }
// 
//  // Stop All
//  if (id == ID_STOP_ALL)
//  {
//    for (int t = 0; t < NUM_TRACKS; t++)
//    {
//      OscMessage myMessage = new OscMessage("/live/stop/track");
//      myMessage.add(t);
//      oscP5.send(myMessage, myRemoteLocation);
//    }
//  }
// 
//  // Mutes
//  if (id >= MIN_ID_MUTES && id <= MAX_ID_MUTES)
//  {
//    OscMessage myMessage = new OscMessage("/live/mute");
//    myMessage.add(id - MIN_ID_MUTES);
//    myMessage.add(theEvent.getController().getValue());
//    oscP5.send(myMessage, myRemoteLocation);
//  }
// 
//  // Play
//  if (id == ID_PLAY)
//  {
//    OscMessage myMessage = new OscMessage("/live/play");
//    oscP5.send(myMessage, myRemoteLocation);
//  }
// 
//  // Stop
//  if (id == ID_STOP)
//  {
//    OscMessage myMessage = new OscMessage("/live/stop");
//    oscP5.send(myMessage, myRemoteLocation);
//  }
}
