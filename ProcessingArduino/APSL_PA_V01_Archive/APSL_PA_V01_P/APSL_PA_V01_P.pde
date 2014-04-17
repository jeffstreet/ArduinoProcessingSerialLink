/* 

Arduino and Processing Serial Link
PA - Processing Side
Version 0.1

Provides a serial link, sending and receiving, between a computer running Processing and an Arduino.

Behavior
Broadcasts byte 255 until it hears a reply. 
Then, sends random bytes between 0 and 100, at a rate specified by frameRate(N). 
Prints sent bytes and any received bytes.
packetHandler() checks incoming format
Tracks serial link status with a boolean.

*/


import processing.serial.*;
Serial serial; // initialize the serial port 
boolean serialStatus = false; // "true" indicates the link is functional
int serialStatusTimer = 0; // holds the value of millis() when the last incoming byte was recieved
int serialStatusTimeout = 1000; // time after which Serial is considered diconnected, in milliseconds


void setup(){
  
 // open the serial port
 serial = new Serial(this, "/dev/tty.usbmodemfa131", 115200); //MEGA2560 or UNO
 serial.clear();

 frameRate(10); // max number of times draw() is executed per second

 println("setup() complete");
} //setup()


void draw(){
  println();
  
  if (serialStatusTimeout < millis()-serialStatusTimer) serialStatus = false;
    
  if (serialStatus){
    // send a random byte between 0 and 100
    int sentNum = int(random(100));
    serial.write(byte(sentNum));
    print("Tx ");
    println(sentNum);
  }
  
  else{
    serial.write(byte(255));
    println("Tx 255");
  }
  
} //draw()


// Called after each execution of draw()
// if there is serial data availble
void serialEvent(Serial serial){
  while(serial.available() > 0){
    print("Rx ");
    println(serial.read());
    serialStatus = true;
    serialStatusTimer = millis();
  }
} //serialEvent()
