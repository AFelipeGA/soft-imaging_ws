PImage label;
PShape can;
float angle;

PShader bwShader;

void setup() {
  size(640, 360, P3D);
  label = loadImage("media/lachoy.jpg");
  can = createCan(100, 200, 32, label);
  bwShader = loadShader("blackWhitefrag.glsl");
}

void draw() {
  background(0);
  
  shader(bwShader);
    
  translate(width/2, height/2);
  rotateY(angle);
  shape(can);
  angle += 0.01;

    println("FPS: " + int(frameRate), 0, 0);
}

PShape createCan(float r, float h, int detail, PImage tex) {
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  sh.texture(tex);
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);
    float z = cos(i * angle);
    float u = float(i) / detail;
    sh.normal(x, 0, z);
    sh.vertex(x * r, -h/2, z * r, u, 0);
    sh.vertex(x * r, +h/2, z * r, u, 1);
  }
  sh.endShape();
  return sh;
}

/* import g4p_controls.*;
import processing.video.*;

// Class with static variables that emulate an Enum since it is not supported
class ContentType {
  static final int IMAGE = 1;
  static final int VIDEO = 2;
}

PGraphics base, modified; // PGraphics
PImage img, catImg, baboonImg, lenaImg; // Images
Movie video; // Video

GButton catButton, baboonButton, lenaButton, videoButton; // Buttons
GCheckbox meanCheck, ccirCheck, btCheck, smpteCheck; // Grayscale Buttons
GCheckbox edgeDetectionCheck, sharpenCheck, boxBlurCheck, gaussianBlurCheck; // Masks Buttons

int contentType = ContentType.IMAGE;
int modifierType = 1; // 1=GrayScale
int segmentatinRange = 20; // range of segmentation option

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
  size(1152, 550);
  base = createGraphics(512, 300);
  modified = createGraphics(512, 300);
  
  catImg = loadImage("media/cat.jpg");
  baboonImg = loadImage("media/baboon.png");
  lenaImg = loadImage("media/lena.png");
  
  img = catImg;
  video = new Movie(this, "media/cat.mp4");
  video.loop();
  
  // Content Type Buttons
  catButton = new GButton(this, 25, 425, 100, 30, "Cat");
  catButton.addEventHandler(this, "handleCatButton");
  baboonButton = new GButton(this, 150, 425, 100, 30, "Baboon");
  baboonButton.addEventHandler(this, "handleBaboonButton");
  lenaButton = new GButton(this, 275, 425, 100, 30, "Lena");
  lenaButton.addEventHandler(this, "handleLenaButton");
  videoButton = new GButton(this, 25, 475, 100, 30, "Video");
  videoButton.addEventHandler(this, "handleVideoButton");
  
  // Grayscale Method Buttons
  meanCheck = new GCheckbox(this, 612, 400, 125, 25, "Mean");
  ccirCheck = new GCheckbox(this, 612, 425, 125, 25, "CCIR 601");
  btCheck = new GCheckbox(this, 612, 450, 125, 25, "BT. 709");
  smpteCheck = new GCheckbox(this, 612, 475, 125, 25, "SMPTE 240M");
  
  // Convolution Buttons
  edgeDetectionCheck = new GCheckbox(this, 775, 400, 125, 25, "Edge Detection");
  sharpenCheck = new GCheckbox(this, 775, 425, 125, 25, "Sharpen");
  boxBlurCheck = new GCheckbox(this, 775, 450, 125, 25, "Box Blur");
  gaussianBlurCheck = new GCheckbox(this, 775, 475, 125, 25, "Gaussian Blur");  
}

void draw() {
  background(128);
  // Text
  textSize(32);
  text("Original", 25, 35);
  text("Modified", 612, 35);
  textSize(18);
  text("Content Type", 25, 390);
  text("Grayscale", 612, 390);
  text("Masks", 775, 390);

  // Base Canvas
  base.beginDraw();
  base.background(0);
  img.resize(512,300);
  switch(contentType){
    case ContentType.IMAGE:
      base.image(img, 0, 0);
      break;
     case ContentType.VIDEO:
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
  if(meanCheck.isSelected()){
    modified.pixels = blackAndWhite(modified.pixels, 1.0/3, 1.0/3, 1.0/3);
  }
  if(ccirCheck.isSelected()){
    modified.pixels = blackAndWhite(modified.pixels, 0.2989, 0.5870, 0.1140);
  }
  if(btCheck.isSelected()){
    modified.pixels = blackAndWhite(modified.pixels, 0.2126, 0.7152, 0.0722);
  }
  if(smpteCheck.isSelected()){
    modified.pixels = blackAndWhite(modified.pixels, 0.212, 0.701, 0.087);
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
  //if(contentType == ContentType.VIDEO){
    textSize(25);
    text("FPS: " + int(frameRate), 950, 400);
  //}

  modified.updatePixels();  
  modified.endDraw();
  
  image(modified, 612, 50);
}

color [] blackAndWhite(color[] pixelArray, float red, float green, float blue) {
  for(int i = 0; i < pixelArray.length; i++){
    float r = red(color(pixelArray[i])) * red;
    float g = green(color(pixelArray[i])) * green;
    float b = blue(color(pixelArray[i])) * blue;
    pixelArray[i] = color(r + g + b);
  }
  return pixelArray;
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

public void handleCatButton(GButton button, GEvent event){
  contentType = ContentType.IMAGE;
  img = catImg;
}


public void handleBaboonButton(GButton button, GEvent event){
  contentType = ContentType.IMAGE;
  img = baboonImg;
}

public void handleLenaButton(GButton button, GEvent event){
  contentType = ContentType.IMAGE;
  img = lenaImg;
}


public void handleVideoButton(GButton button, GEvent event){
  contentType = ContentType.VIDEO;
} */