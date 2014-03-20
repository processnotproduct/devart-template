// LiveOSC_Processing_SEND
// October 2012
//
// Setup functions
 
// ID ranges
int MIN_ID_CLIPS = 0;        // Clips 0-89  
int MAX_ID_CLIPS = 89;       //
int MIN_ID_SCENES = 90;      // Scenes 90-99
int MAX_ID_SCENES = 99;      //
int MIN_ID_STOPS = 100;      // Stops 100-108
int MAX_ID_STOPS = 108;      //
int ID_STOP_ALL = 109;       // Stop All 109
int MIN_ID_FADERS = 110;     // Faders 110-118
int MAX_ID_FADERS = 118;     //
int ID_MASTER_FADER = 119;   // Master Fader 119
int MIN_ID_MUTES = 120;      // Mutes 120-129
int MAX_ID_MUTES = 129;
int ID_PLAY = 200;           // Play 200
int ID_STOP = 201;           // Stop 201
 
Bang[][] myClips;
Bang[] myStops;
Bang[] myScenes;
Slider[] myFaders;
Slider masterFader;
Toggle[] myMutes;
Bang play;
Bang stop;
Bang stopAll;
 
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
 
 
// Setup and draw stops
void setupStops(int numCols)
{
  myStops = new Bang[numCols];
  for (columns = 0; columns < numCols; columns++)
  {
    myStops[columns] = controlP5.addBang("Stop" + columns, ((columns+1)*spacingX)-clipSize, ((NUM_CLIPS+1)*spacingY)-clipSize, clipSize, clipSize);
    myStops[columns].setLabel("Stop" + columns);
    myStops[columns].setId(MIN_ID_STOPS + columns);
    myStops[columns].align(ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER);
  }
 
  // Draw stop all
  stopAll = controlP5.addBang("StopAll", 740, ((NUM_CLIPS+1)*spacingY)-clipSize, clipSize, clipSize);
  stopAll.setLabel("Stop All");
  stopAll.setId(ID_STOP_ALL);
  stopAll.align(ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER);
}
 
 
// Setup and draw scenes
void setupScenes(int numRows)
{
  myScenes = new Bang[numRows];
 
  for (rows = 0; rows < numRows; rows++)
  {
    myScenes[rows] = controlP5.addBang("Scene" + rows, 740, ((rows+1)*spacingY)-clipSize, clipSize, clipSize);
    myScenes[rows].setLabel("Scene" + rows);
    myScenes[rows].setId(MIN_ID_SCENES + rows);
    myScenes[rows].align(ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER);
  }
}
 
 
// Setup and draw Faders
void setupFaders(int numFaders)
{
  myFaders = new Slider[numFaders];
  for (int i = 0; i < numFaders; i++)
  {
    myFaders[i] = controlP5.addSlider("Fader" + i, 0, 1, 100, spacingX*(1+i)-clipSize, 400, clipSize, 150);
    //myFaders[i].setLabel("Fader " + i);
    myFaders[i].setValue(0.84);
    myFaders[i].setId(110+i);
    // myFaders[i].align(0,0,0,ControlP5.CENTER);
  }
 
  // Master
  masterFader = controlP5.addSlider("masterFader", 0, 1, 100, 740, 400, clipSize, 150);
  masterFader.setLabel("Master");
  masterFader.setValue(0.84);
  masterFader.setId(119);
  //masterFader.setLabelVisible(false);
 
  // Query names
  OscMessage myMessage = new OscMessage("/live/name/track");
  oscP5.send(myMessage, myRemoteLocation);
}
 
 
// Setup and draw Mutes
void setupMutes(int numTracks)
{
  myMutes = new Toggle[numTracks];
  for (int t = 0; t < numTracks; t++)
  {
    myMutes[t] = controlP5.addToggle("Mute"+t, false, spacingX*(t+1)-clipSize, 575, clipSize, clipSize);
    myMutes[t].setId(MIN_ID_MUTES + t);
    myMutes[t].align(ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER);
  }
}
 
// Setup and draw Transport
void setupTransport()
{
  play = controlP5.addBang("Play", 610, 575, clipSize*2, clipSize);
  play.setId(ID_PLAY);
  play.align(ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER);
 
  stop = controlP5.addBang("Stop", 610+clipSize+55, 575, clipSize*2, clipSize);
  stop.setId(ID_STOP);
  stop.align(ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER);
}
