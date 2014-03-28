# Sound Through Air and Code
Play differently ...

## Authors
- Tyson Kemp https://github.com/processnotproduct
- Trevor Kemp https://github.com/thkemp

## Description
We are creating an instrument that feels different and is closely linked to the visualization that would be created from that music. By using the air pressure of a rubber ball to actuate and effect the sound the player would feel a different type of connection to their musical expression.

The air pressure changes first trigger the sound then the manipulate the sound either by changing the volume, pitch, repeat, or many other variables of the sound.



## Link to Prototype
Coming soon ...
<!--NOTE: If your project lives online you can add one or more links here. Make sure you have a stable version of your project running before linking it.

[Example Link](http://www.google.com "Example Link")-->

## Example Code
Imma firin' muh snares!
```
  if (analogvalue0>threshold0  ) {
    //send flipping signal via OSC
    OscMessage myMessage = new OscMessage("/arduino1_0");
    myMessage.add(0);
    oscP5.send(myMessage, myRemoteLocation);
    myMessage = new OscMessage("/arduino1_0");
    myMessage.add(1);
    oscP5.send(myMessage, myRemoteLocation);
    
  } 
```
## Links to External Libraries
oscP5, netP5, controlP5 - http://www.sojamo.de/libraries/oscP5/

Arduino - http://www.arduino.cc/

OSCulator - http://www.osculator.net/

Ableton Live - https://www.ableton.com/
<!-- NOTE: You can also use this space to link to external libraries or Github repositories you used on your project.

[Example Link](http://www.google.com "Example Link")
-->
## Images & Videos
Coming soon ...
<!--NOTE: For additional images you can either use a relative link to an image on this repo or an absolute link to an externally hosted image.

![Example Image](project_images/cover.jpg?raw=true "Example Image")

https://www.youtube.com/watch?v=30yGOxJJ2PQ-->
