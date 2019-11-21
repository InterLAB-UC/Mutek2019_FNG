import processing.net.*;

int port = 8088;       
Server myServer;        

void setup()
{
  size(400, 400);
  background(0);
  myServer = new Server(this, port);
}

void draw()
{
  //Obtiene el cliente en conexion
  Client thisClient = myServer.available();
  //Verifica si el cliente se conecta y envia informacion
  if (thisClient !=null) {
    String whatClientSaid = thisClient.readString();
    if (whatClientSaid != null) {
      println(thisClient.ip() + " --> " + whatClientSaid);
    } 
  } 
}
