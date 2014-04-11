/* 

Arduino and Processing Serial Link
PA - Arduino Side
Version 0.1

Provides a serial link, sending and receiving, between a computer running Processing and an Arduino.

Behavior:
Broadcasts byte 255 until it hears a reply. Then, listens for incoming bytes, and sends them back.

establishCOntact() borrowed from http://arduino.cc/en/Tutorial/SerialCallResponse

*/


void setup(){
  Serial.begin(115200); // open the serial port
  establishContact(); // connect with Processing
} //setup()


void loop(){
  // do nothing
} //loop()


// Broadcasts 255 until serial data is received
void establishContact() {
  while (Serial.available() <= 0) {
    Serial.write( (byte)255 );
    delay(100);
  }
}


// Called after each execution of loop()
// if there is serial data availble
void serialEvent(){
  // send the byte back
  Serial.write(Serial.read());
} // serialEvent()
