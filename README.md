# Arduino and Processing Serial Link
Examples of serial links between Arduino and Processing, in various configurations.

Written and tested with:
* Arduino 1.0.5
* Processing 2.1.1
* Arduino UNO, 2560
* MacOSX Mavericks


## Processing - Arduino
Provides a serial link, sending and receiving, between a computer running Processing and an Arduino.

### Arduino Side
Listens for incoming bytes, and sends them back. Tracks status of serial link with a boolean and the LED on pin 13.

### Processing Side
Broadcasts packets of random length (1 to 10 bytes) with random contents (bytes 0-100), 
at a rate specified by frameRate(N). Prints sent packets and any received bytes. Tracks status of incoming serial traffic a boolean.

Packet format
* StartByte1
* StartByte2
* LengthByte = 1 + number of payload bytes
* Payload Bytes
* CheckByte = sum of payload bytes % 255


## Arduino - Arduino (to be created in a future commit)
Two Arduinos. One is the master and the other is the slave.


## Processing - Arduino - Arduino  (to be created in a future commit)
Processing and two Arduinos in a daisychain configuration. Different serial ports are used. Processing and Arduino 1 are on a separate serial link from Arduino 1 and Arduino 2.