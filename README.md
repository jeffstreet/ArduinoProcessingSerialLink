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


## Arduino - Arduino (to be created in a future commit)
Two Arduinos. One is the master and the other is the slave.


## Processing - Arduino - Arduino  (to be created in a future commit)
Processing and two Arduinos in a daisychain configuration. Different serial ports are used. Processing and Arduino 1 are on a separate serial link from Arduino 1 and Arduino 2.