

import processing.net.*; 
Client myClient;
String dataIn; 

void setup() {
  size(200, 200);
  // Connect to the local machine at port 5204.
  // This example will not run if you haven't
  // previously started a server on this port.
  myClient = new Client(this, "192.168.43.96", 8088);
}

void draw() {
  if (myClient.available() > 0) {
    dataIn = myClient.readString();
    println(dataIn);
  }
}
