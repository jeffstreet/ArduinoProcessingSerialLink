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
  StartByte1
  StartByte2
  LengthByte = 2 + number of payload bytes
  TypeByte: specifies the kind of packet.
  Payload Bytes
  CheckByte
  
TypeByte Key, Outgoing Packets
  1: Ping packet: Payload is one byte, value of millis()%255

TypeByte Key, Incoming Packets
  0: Error packet
  1: Ping packet: Payload is one byte, echo of incoming Ping payload

*/


import processing.serial.*;

// serial diagnostic
boolean verbose = true;
int good = 0; // the number of good exchanges
int error = 0; // the number of errors

// serial setup
Serial serial; // initialize the serial port
boolean serialStatus = false; // "true" indicates the link is functional
int serialStatusTimer = 0; // holds the value of millis() when the last incoming byte was recieved
int serialStatusTimeout = 1000; // time after which Serial is considered diconnected, in milliseconds
byte start1 = byte(113);
byte start2 = byte(42);
int state = 0;
int inLength = 0;
int[] payloadIn = new int[10];
int payloadInLength = 3;
int payloadInIndex = 0;
int checksum = 0;


// *****


void setup(){
  
 // open the serial port
 serial = new Serial(this, "/dev/tty.usbmodem111", 115200); //MEGA2560 or UNO
 serial.clear();

 frameRate(10); // max number of times draw() is executed per second

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

