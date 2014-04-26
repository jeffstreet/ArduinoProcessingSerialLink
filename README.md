# Arduino and Processing Serial Link
Examples of serial links between Arduino and Processing, in various configurations.

Written and tested with:
* Arduino 1.0.5
* Processing 2.1.1
* Arduino UNO, 2560
* MacOSX Mavericks


## Processing - Arduino
Provides a serial link, sending and receiving, between a computer running Processing and an Arduino.

### Arduino Side - 0.2
Uses state machine to handle incoming packets. Example ping packets implemented. racks status of serial link with a boolean and the SerialStatusLED on pin 13. Tracks status of Arduino serial actions with LED on pins 47, 49, 51, 53.

### Processing Side - 0.3
Broadcasts Ping packets with time stamp. Prints elapsed time for roundtrip. Uses state machine to handle incoming packets. Tracks status of incoming serial traffic as boolean.