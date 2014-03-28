/*
 Fade
 
 This example shows how to fade an LED on pin 9
 using the analogWrite() function.
 
 This example code is in the public domain.
 */

int sensorPin = A0;    // select the input pin for the potentiometer
int LEDpin = 9;           // the pin that the LED is attached to
int brightness = 0;    // how bright the LED is
int fadeAmount = 5;    // how many points to fade the LED by
int sensorValue = 0;  // variable to store the value coming from the sensor
int ambient=74; //ambient reading.  room is about 66

// the setup routine runs once when you press reset:
void setup()  { 
  // declare pin 9 to be an output:
  pinMode(LEDpin, OUTPUT);
  
  Serial.begin(9600);          //  setup serial
} 

// the loop routine runs over and over again forever:
void loop()  { 
  
//  // read the input on analog pin 0:
//  int sensorValue = analogRead(A0);
//  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
//  float voltage = sensorValue * (5.0 / 1023.0);
//  // print out the value you read:
//  Serial.println(voltage);
  
    // read the value from the sensor:
  sensorValue = analogRead(sensorPin); 
  Serial.println(sensorValue);             // debug value
  //positive pressure value goes from about 66 to 125
  
  brightness=(sensorValue-ambient)*255/(125-ambient);
  if(brightness<0){brightness=0;}
  if(brightness>255){brightness=255;}//coerce values
  // set the brightness of pin:
  analogWrite(LEDpin, brightness);    




  // wait for 30 milliseconds to see the dimming effect    
  delay(30);         

  
}
