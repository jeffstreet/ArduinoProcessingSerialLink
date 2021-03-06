/* 

Arduino and Processing Serial Link
PA - Arduino Side
Version 0.1

Provides a serial link, sending and receiving, between a computer running Processing and an Arduino.

Behavior:
Listens for incoming bytes on Serial, and sends them back.
Tracks status of serial link with a boolean and the LED on pin 13.

*/

// Serial variables
boolean SerialStatus = false; // "true" indicates the link is functional
unsigned long SerialStatusTimer = 0; // holds the value of millis() when the last incoming byte was recieved
unsigned long SerialStatusTimeout = 1000; // time after which Serial is considered diconnected, in milliseconds

// LED variable
int led = 13;


// *****


void setup(){
  Serial.begin(115200); // open Serial
  
  pinMode(led, OUTPUT);  // initialize the LED pin
  digitalWrite(led, LOW);   // turn the LED off

} //setup()


// *****


void loop(){

  // check serial link status
  if (SerialStatusTimeout < millis() - SerialStatusTimer) {
    SerialStatus = false;
  }
  
  // set serial status LED
  if(SerialStatus) digitalWrite(led, HIGH);   // turn the LED on
  else digitalWrite(led, LOW);   // turn the LED off
  
} //loop()


// *****


// Called after each execution of loop()
// if there is serial data availble
void serialEvent(){
  Serial.write(Serial.read()); // send the byte back
  SerialStatus = true;
  SerialStatusTimer = millis();
} // serialEvent()
