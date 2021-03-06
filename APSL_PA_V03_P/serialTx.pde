
// sends a ping packet 
void serialSendPingPacket(){
  if (verbose == true) println("serialSendPingPacket()");
  byte[] byteArray = { 1 , byte(millis()%255) };
  serialWritePayloadAsPacket(byteArray);
}

// *****


// sends a packet of random length (0-10), containing random bytes (0-100) 
void serialSendRandomPacket(){
  // Make an array of random length from 1 to 10
  byte[] byteArray = new byte[int(random(9))+1];  
  
  // fill the array with randomness 
  for (int i = 0; i < byteArray.length; i++){
    byteArray[i] = byte(int(random(100)));
  }
  
  // Pass the array to a serialWritePayloadAsPacket()
  serialWritePayloadAsPacket(byteArray);
} //serialSendRandomPacket()

// *****


// Writes the contents of payload as a packet
// Input: byte array. First byte indicates packet type.
void serialWritePayloadAsPacket(byte[] payload){
  if (verbose == true) print("serialWritePayloadAsPacket {");
  
  // send start bytes
  serial.write(serialStart1);
  serial.write(serialStart2);
  if (verbose == true){ 
    print(byte(serialStart1));
    print(" ");
    print(byte(serialStart2));
    print(" ");
  }

  // send length
  serial.write(payload.length + 1);
  if (verbose == true){
    print(payload.length + 1);
    print(" ");
  }

 // send payload and compute checksum
 int serialChecksum = 0;
 for (int i = 0; i < payload.length; i++){

    serial.write(payload[i]);
    serialChecksum+=payload[i];
    if (verbose == true){
      print(payload[i]);
      print(" ");
    }
  }
  
  // send checksum
  serial.write(serialChecksum%255);
  if (verbose == true){
    print(serialChecksum%255);
    println("}");
  }
  
} // serialWritePayloadAsPacket()



