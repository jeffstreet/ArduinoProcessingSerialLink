/* 

Arduino and Processing Serial Link
PA - Processing Side
Version 0.2

Provides a serial link, sending and receiving, between a computer running Processing and an Arduino.
Communicates with packets. 

Behavior
Broadcasts packets of random length (1 to 10 bytes) with random contents (bytes 0-100), 
at a rate specified by frameRate(N).
Prints sent packets and any received bytes.
Tracks status of incoming serial traffic a boolean.

Packet format
  StartByte1
  StartByte2
  LengthByte = 2 + number of payload bytes
  TypeByte: specifies the 
  Payload Bytes
  CheckByte

*/


import processing.serial.*;
Serial serial; // initialize the serial port 
boolean serialStatus = false; // "true" indicates the link is functional
int serialStatusTimer = 0; // holds the value of millis() when the last incoming byte was recieved
int serialStatusTimeout = 1000; // time after which Serial is considered diconnected, in milliseconds

byte start1 = byte(113);
byte start2 = byte(42);


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
    
  makeRandomPayload();
  
} //draw()


// creates a payload array of random length, containing random bytes 
void makeRandomPayload(){
    // Make an array of random length from 1 to 10
  byte[] byteArray = new byte[int(random(9))+1];  
  
  // fill the array with randomness 
  for (int i = 0; i < byteArray.length; i++){
    byteArray[i] = byte(int(random(100)));
  }
  
  // Pass the array to a serialWritePayload()
  serialWritePayload(byteArray);
} //makeRandomPayload()


// writes the contents of payload as a packet
void serialWritePayload(byte[] payload){
  print("serialWritePayload {");
  
  // send start bytes
  print(byte(start1));
  print(" ");
  serial.write(start1);
  print(byte(start2));
  print(" ");
  serial.write(start2);

  // send length
  print(payload.length + 1);
  print(" ");
  serial.write(payload.length + 1);

 // send payload and compute checksum
 int checksum = 0;
 for (int i = 0; i < payload.length; i++){
    print(payload[i]);
    print(" ");
    serial.write(payload[i]);
    checksum+=payload[i];
  }
  
  // send checksum
  print(checksum%255);
  println("}");
  serial.write(checksum%255);
  
} // serialWritePayload()



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
