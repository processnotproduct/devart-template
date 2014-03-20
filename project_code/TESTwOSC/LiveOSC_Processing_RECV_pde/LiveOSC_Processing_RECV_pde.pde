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
      // myClips[track][clip].getColor().setForeground(0xff000000);
    }
  }
 
  if (msg.equals("/live/name/track"))
  {
    track = theOscMessage.get(0).intValue();
    name = theOscMessage.get(1).stringValue();
 
    if (track < NUM_TRACKS)
    {
      myFaders[track].setLabel("" + name);
 
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
