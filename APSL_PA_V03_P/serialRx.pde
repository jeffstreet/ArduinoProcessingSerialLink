// Called by serialEvent() after each execution of draw()
// if there is serial data availble
void serialRxReader(){
  if (verbose == true) println("serialRxReader");

  while(serial.available() > 0){
    
    int temp = serial.read();
    serialStatus = true;
    serialStatusTimer = millis();


  if (verbose == true){     
    print("Rx ");
    println(temp);
    print("State Start: ");
    println(serialState);
  }
    
    switch(serialState) {
      case 0: // Looking for S1
        if ((byte)temp == serialStart1) {
          serialState = 1;
          if (verbose == true) println("Got S1");
        }
        else {
          if (verbose == true) {
            print("S1 error: ");
            println(temp);
          }
        }
        break;
      case 1: // Looking for S2
        if ((byte)temp == serialStart2) {
          serialState = 2;
          if (verbose == true) println("Got S2");
        }
        else {
          serialRxReset();
          if (verbose == true) println("S2 error");
        }
        break;
      case 2: // Reading length
        if (temp>2){ //check for valid length
          serialPayloadInLength = temp;
          serialState = 3;
          if (verbose == true){
            print("Length is: ");
            println(serialPayloadInLength);
          }
        }
        else {
          serialRxReset();
          if (verbose == true) {
            print("Length error: ");
            println (serialPayloadInLength);
          }
        }
        break;
      case 3: // Reading payload
        serialPayloadIn[serialPayloadInIndex] = temp;
        serialPayloadInIndex++;
        if (verbose == true){
          print("Reading payload: ");
          print(serialPayloadInIndex);
          print(" of ");
          println(serialPayloadInLength);
        }
        if( serialPayloadInIndex >= serialPayloadInLength) {
          
          // compute checksums
          if (verbose == true) print("Checksum: ");
          for (int i=0; i<serialPayloadInLength-1; i++){
            serialChecksum += serialPayloadIn[i];
          }
          serialChecksum = serialChecksum%255;
          if (verbose == true) println(serialChecksum);

          
          // compare the checksums
          if ( serialChecksum == serialPayloadIn[serialPayloadInLength-1] ){
            if (verbose == true) println("Well formed packet");
            good ++;
            serialRxPacketHandler();
          }
          else{
            println("Malformed packet");
            error++;
          }
        serialRxReset();
        }
        break;
        
      default:
        serialRxReset();
        println("Default state error");
        break;
    }
    if (verbose == true){
      print("State End: ");
      println(serialState);
    }
    
  }
} //serialEvent()

// *****


// resets the state machine and sends a new packet
void serialRxReset(){ 
  serialState=0;
  serialPayloadInIndex=0;
  serialChecksum = 0;
  if (verbose == true) println("serialRxReset");
}// serialRxReset()

// *****


// takes action on the packet stored in serialPayloadIn[]
void serialRxPacketHandler(){
  if (verbose == true) print("Packet Type: ");
  
  // deal with the payload of the packet
  switch(serialPayloadIn[0]) { //first byte is the packet type
      case 0: // Error Packet
        // This is how the arduino comunicates errors to Processing
        print("Error: ");
        switch(serialPayloadIn[1]) { //error type byte
          case 1:
            println("Type 1");
            break;
          default:
            print("Unknown error type");
            println(serialPayloadIn[0]);            
            break;
        } // Error type switch
        break;
  
      case 1: // Ping packet
        print("Ping : ");
        println(millis()%255 - serialPayloadIn[1]);
        print("Good/Error = ");
        print(good);
        print("/");
        println(error);
        break;
        
      default:
        print("Packet type error: ");
        println(serialPayloadIn[0]);
        break;
  } // Packet type switch
  
}// serialRxPacketHandler()
