void serialWritePayloadAsPacket(byte payload[], int length){
  digitalWrite(53, HIGH);

  Serial.write(SerialStart1);
  Serial.write(SerialStart2);
  Serial.write((byte)length);
  
  // send payload and compute checksum
  int checksum = 0;
  for(int i=0; i<length-1; i++){
   Serial.write(payload[i]);
   checksum += payload[i];
  }
  
  // send checksum
  Serial.write((byte)checksum%255);
} // serialWritePayloadAsPacket()
