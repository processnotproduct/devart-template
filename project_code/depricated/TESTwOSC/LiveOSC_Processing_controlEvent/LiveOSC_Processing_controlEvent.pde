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
 
  // Scenes
  if (id >= MIN_ID_SCENES && id <= MAX_ID_SCENES)
  {
    OscMessage myMessage = new OscMessage("/live/play/scene");
    myMessage.add(id - MIN_ID_SCENES);
    oscP5.send(myMessage, myRemoteLocation);
  }
 
  // Faders
  if (id >= MIN_ID_FADERS && id <= MAX_ID_FADERS)
  { 
    OscMessage myMessage = new OscMessage("/live/volume");
    myMessage.add(id - MIN_ID_FADERS);
    myMessage.add(theEvent.getController().getValue());
    oscP5.send(myMessage, myRemoteLocation);
  }
 
  // Master Fader
  if (id == ID_MASTER_FADER)
  {
    OscMessage myMessage = new OscMessage("/live/master/volume");
    myMessage.add(theEvent.getController().getValue());
    oscP5.send(myMessage, myRemoteLocation);
  }
 
  // Stops
  if (id >= MIN_ID_STOPS && id <= MAX_ID_STOPS)
  {
    OscMessage myMessage = new OscMessage("/live/stop/track");
    myMessage.add(id - MIN_ID_STOPS);
    oscP5.send(myMessage, myRemoteLocation);
  }
 
  // Stop All
  if (id == ID_STOP_ALL)
  {
    for (int t = 0; t < NUM_TRACKS; t++)
    {
      OscMessage myMessage = new OscMessage("/live/stop/track");
      myMessage.add(t);
      oscP5.send(myMessage, myRemoteLocation);
    }
  }
 
  // Mutes
  if (id >= MIN_ID_MUTES && id <= MAX_ID_MUTES)
  {
    OscMessage myMessage = new OscMessage("/live/mute");
    myMessage.add(id - MIN_ID_MUTES);
    myMessage.add(theEvent.getController().getValue());
    oscP5.send(myMessage, myRemoteLocation);
  }
 
  // Play
  if (id == ID_PLAY)
  {
    OscMessage myMessage = new OscMessage("/live/play");
    oscP5.send(myMessage, myRemoteLocation);
  }
 
  // Stop
  if (id == ID_STOP)
  {
    OscMessage myMessage = new OscMessage("/live/stop");
    oscP5.send(myMessage, myRemoteLocation);
  }
}
