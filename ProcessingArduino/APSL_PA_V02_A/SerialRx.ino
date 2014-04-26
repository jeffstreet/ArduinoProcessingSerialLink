// Called by serialEvent() after each execution of draw()
// if there is serial data availble
void serialRxReader(){
  digitalWrite(47, HIGH);
  
  while(Serial.available()>0){
    
    int temp = Serial.read(); //grab a byte
    
    switch(SerialState) {
      case 0: // Looking for S1
        if ((byte)temp == SerialStart1) {
          SerialState = 1;
        }
        break;
      case 1: // Looking for S2
        if ((byte)temp == SerialStart2) {
          SerialState = 2;
          digitalWrite(49, HIGH); 
        }
        else resetS();
        break;
      case 2: // Reading length
        if (temp > 2){ //check for valid length
          SerialPayloadInLength = temp;
          SerialState = 3;
        }
        else resetS();
        break;
      case 3: // Reading payload
        SerialPayloadIn[SerialPayloadInIndex] = temp;
        SerialPayloadInIndex++;
        
        if( SerialPayloadInIndex == SerialPayloadInLength) { // if we have read the whole payload
          // compute checksum
          SerialChecksum = 0;
          for (int i=0; i<SerialPayloadInIndex-1; i++){
            SerialChecksum += SerialPayloadIn[i];
          }
          SerialChecksum = SerialChecksum%255;
          
          // verify checksum
          if ( (SerialChecksum == SerialPayloadIn[SerialPayloadInLength-1]) ){
            digitalWrite(51, HIGH);
            // we got a good packet
            SerialStatusTimer = millis();
            handlePacketS();
            //resetS(); // REMOVE this when handlePacketS is implemented
            
          }
          else{
            // errorS(1); // IMPLEMENT send a checksum error packet
          }
          resetS();
        }
        break;
      default:
        // there's been a state machine error
        resetS();
    } // switch
  } // while
} // serialRxReader


// *****


// takes action on the packet stored in SerialPayloadIn[]
void handlePacketS(){
  
  switch(SerialPayloadIn[0]) { // first byte is the packet type
      case 1: // Ping packet
        // send back the payload
        serialWritePayloadAsPacket(SerialPayloadIn, SerialPayloadInLength);
        break;

      default: // Unknown packet type
        // send error packet, unknown packet type
         // errorS(2); //IMPLEMENT
        break;
  } // switch
  
} // handlePacketS


// *****


// sets state machine back to state 0
void resetS(){ 
  SerialState=0;
  SerialPayloadInIndex=0;
} // resetS
