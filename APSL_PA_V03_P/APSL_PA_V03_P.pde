/* 

Arduino and Processing Serial Link
PA - Processing Side
Version 0.3

Provides a serial link, sending and receiving, between a computer running Processing and an Arduino.
Communicates with packets. 

Behavior
Broadcasts Ping packets with time stamp. Prints elapsed time for roundtrip.
Uses state machine to handle incoming packets.
Tracks status of incoming serial traffic as boolean.

Packet Format
  Start1
  Start2
  Length = TypeByte + number of payload bytes + CheckByte
  Type: specifies the kind of packet
  Payload (several bytes) 
  Checksum
  
TypeByte Key, Outgoing Packets
  1: Ping packet: Payload is one byte, value of millis()%255

TypeByte Key, Incoming Packets
  0: Error packet
  1: Ping packet: Payload is one byte, value of Processing millis()%255 when sent

*/


import processing.serial.*;

// diagnostic variables
boolean verbose = true;
int good = 0; // the number of good exchanges
int error = 0; // the number of errors

// serial variables
Serial serial; // initialize the serial port
boolean serialStatus = false; // "true" indicates the link is functional
int serialStatusTimer = 0; // holds the value of millis() when the last incoming byte was recieved
int serialStatusTimeout = 1000; // time after which Serial is considered diconnected, in milliseconds
byte serialStart1 = byte(113);
byte serialStart2 = byte(42);
int serialState = 0;
int[] serialPayloadIn = new int[10];
int inLength = 0;
int serialPayloadInLength = 0;
int serialPayloadInIndex = 0;
int serialChecksum = 0;


// *****


void setup(){
  
 // serial setup
 serial = new Serial(this, "/dev/tty.usbserial-A600e1oa", 115200); // XBee
 // serial = new Serial(this, "/dev/tty.usbmodemfd121", 115200); // MEGA2560 or UNO
 

 serial.clear();

 frameRate(10); // max number of times draw() is executed per second
 
 println("Waiting for Arduino to initialize");
 while (millis() < 2000){}
 
 println("setup() complete");
} //setup()


// *****


void draw(){
  println();
  
  if (serialStatusTimeout < millis()-serialStatusTimer) serialStatus = false;
  if (verbose == true) {
    print("serialStatus: ");
    println(serialStatus);
  }

  //serialSendRandomPacket();
  serialSendPingPacket();
  
} //draw()


// *****


// Called after each execution of draw()
// if there is serial data availble
void serialEvent(Serial serial){
  if (verbose == true) println("serialEvent");
  serialRxReader();
}

