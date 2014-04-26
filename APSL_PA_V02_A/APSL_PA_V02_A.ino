/* 

Arduino and Processing Serial Link
PA - Arduino Side
Version 0.2

Provides a serial link, sending and receiving, between a computer running Processing and an Arduino.

Behavior:
Uses state machine to handle incoming packets. Example ping packets implemented.
Tracks status of serial link with a boolean and the SerialStatusLED on pin 13.
Tracks status of arduino serial actions with LED on pins 47, 49, 51, 53.

Packet Format
  Start1
  Start2
  Length = TypeByte + number of payload bytes + CheckByte
  Type: specifies the kind of packet
  Payload (several bytes) 
  Checksum
  
TypeByte Key, Outgoing Packets
  0: Error packet
  1: Ping packet: Payload is one byte, echo of incoming ping payload

TypeByte Key, Incoming Packets
  1: Ping packet: Payload is one byte, value of sender's millis()%255


*/

// Serial variables
boolean SerialStatus = false; // "true" indicates the link is functional
unsigned long SerialStatusTimer = 0; // holds the value of millis() when the last incoming byte was recieved
unsigned long SerialStatusTimeout = 1000; // time after which Serial is considered diconnected, in milliseconds
int SerialStatusLED = 13; // pin for the LED that shows Serial link status
byte SerialStart1 = 113;
byte SerialStart2 = 42;
int SerialState = 0;
byte SerialPayloadIn[10];
int SerialPayloadInLength;
int SerialPayloadInIndex = 0;
int SerialChecksum = 0;


// *****


void setup(){
  Serial.begin(115200); // open Serial
  
  // diagnostic variables
  pinMode(SerialStatusLED, OUTPUT);  // initialize SerialStatusLED pin
  digitalWrite(SerialStatusLED, LOW);   // turn SerialStatusLED off
  pinMode(47, OUTPUT);
  pinMode(49, OUTPUT);
  pinMode(51, OUTPUT);
  pinMode(53, OUTPUT);
  digitalWrite(47, LOW);    // set LED off
  digitalWrite(49, LOW);    // set LED off
  digitalWrite(51, LOW);    // set LED off
  digitalWrite(53, LOW);    // set LED off

} //setup()


// *****


void loop(){

  // check serial link status
  if (SerialStatusTimeout < millis() - SerialStatusTimer) {
    SerialStatus = false;
  }
  else SerialStatus = true;
  
  // update SerialStatusLED
  if(SerialStatus) digitalWrite(SerialStatusLED, HIGH);   // turn the SerialStatusLED on
  else digitalWrite(SerialStatusLED, LOW);   // turn the SerialStatusLED off
  
  digitalWrite(47, LOW);    // set LED off
  digitalWrite(49, LOW);    // set LED off
  digitalWrite(51, LOW);    // set LED off
  digitalWrite(53, LOW);    // set LED off
  
} //loop()


// *****


// Called after each execution of loop()
// if there is serial data availble
void serialEvent(){
  serialRxReader();
} // serialEvent()
