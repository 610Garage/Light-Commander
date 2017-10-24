import processing.video.*;
Movie myMovie;

OPC opc;
PrintWriter output;

ArrayList<Byte[]> pixles;
int counter = 0;
int puaseTime = 0;

void setup() {
  size(400, 400);
  myMovie = new Movie(this, "giphy (9).mp4");
  myMovie.play();
  
  // Connect to the local instance of fcserver
  opc = new OPC(this, "192.168.6.2", 7890);

float topY = height/8 + 10 * 3.5;
float widthY = width/2;
int offset = 40;
  int seperation = 20;
  opc.ledStrip(512   , 42, widthY , height/2+offset, seperation, 0, false);
  opc.ledStrip(1*64+512, 42, widthY, height/2-seperation+offset, seperation, 0, false);
  opc.ledStrip(2*64+512, 42, widthY, height/2-seperation*2+offset, seperation, 0, false);
  opc.ledStrip(3*64+512, 42, widthY, height/2-seperation*3+offset, seperation, 0, false);
  opc.ledStrip(4*64+512, 42, widthY, height/2-seperation*4+offset, seperation, 0, false);
  opc.ledStrip(5*64+512, 42, widthY, height/2-seperation*5+offset, seperation, 0, false);
  opc.ledStrip(6*64+512, 42, widthY, height/2-seperation*6+offset, seperation, 0, false);
  opc.ledStrip(7*64+512, 42, widthY, height/2-seperation*7+offset, seperation, 0, false);
  
  frameRate(15);
  
  output = createWriter("positions.txt");
  pixles = new ArrayList<Byte[]>();
}

void draw() {
  image(myMovie, 0, 0);
 
    if (opc.pixelLocations == null) {
      // No pixels defined yet
      return;
    }
 
    if (output == null) {
      // Try to (re)connect
      opc.connect();
    }
    if (output == null) {
      return;
    }
    if(puaseTime > 2){
      int numPixels = opc.pixelLocations.length;
      int ledAddress = 4;
  
      opc.setPixelCount(numPixels);
      loadPixels();
  
      for (int i = 0; i < numPixels; i++) {
        int pixelLocation = opc.pixelLocations[i]; //<>//
        int pixel = pixels[pixelLocation];
    
        output.print(str(pixel));
        output.print(",");
    
        opc.packetData[ledAddress] = (byte)(pixel >> 16);
        opc.packetData[ledAddress + 1] = (byte)(pixel >> 8);
        opc.packetData[ledAddress + 2] = (byte)pixel;
        ledAddress += 3;
        
  
        if (opc.enableShowLocations) {
          pixels[pixelLocation] = 0xFFFFFF ^ pixel;
        }
      }
      
      output.println("");
      output.flush(); // Writes the remaining data to the file
     
      opc.writePixels();
  
      if (opc.enableShowLocations) {
        updatePixels();
      }
    }else{
     puaseTime++; 
    }
    
    if(myMovie.time() > myMovie.duration()-.1){
      exit();
    }
}

void movieEvent(Movie m) {
  m.read();
}