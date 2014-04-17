// Called after each execution of draw()
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
    println(state);
  }
    
    switch(state) {
      case 0: // Looking for S1
        if ((byte)temp == start1) {
          state = 1;
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
        if ((byte)temp == start2) {
          state = 2;
          if (verbose == true) println("Got S2");
        }
        else {
          serialRxReset();
          if (verbose == true) println("S2 error");
        }
        break;
      case 2: // Reading length
        if (temp>2){ //check for valid length
          payloadInLength = temp;
          state = 3;
          if (verbose == true){
            print("Length is: ");
            println(payloadInLength);
          }
        }
        else {
          serialRxReset();
          if (verbose == true) {
            print("Length error: ");
            println (payloadInLength);
          }
        }
        break;
      case 3: // Reading payload
        payloadIn[payloadInIndex] = temp;
        payloadInIndex++;
        if (verbose == true){
          print("Reading payload: ");
          print(payloadInIndex);
          print(" of ");
          println(payloadInLength);
        }
        if( payloadInIndex >= payloadInLength) {
          
          // compute checksums
          if (verbose == true) print("Checksum: ");
          for (int i=0; i<payloadInLength-1; i++){
            checksum += payloadIn[i];
          }
          checksum = checksum%255;
          if (verbose == true) println(checksum);

          
          // compare the checksums
          if ( checksum == payloadIn[payloadInLength-1] ){
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
      println(state);
    }
    
  }
} //serialEvent()

// *****


// resets the state machine and sends a new packet
void serialRxReset(){ 
  state=0;
  payloadInIndex=0;
  checksum = 0;
  if (verbose == true) println("serialRxReset");
}// serialRxReset()

// *****


// takes action on the packet stored in payloadIn[]
void serialRxPacketHandler(){
  if (verbose == true) print("Packet Type: ");
  
  // deal with the payload of the packet
  switch(payloadIn[0]) { //first byte is the packet type
      case 0: // Error Packet
        // This is how the arduino comunicates errors to Processing
        print("Error: ");
        switch(payloadIn[1]) { //error type byte
          case 1:
            println("Type 1");
            break;
          default:
            print("Unknown error type");
            println(payloadIn[0]);            
            break;
        } // Error type switch
        break;
  
      case 1: // Ping packet
        print("Ping : ");
        println(millis()%255 - payloadIn[1]);
        print("Good/Error = ");
        print(good);
        print("/");
        println(error);
        break;
        
      default:
        print("Packet type error: ");
        println(payloadIn[0]);
        break;
  } // Packet type switch
  
}// serialRxPacketHandler()
