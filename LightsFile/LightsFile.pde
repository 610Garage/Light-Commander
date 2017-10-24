  
BufferedReader reader;
String line;
int numPixels = 0;
int count = 0;
int frames;

ArrayList<int[]> buffer = new ArrayList<int[]>();
 
OPC opc;

void setup() {
  // Open the file from the createWriter() example
  reader = createReader("positions.txt");   
  
  
  opc = new OPC(this, "192.168.6.2", 7890);
  
  frameRate(5);
 
  while(true){
    try {
      line = reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
      line = null;
    }
    if (line == null) {
      
      numPixels = buffer.get(0).length-1;
      opc.setPixelCount(numPixels);
      // Stop reading because of an error or file is empty
      break;  
    } else {
      String[] pieces = split(line, ",");
      
      int PixelArray[] = new int[pieces.length-1];
      
      for (int i = 0; i < pieces.length-1; i++) {
        PixelArray[i] = Integer.parseInt(pieces[i]);
      }
      buffer.add(PixelArray);
    }
  }
  
  frameRate(15);
  frames = buffer.size()-1;
  
}
 
void draw() {
    
    if (opc.output == null) {
      // Try to (re)connect
      opc.connect();
    }
    
      if(count == frames){
        count = 0;
      }else{
        count++;
      }
      
      int ledAddress = 4;
      for (int i = 0; i < numPixels; i++) {
        int pixel = buffer.get(count)[i];
    
        opc.packetData[ledAddress] = (byte)(pixel >> 16);
        opc.packetData[ledAddress + 1] = (byte)(pixel >> 8);
        opc.packetData[ledAddress + 2] = (byte)pixel;
        ledAddress += 3;
        
      }
      
      
      opc.writePixels();
} 