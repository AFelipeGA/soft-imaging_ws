import g4p_controls.*;
import processing.video.*;

PGraphics base, modified; // PGraphics
PImage img; // Images
Movie video; // Video

GButton imageButton, videoButton; // Buttons
GCheckbox grayscaleCheck, histogramCheck, segmentationCheck, frameRateCheck, edgeDetectionCheck, sharpenCheck, boxBlurCheck, gaussianBlurCheck; 

int contentType = 1; // 1=Image, 2=Video
int modifierType = 1; // 1=GrayScale, 

float[][] sharpenMatrix =  { { 0, -1.0, 0 } , 
                             { -1.0, 5.0, -1.0 } ,
                             { 0, -1.0, 0 } } ;

float[][] edgeDetectionMatrix =  { { 1, 0, -1 } , 
                                   { 0, 0, 0 } ,
                                   { -1, 0, 1 } } ;
                                   

float[][] boxBlurMatrix =  { { 1.0/9, 1.0/9, 1.0/9 } , 
                             { 1.0/9, 1.0/9, 1.0/9 } ,
                             { 1.0/9, 1.0/9, 1.0/9 } } ;
                             
float[][] gaussianBlurMatrix =   { { 1.0/16, 1.0/8, 1.0/16 } , 
                                   { 1.0/8, 1.0/4, 1.0/8 } ,
                                   { 1.0/16, 1.0/8, 1.0/16 } } ;

void setup() {
  size(1152, 648);
  base = createGraphics(512, 300);
  modified = createGraphics(512, 300);
  
  img = loadImage("cat.jpg");
  video = new Movie(this, "cat.mp4");
  video.loop();
  
  // Content Type Buttons
  imageButton = new GButton(this, 25, 400, 100, 30, "Image");
  imageButton.addEventHandler(this, "handleImageButton");
  videoButton = new GButton(this, 25, 450, 100, 30, "Video");
  videoButton.addEventHandler(this, "handleVideoButton");
  
  // Modifier Type Buttons
  grayscaleCheck = new GCheckbox(this, 612, 400, 100, 25, "Grayscale");
  histogramCheck = new GCheckbox(this, 612, 425, 100, 25, "Histogram");
  segmentationCheck = new GCheckbox(this, 612, 450, 100, 25, "Segmentation");
  frameRateCheck = new GCheckbox(this, 612, 425, 100, 25, "Frame Rate");
  frameRateCheck.setVisible(false);
  
  // Convolution Buttons
  edgeDetectionCheck = new GCheckbox(this, 800, 400, 200, 25, "Edge Detection");
  sharpenCheck = new GCheckbox(this, 800, 425, 200, 25, "Sharpen");
  boxBlurCheck = new GCheckbox(this, 800, 450, 200, 25, "Box Blur");
  gaussianBlurCheck = new GCheckbox(this, 800, 475, 200, 25, "Gaussian Blur");
  
}

void draw() {
  background(128);
  // Text
  textSize(32);
  text("Original", 25, 35);
  text("Modificada", 612, 35);

  // Base Canvas
  base.beginDraw();
  base.background(0);
  img.resize(512,300);
  switch(contentType){
    case 1:
      base.image(img, 0, 0);
      break;
     case 2:
      base.image(video, 0, 0);
      break;
     default:
       break;
  }
  base.endDraw();
  base.loadPixels();
  image(base, 25, 50);

  // Modified Canvas
  modified.beginDraw();
  modified.background(0);
  modified.loadPixels();
  setPixels(base, modified);
  if(grayscaleCheck.isSelected()){
    modified.pixels = blackAndWhite(modified.pixels);
  }
  if(edgeDetectionCheck.isSelected()){
    modified.pixels = applyConvolution(modified.pixels, edgeDetectionMatrix, 3, modified.width);
  }
  if(sharpenCheck.isSelected()){
    modified.pixels = applyConvolution(modified.pixels, sharpenMatrix, 3, modified.width);
  }
  if(boxBlurCheck.isSelected()){
    modified.pixels = applyConvolution(modified.pixels, boxBlurMatrix, 3, modified.width);
  }
  if(gaussianBlurCheck.isSelected()){
    modified.pixels = applyConvolution(modified.pixels, gaussianBlurMatrix, 3, modified.width);
  }
  if(frameRateCheck.isSelected() && contentType==2){
    textSize(25);
    text("FPS: " + int(frameRate), 612, 375);
  }
  modified.updatePixels();  
  modified.endDraw();
  
  image(modified, 612, 50);
  
  if(histogramCheck.isSelected() && contentType==1){
    int[] hist = histogram(modified.pixels);
    int histMax = max(hist);
  
    stroke(255);
    for (int i = 0; i < img.width; i+=2) {
      int which = int(map(i, 0, img.width, 0, 255));
      int y = int(map(hist[which], 0, histMax, img.height, 0));
      line(612 + i, img.height + 50, 612 + i, y + 50);
    }
  }
  
}

color [] blackAndWhite(color[] pixelArray){
  for(int i = 0; i < pixelArray.length; i++){
    float r = red(color(pixelArray[i]));
    float g = green(color(pixelArray[i]));
    float b = blue(color(pixelArray[i]));
    pixelArray[i] = color((r + g + b) / 3);
  }
  return pixelArray;
}

int[] histogram(color[] pixelArray){
  int[] hist = new int[256]; 
  for (int i = 0; i < pixelArray.length; i++) {
    int bright = int(brightness(pixelArray[i]));
    hist[bright]++; 
  }
  
  return hist;
}

color[] applyConvolution(color[] pixelArray, float[][] matrix, int matrixsize, int imgWidth){
  color [] result = new color[pixelArray.length];
  for(int i=0; i<pixelArray.length; i++){
    result[i] = convolution(i%imgWidth, i/imgWidth, matrix, matrixsize, pixelArray);
  }
  return result;
}

color convolution(int x, int y, float[][] matrix, int matrixsize,  color[] pixelArray) {
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = matrixsize / 2;
  
  for (int i = 0; i < matrixsize; i++ ) {
    for (int j = 0; j < matrixsize; j++ ) {
      
      int xloc = x + i-offset;
      int yloc = y + j-offset;
      int loc = xloc + img.width*yloc;
      
      loc = constrain(loc,0,pixelArray.length-1);
      rtotal += (red(color(pixelArray[loc])) *matrix[i][j] );
      gtotal += (green(color(pixelArray[loc])) * matrix[i][j]);
      btotal += (blue(color(pixelArray[loc])) * matrix[i][j]);
    }
  }
  
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  
  return color(rtotal, gtotal, btotal); 
}

void setPixels(PGraphics in, PGraphics out){
  for(int i=0; i<in.pixels.length; i++){
    out.pixels[i] = in.pixels[i];
  }
}

void movieEvent(Movie m) {
  m.read();
}

public void handleImageButton(GButton button, GEvent event){
  contentType = 1;
  histogramCheck.setVisible(true);
  segmentationCheck.setVisible(true);
  frameRateCheck.setVisible(false);
}

public void handleVideoButton(GButton button, GEvent event){
  contentType = 2;
  histogramCheck.setVisible(false);
  segmentationCheck.setVisible(false);
  frameRateCheck.setVisible(true);
}
